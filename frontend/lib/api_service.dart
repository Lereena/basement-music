class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  String get trackInfo => '$baseUrl/api/track';

  String trackPlayback(String trackId) => '$trackInfo/$trackId';
}
