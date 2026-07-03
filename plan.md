# Listening Stats Collection (Wrapped groundwork)

## Context

Groundwork for Spotify-style "Wrapped" feature — data collection only, no UI. Every time user starts playing track, record listen; when play ends (next track / completion / pause), record how long they actually listened. Pause+resume of same track = one listen session, duration updated not new listen. Sessions under 4 seconds discarded. Works online + cached playback; offline events queued on-device, synced when connectivity returns.

Decisions:
- **Event log** in backend DB (one row per listen session) — enables monthly/seasonal Wrapped insights, not just totals.
- **Duration = actual accumulated playtime** (stopwatch while playing) — pauses excluded, seeks don't distort.

Sync policy: **only finalized sessions synced.** Pause stops stopwatch + persists open session locally; nothing POSTed till session ends (track change / completion / recovery after app kill). Server pure append with `ON CONFLICT (client_event_id) DO NOTHING` — no upserts, idempotent retries.

## 1. Backend (Go, do first — frontend flush needs endpoint)

**Create `backend/models/listen_event.go`** (mirror `backend/models/favourite.go`; use `gorm.io/gorm`, NOT legacy jinzhu):

```go
type ListenEvent struct {
    gorm.Model
    UserID        uint      `gorm:"not null;index"`
    TrackID       string    `gorm:"not null;index"`   // Track.Id UUID string
    DurationMs    int64     `gorm:"not null"`
    StartedAt     time.Time `gorm:"not null;index"`
    ClientEventID string    `gorm:"not null;uniqueIndex"`
}
```

**Create `backend/repositories/stats_repository.go`** (template: `backend/repositories/favourites_repository.go`):
- `StatsRepository{ DB *gorm.DB }` with `Init()` → `AutoMigrate(&models.ListenEvent{})`.
- `PostListens(w, r)`: `middleware.UserFromContext`; decode JSON array `[{track_id, duration_ms, started_at, client_event_id}]`; per-event validation (duration_ms > 4000, ≤ 6h cap, non-empty ids, RFC3339 started_at) — skip invalid rows, don't fail batch; force `UserID = user.ID`; reject batches > 500 events with 400; insert via `DB.Clauses(clause.OnConflict{Columns: [{Name: "client_event_id"}], DoNothing: true}).Create(&events)`; respond 201 on success (safe retry).

**Modify `backend/main.go`**: instantiate `statsRepo` + `Init()` near line 49; register on protected subrouter near line 105: `protected.HandleFunc("/user/listens", statsRepo.PostListens).Methods("POST")`.

## 2. Frontend model + REST

**Create `frontend/lib/models/listen_event.dart`** — `@JsonSerializable` with explicit snake_case `@JsonKey` names matching Go JSON tags: `clientEventId`, `trackId`, `durationMs`, `startedAt` (UTC ISO8601).

**Modify `frontend/lib/rest_client.dart`**:
```dart
@POST('/user/listens')
Future<void> postListens(@Body() List<Map<String, dynamic>> events);
```
Codegen: `fvm flutter pub run build_runner build --delete-conflicting-outputs` (project uses FVM).

## 3. Frontend StatsRepository (queue + flush)

**Create `frontend/lib/repositories/stats_repository.dart`** — constructor `(RestClient, ConnectivityStatusRepository, {required Box<String> persistenceBox})`. Follow JSON-list-in-`Box<String>` pattern from `frontend/lib/repositories/tracks_repository.dart:21-47`.

- Hive box `'listen_stats'`, two keys:
  - `'pending'` — JSON array of finalized unsynced events (cap ~1000, drop oldest).
  - `'open_session'` — JSON of in-progress session.
- `addFinalized(ListenEvent)` — append, persist, `tryFlush()`.
- `saveOpenSession(...)` / recovery in constructor: if `'open_session'` exists on launch (app was killed), promote to pending when accumulated > 4000ms, delete key.
- `tryFlush()`: guard on `_flushing` bool, offline (`connectivityStatusRepository.statusSubject.value.contains(ConnectivityResult.none)`), empty queue. POST whole batch; on success clear sent events; on any error leave queue intact (idempotent retry via client_event_id).
- Constructor subscribes `statusSubject`, calls `tryFlush()` on reconnect (pattern: `frontend/lib/bloc/tracks_cubit/tracks_cubit.dart:24-28`).
- `client_event_id` = `const Uuid().v4()` (`uuid` already in pubspec).

## 4. Frontend ListenTracker service

**Create `frontend/lib/services/listen_tracker.dart`** — plain class `(AudioPlayerHandler, StatsRepository)`. Hook the handler, NOT PlayerCubit: OS-notification skips call `handler.skipToNext()` directly, bypassing the cubit. Handler streams are the complete source of truth.

State: `_OpenSession? {clientEventId, trackId, startedAt(UTC), Stopwatch}` + periodic Timer.

Rules:
1. **`audioHandler.mediaItem` stream**: on emission with id != current session's trackId (or null) → finalize current session; if new item is real library track (`extras?['streamUrl'] == null`, same check as `AudioPlayerHandler.isPreview` at `audio_player_handler.dart:51`) start new session (stopped stopwatch, fresh UUID). **Previews (Soulseek temp tracks) excluded** — no session while streamUrl extra present. No `.distinct()` — repeat-one re-adds same-id item; that boundary handled by completion.
2. **`audioHandler.onPlayerStateChanged`**:
   - `playing` → `stopwatch.start()` (idempotent). If session null and current mediaItem non-preview (replay after completion) → start new session first — gives "complete → replay = new listen".
   - `paused` → `stopwatch.stop()` + `saveOpenSession` (kill-safe). Session stays open — same-track resume continues same stopwatch/session.
   - `completed` → finalize (natural end; also splits repeat-one into one session per full play). Ignore `stopped` alone — repeat path calls `stop()` mid-transition (`audio_player_handler.dart:143`).
3. **Periodic persistence**: `Timer.periodic(15s)` — while playing, `saveOpenSession` with current elapsed ms (covers hard kill mid-playback).
4. **`_finalize()`**: stop stopwatch; if elapsed > 4s → `addFinalized(ListenEvent(...))`, else discard. Always clear `'open_session'` and null out session.

## 5. Wiring

**Modify `frontend/lib/app.dart`**:
- Open `Hive.openBox<String>('listen_stats')` near lines 69-72.
- `StatsRepository(restClient, connectivityStatusRepository, persistenceBox: statsBox)` near line 78.
- After `AudioService.init` (line 97): `ListenTracker(audioHandler, statsRepository)` — keep reference, pass into `BasementMusic`.
- Register `statsRepository` in `frontend/lib/provider_wrapper.dart` RepositoryProviders (follow favouritesRepository pattern); export from `repositories/repositories.dart` barrel.

## Ordered steps

1. Backend model → repository → main.go wiring. Verify: `go build ./...`; run; curl POST 2-event array with token; re-send same array, confirm no duplicate rows.
2. Frontend model → rest_client endpoint → build_runner.
3. `stats_repository.dart` (queue, flush, reconnect, recovery).
4. `listen_tracker.dart`.
5. Wire app.dart / provider_wrapper.dart.

## Verification

`fvm flutter analyze`; run app, watch PrettyDioLogger + Postgres rows:
- Play >4s then skip → one event, duration ≈ played time.
- Play 2s then skip → no event.
- Play, pause 30s, resume, skip → one event, pause excluded.
- Seek forward mid-play → duration = real playtime, not position.
- Repeat-one across completion → two events.
- Soulseek preview → no events.
- Airplane mode: play cached track, skip → event stays in Hive; reconnect → auto-flush.
- Kill app mid-play → relaunch → recovered session flushed with last-persisted duration.

## Flagged edge cases

- **Kill-window loss**: up to 15s playtime lost on hard kill (periodic persist interval). Acceptable; tunable.
- **Buffering**: audioplayers keeps `playing` state during stalls → slight duration inflation on flaky streams. Accept for v1.
- **Platform event quirks**: audioplayers state event duplication/ordering varies (web especially); design tolerant (idempotent stopwatch, finalize keyed on mediaItem/completed) — test web + Android.
- **Logout/account switch**: queued events flush with current token. If multi-account matters, clear pending queue on sign-out (small AuthCubit addition) — decide before shipping.
- **Recovered session undercounts** by ≤15s — by design, never overcounts.
