import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import 'models/playlist.dart';
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

  @POST('/track/upload')
  @MultiPart()
  Future<void> uploadLocalTracks(
    @Part(name: "files") List<MultipartFile> files,
  );

  @GET('/yt/fetchVideoInfo')
  Future<VideoInfo?> fetchYtVideoInfo(@Query('url') String url);

  @GET('/yt/download')
  Future<void> uploadYtTrack(
    @Query('url') String url,
    @Query('artist') String artist,
    @Query('title') String title,
  );

  @GET('/playlists')
  Future<List<Playlist>> getAllPlaylists();

  @GET('/playlist/{id}')
  Future<Playlist> getPlaylist(@Path('id') String id);

  @POST('/playlist/create/{name}')
  Future<Playlist> createPlaylist(@Path('name') String name);

  @PATCH('/playlist/{id}')
  @FormUrlEncoded()
  Future<void> editPlaylist({
    @Path('id') required String id,
    @Field('title') required String title,
    @Field('tracks') required List<String> tracks,
  });

  @DELETE('/playlist/{id}')
  Future<void> deletePlaylist(@Path('id') String id);

  @POST('/playlist/{playlistId}/track/{trackId}')
  Future<void> addTrackToPlaylist({
    @Path('playlistId') required String playlistId,
    @Path('trackId') required String trackId,
  });

  @DELETE('/playlist/{playlistId}/track/{trackId}')
  Future<void> removeTrackFromPlaylist({
    @Path('playlistId') required String playlistId,
    @Path('trackId') required String trackId,
  });
}
