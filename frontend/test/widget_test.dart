// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:basement_music/app.dart';
import 'package:basement_music/app_config.dart';
import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/repositories/connectivity_status_repository.dart';
import 'package:basement_music/repositories/playlists_repository.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final restClient = RestClient(Dio());
    const config = AppConfig(baseUrl: '');
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      BasementMusic(
        config: config,
        audioHandler: AudioPlayerHandler(config),
        tracksRepository: TracksRepository(restClient),
        playlistsRepository: PlaylistsRepository(restClient),
        connectivityStatusRepository: ConnectivityStatusRepository(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
