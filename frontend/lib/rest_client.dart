import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/track.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'api/')
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET('/tracks')
  Future<List<Track>> getAllTracks();
}
