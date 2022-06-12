const host = 'http://localhost:9000';
const wshost = 'ws://localhost:9000';

const reqAllTracks = '$host/tracks';
const trackInfo = '$host/track';
const downloadYt = '$host/yt/download?url=';

String trackPlayback(String trackId) => '$trackInfo/$trackId';
