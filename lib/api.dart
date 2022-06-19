import 'package:flutter/foundation.dart';

const host = kIsWeb ? 'http://localhost:9000' : 'http://10.0.2.2:9000';
const wshost = 'ws://localhost:9000';

const reqAllTracks = '$host/tracks';
const trackInfo = '$host/track';
const downloadYt = '$host/yt/download?url=';
const upload = '$host/track/upload';

String trackPlayback(String trackId) => '$trackInfo/$trackId';
