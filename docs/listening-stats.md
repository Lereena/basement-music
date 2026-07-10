# Listening Stats Collection (Wrapped groundwork)

Data collection groundwork for a future Spotify-style "Wrapped" feature. No UI yet — this just records listen events so historical data exists once Wrapped ships.

## What it tracks

One row per **listen session**: a user playing a track from start to finish (or until they skip/pause-and-never-return). Duration is **actual accumulated playtime** — a stopwatch that only runs while audio is actually playing. Pauses don't count. Seeking doesn't distort it.

Rules:
- Pause + resume on the same track = one session, not two. The stopwatch just stops and restarts.
- Sessions under 4 seconds are discarded (accidental taps, previews).
- Soulseek search previews (temp tracks, not saved to the library) are never tracked.
- Repeat-one across a full completion counts as two sessions — completion always finalizes and starts fresh on replay.
- Works offline: events queue on-device in Hive and sync automatically once connectivity returns.

## Architecture

```
AudioPlayerHandler (source of truth for playback state)
        │ mediaItem stream, onPlayerStateChanged stream
        ▼
ListenTracker (frontend/lib/services/listen_tracker.dart)
        │ finalized ListenEvent
        ▼
StatsRepository (frontend/lib/repositories/stats_repository.dart)
        │ queued in Hive box 'listen_stats', flushed over HTTP
        ▼
POST /api/user/listens  (backend/repositories/stats_repository.go)
        │ ON CONFLICT (client_event_id) DO NOTHING
        ▼
listen_events table (Postgres)
```

### Why ListenTracker hooks the audio handler, not PlayerCubit

OS notification controls (lock screen skip/pause) call `AudioPlayerHandler` methods directly, bypassing `PlayerCubit`. The handler's streams (`mediaItem`, `onPlayerStateChanged`) are the only complete picture of what's actually playing, so `ListenTracker` listens to those instead of app-level state.

### Sync policy: only finalized sessions are sent

Nothing is POSTed until a session ends (track change, natural completion, or recovery after an app kill). While playing, the open session is periodically persisted to Hive (every 15s) so a hard kill loses at most ~15s of playtime — never more, and the recovered session always **undercounts**, never overcounts.

The server insert is a pure append with `ON CONFLICT (client_event_id) DO NOTHING`, so retrying a POST (e.g. after a flaky connection) is always safe — no duplicate rows, no upsert logic needed.

## Backend

- `backend/models/listen_event.go` — `ListenEvent` GORM model: `UserID`, `TrackID`, `DurationMs`, `StartedAt`, `ClientEventID` (unique).
- `backend/repositories/stats_repository.go` — `POST /api/user/listens`:
  - Accepts a JSON array of `{track_id, duration_ms, started_at, client_event_id}`.
  - Per-event validation (duration > 4s, ≤ 6h cap, non-empty ids, valid RFC3339 timestamp) — invalid rows are skipped, not fail the whole batch.
  - Batches over 500 events are rejected with 400.
  - Forces `UserID` from the authenticated request, ignoring anything the client sends.
  - Responds `201` on success — safe to retry. A failed DB insert returns `500` so the client keeps the batch queued.
- `GET /api/admin/listens?page=N&page_size=M` (admin only) — all users' listen events, newest first, page size clamped to 100, with user email and track title/artist resolved. Surfaced in the app under Settings → admin section → "Listen events".
- `backend/repositories/stats_repository_test.go` — handler tests (validation, idempotency, batch limit) against a throwaway SQLite DB.

## Frontend

- `frontend/lib/models/listen_event.dart` — JSON model, snake_case wire format matching the Go tags.
- `frontend/lib/rest_client.dart` — `postListens(List<ListenEvent>)`.
- `frontend/lib/repositories/stats_repository.dart` — queue + flush:
  - Hive box `listen_stats`, two keys: `pending` (finalized, unsynced events, capped at 1000, drops oldest) and `open_session` (in-progress session, for kill recovery).
  - `addFinalized()` appends and immediately attempts a flush.
  - Flushes in chunks of 500 so a long offline backlog never trips the server's batch limit.
  - Flushes automatically on reconnect (subscribes to `ConnectivityStatusRepository`).
  - On app launch, if an `open_session` exists (previous run was killed mid-play), it's promoted to `pending` if it accumulated more than 4s, then discarded.
  - `flushAndClearForSignOut()` — best-effort push on sign-out, then the local queue is cleared unconditionally. The next login starts a fresh queue rather than carrying over data across accounts.
- `frontend/lib/services/listen_tracker.dart` — the state machine:
  - New `mediaItem` (different track, or null) → finalize current session; start a new one if the incoming track is a real library track (not a Soulseek preview).
  - `playing` → start/resume stopwatch (and open a session if one doesn't exist, e.g. replay after completion).
  - `paused` → stop stopwatch, persist the open session to Hive.
  - `completed` → finalize (also what splits repeat-one plays into separate sessions).
  - `Timer.periodic(15s)` persists the open session while playing, bounding kill-window data loss.
- Wired in `frontend/lib/app.dart` / `frontend/lib/provider_wrapper.dart`; `AuthCubit.signOut()` flushes and clears the queue before signing out.
- `frontend/test/stats_repository_test.dart` — queue/flush tests: chunking, offline queueing + reconnect flush, retry on failure, cap, kill recovery, sign-out clearing.

## Known limitations (accepted for v1)

- Up to ~15s of playtime can be lost on a hard app kill (periodic persist interval).
- `audioplayers` keeps `playing` state during buffering stalls, slightly inflating duration on flaky streams.
- Playback state event ordering/duplication varies by platform (web especially) — the design tolerates this via idempotent stopwatch starts and keying finalization off `mediaItem` changes / `completed`, not raw event counts.
