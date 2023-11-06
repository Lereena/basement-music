import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import 'models/track.dart';
import 'models/video_info.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'api/')
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET('/tracks')
  Future<List<Track>> getAllTracks();

  @GET('/tracks/search')
  Future<List<Track>> searchTracks(@Query('query') String query);

  @PATCH('/track/{id}')
  @FormUrlEncoded()
  Future<void> editTrack({
    @Path('id') required String id,
    @Field('artist') required String artist,
    @Field('title') required String title,
    @Field('cover') required String cover,
  });

  // TODO: fix
  @POST('/track/upload')
  @MultiPart()
  Future<void> uploadLocalTracks(
    @Part(name: "file") List<MultipartFile> files,
  );

  @GET('/yt/fetchVideoInfo')
  Future<VideoInfo?> fetchYtVideoInfo(@Query('url') String url);

  @GET('/yt/download')
  Future<void> uploadYtTrack(
    @Query('url') String url,
    @Query('artist') String artist,
    @Query('title') String title,
  );
}
