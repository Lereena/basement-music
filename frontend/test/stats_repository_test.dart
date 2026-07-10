import 'dart:convert';
import 'dart:io';

import 'package:basement_music/models/listen_event.dart';
import 'package:basement_music/repositories/connectivity_status_repository.dart';
import 'package:basement_music/repositories/stats_repository.dart';
import 'package:basement_music/rest_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class FakeRestClient extends Fake implements RestClient {
  final postedBatches = <List<ListenEvent>>[];
  Object? error;

  @override
  Future<void> postListens(List<ListenEvent> events) async {
    if (error != null) throw error!;
    postedBatches.add(events);
  }
}

class FakeConnectivityStatusRepository extends Fake implements ConnectivityStatusRepository {
  @override
  BehaviorSubject<List<ConnectivityResult>> statusSubject;

  FakeConnectivityStatusRepository({bool online = true})
    : statusSubject = BehaviorSubject.seeded([online ? ConnectivityResult.wifi : ConnectivityResult.none]);
}

ListenEvent event(String id, {int durationMs = 30000}) => ListenEvent(
  clientEventId: id,
  trackId: 'track-$id',
  durationMs: durationMs,
  startedAt: DateTime.utc(2026, 7, 10),
);

// Lets queued microtasks, stream events, and unawaited box writes (reconnect
// listener, fire-and-forget tryFlush) run to completion before assertions.
Future<void> settle() => pumpEventQueue(times: 100);

void main() {
  late Directory tempDir;
  late Box<String> box;
  late FakeRestClient restClient;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('stats_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>('listen_stats');
    restClient = FakeRestClient();
  });

  tearDown(() async {
    await settle();
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('finalized event is persisted and flushed when online', () async {
    final repo = StatsRepository(
      restClient,
      FakeConnectivityStatusRepository(),
      persistenceBox: box,
    );

    repo.addFinalized(event('e1'));
    await settle();

    expect(restClient.postedBatches, hasLength(1));
    expect(restClient.postedBatches.single.single.clientEventId, 'e1');
    expect(jsonDecode(box.get('pending')!), isEmpty);
  });

  test('offline events queue up, then flush on reconnect', () async {
    final connectivity = FakeConnectivityStatusRepository(online: false);
    final repo = StatsRepository(restClient, connectivity, persistenceBox: box);

    repo.addFinalized(event('e1'));
    repo.addFinalized(event('e2'));
    await settle();

    expect(restClient.postedBatches, isEmpty);
    expect(jsonDecode(box.get('pending')!), hasLength(2));

    connectivity.statusSubject.add([ConnectivityResult.wifi]);
    await settle();

    expect(restClient.postedBatches, hasLength(1));
    expect(restClient.postedBatches.single, hasLength(2));
    expect(jsonDecode(box.get('pending')!), isEmpty);
  });

  test('backlog over 500 events is flushed in chunks the server accepts', () async {
    final connectivity = FakeConnectivityStatusRepository(online: false);
    final repo = StatsRepository(restClient, connectivity, persistenceBox: box);

    for (var i = 0; i < 600; i++) {
      repo.addFinalized(event('e$i'));
    }
    await settle();
    expect(restClient.postedBatches, isEmpty);

    connectivity.statusSubject.add([ConnectivityResult.wifi]);
    await settle();

    expect(restClient.postedBatches, hasLength(2));
    expect(restClient.postedBatches[0], hasLength(500));
    expect(restClient.postedBatches[1], hasLength(100));
    expect(jsonDecode(box.get('pending')!), isEmpty);
  });

  test('failed flush keeps events queued for retry', () async {
    restClient.error = Exception('server down');
    final repo = StatsRepository(
      restClient,
      FakeConnectivityStatusRepository(),
      persistenceBox: box,
    );

    repo.addFinalized(event('e1'));
    await settle();
    expect(jsonDecode(box.get('pending')!), hasLength(1));

    restClient.error = null;
    await repo.tryFlush();

    expect(restClient.postedBatches, hasLength(1));
    expect(jsonDecode(box.get('pending')!), isEmpty);
  });

  test('pending queue is capped, oldest dropped first', () async {
    final repo = StatsRepository(
      restClient,
      FakeConnectivityStatusRepository(online: false),
      persistenceBox: box,
    );

    for (var i = 0; i < 1001; i++) {
      repo.addFinalized(event('e$i'));
    }
    await settle();

    final pending = jsonDecode(box.get('pending')!) as List;
    expect(pending, hasLength(1000));
    expect((pending.first as Map)['client_event_id'], 'e1');
    expect((pending.last as Map)['client_event_id'], 'e1000');
  });

  test('open session above threshold is recovered into pending on startup', () async {
    await box.put(
      'open_session',
      jsonEncode({
        'client_event_id': 'recovered',
        'track_id': 'track-1',
        'started_at': DateTime.utc(2026, 7, 10).toIso8601String(),
        'duration_ms': 5000,
      }),
    );

    StatsRepository(
      restClient,
      FakeConnectivityStatusRepository(),
      persistenceBox: box,
    );
    await settle();

    expect(box.get('open_session'), isNull);
    expect(restClient.postedBatches, hasLength(1));
    expect(restClient.postedBatches.single.single.clientEventId, 'recovered');
  });

  test('open session at or below threshold is discarded on startup', () async {
    await box.put(
      'open_session',
      jsonEncode({
        'client_event_id': 'too-short',
        'track_id': 'track-1',
        'started_at': DateTime.utc(2026, 7, 10).toIso8601String(),
        'duration_ms': minListenDurationMs,
      }),
    );

    StatsRepository(
      restClient,
      FakeConnectivityStatusRepository(),
      persistenceBox: box,
    );
    await settle();

    expect(box.get('open_session'), isNull);
    expect(restClient.postedBatches, isEmpty);
  });

  test('corrupted pending cache is cleared without crashing', () async {
    await box.put('pending', 'not json');

    final repo = StatsRepository(
      restClient,
      FakeConnectivityStatusRepository(),
      persistenceBox: box,
    );
    await settle();

    expect(box.get('pending'), isNull);

    repo.addFinalized(event('e1'));
    await settle();
    expect(restClient.postedBatches, hasLength(1));
  });

  test('sign-out flushes best-effort then clears queue and open session', () async {
    restClient.error = Exception('offline-ish');
    final repo = StatsRepository(
      restClient,
      FakeConnectivityStatusRepository(),
      persistenceBox: box,
    );

    repo.addFinalized(event('e1'));
    repo.saveOpenSession(
      clientEventId: 'open',
      trackId: 'track-1',
      startedAt: DateTime.utc(2026, 7, 10),
      durationMs: 10000,
    );
    await settle();

    await repo.flushAndClearForSignOut();

    expect(box.get('pending'), isNull);
    expect(box.get('open_session'), isNull);

    // Nothing left to sync for the next account.
    restClient.error = null;
    await repo.tryFlush();
    expect(restClient.postedBatches, isEmpty);
  });
}
