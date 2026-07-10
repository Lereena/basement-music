import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/app_user.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/lyrics.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/registration_code.dart';
import 'package:basement_music/models/soulseek_connection.dart';
import 'package:basement_music/models/soulseek_search_results.dart';
import 'package:basement_music/models/soulseek_settings.dart';
import 'package:basement_music/models/soulseek_status.dart';
import 'package:basement_music/models/soulseek_temp_track.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/models/video_info.dart';

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

  @GET('/track/{id}/lyrics/file')
  Future<Lyrics> getFileLyrics(@Path('id') String id);

  @GET('/track/{id}/lyrics/search')
  Future<Lyrics> searchLyrics(@Path('id') String id);

  @POST('/track/{id}/lyrics')
  @FormUrlEncoded()
  Future<Track> saveLyrics({
    @Path('id') required String id,
    @Field('lyrics') required String lyrics,
  });

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

  @GET('/playlists/search')
  Future<List<Playlist>> searchPlaylists(@Query('query') String query);

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

  @PATCH('/playlist/{playlistId}/tracks/order')
  Future<void> reorderPlaylistTracks({
    @Path('playlistId') required String playlistId,
    @Body() required Map<String, dynamic> body,
  });

  @GET('/artists')
  Future<List<Artist>> getAllArtists();

  @GET('/artists/search')
  Future<List<Artist>> searchArtists(@Query('query') String query);

  @GET('/artist/{id}')
  Future<Artist> getArtist(@Path('id') String id);

  @PATCH('/admin/artist/{id}/image')
  @MultiPart()
  Future<void> updateArtistImage({
    @Path('id') required String id,
    @Part(name: 'image') required MultipartFile image,
  });

  @PATCH('/admin/artist/{id}')
  @FormUrlEncoded()
  Future<Artist> editArtist({
    @Path('id') required String id,
    @Field('name') required String name,
    @Field('description') required String description,
  });

  @PATCH('/admin/track/{trackId}/artists')
  @FormUrlEncoded()
  Future<Track> setTrackArtists({
    @Path('trackId') required String trackId,
    @Field('artistIds') required List<String> artistIds,
  });

  // Albums
  @GET('/albums')
  Future<List<Album>> getAllAlbums();

  @GET('/album/{id}')
  Future<Album> getAlbum(@Path('id') String id);

  @POST('/admin/album')
  @FormUrlEncoded()
  Future<Album> createAlbum({
    @Field('title') required String title,
    @Field('artistIds') required List<String> artistIds,
  });

  @PATCH('/admin/album/{id}')
  @FormUrlEncoded()
  Future<Album> editAlbum({
    @Path('id') required String id,
    @Field('title') required String title,
    @Field('year') required String year,
  });

  @DELETE('/admin/album/{id}')
  Future<void> deleteAlbum(@Path('id') String id);

  @PATCH('/admin/album/{id}/artists')
  @FormUrlEncoded()
  Future<Album> setAlbumArtists({
    @Path('id') required String id,
    @Field('artistIds') required List<String> artistIds,
  });

  @PATCH('/admin/album/{id}/tracks')
  @FormUrlEncoded()
  Future<Album> setAlbumTracks({
    @Path('id') required String id,
    @Field('trackIds') required List<String> trackIds,
  });

  @PATCH('/admin/track/{trackId}/album')
  @FormUrlEncoded()
  Future<void> setTrackAlbum({
    @Path('trackId') required String trackId,
    @Field('albumId') required String albumId,
  });

  @PATCH('/admin/album/{id}/image')
  @MultiPart()
  Future<void> updateAlbumImage({
    @Path('id') required String id,
    @Part(name: 'image') required MultipartFile image,
  });

  // Metadata (MusicBrainz / CoverArtArchive)
  @GET('/admin/artist/{id}/metadata/search')
  Future<List<ArtistCandidate>> searchArtistMetadata({
    @Path('id') required String id,
    @Query('query') required String query,
  });

  @GET('/admin/artist/{id}/metadata/preview')
  Future<ArtistMetadataPreview> previewArtistMetadata({
    @Path('id') required String id,
    @Query('mbid') required String mbid,
  });

  @POST('/admin/artist/{id}/metadata/apply')
  @FormUrlEncoded()
  Future<Artist> applyArtistMetadata({
    @Path('id') required String id,
    @Field('description') required String description,
    @Field('imageUrl') required String imageUrl,
  });

  @GET('/admin/album/{id}/cover/search')
  Future<List<ReleaseGroupCandidate>> searchAlbumCover({
    @Path('id') required String id,
    @Query('query') required String query,
  });

  @POST('/admin/album/{id}/cover/apply')
  @FormUrlEncoded()
  Future<Album> applyAlbumCover({
    @Path('id') required String id,
    @Field('mbid') required String mbid,
  });

  @PATCH('/admin/playlist/{id}/image')
  @MultiPart()
  Future<void> updatePlaylistImage({
    @Path('id') required String id,
    @Part(name: 'image') required MultipartFile image,
  });

  // Auth
  @POST('/auth/register')
  Future<AppUser> register(@Body() Map<String, dynamic> body);

  @GET('/auth/me')
  Future<AppUser> getMe();

  // Favourites
  @GET('/user/favourites')
  Future<List<Track>> getFavourites();

  @POST('/user/favourites/{trackId}')
  Future<void> addFavourite(@Path('trackId') String trackId);

  @DELETE('/user/favourites/{trackId}')
  Future<void> removeFavourite(@Path('trackId') String trackId);

  // Admin
  @POST('/admin/registration-codes')
  Future<RegistrationCode> generateRegistrationCode();

  @GET('/admin/registration-codes')
  Future<List<RegistrationCode>> getRegistrationCodes();

  // Soulseek
  @POST('/admin/soulseek/credentials')
  @FormUrlEncoded()
  Future<void> setSoulseekCredentials({
    @Field('username') required String username,
    @Field('password') required String password,
  });

  @GET('/admin/soulseek/status')
  Future<SoulseekStatus> getSoulseekStatus();

  @POST('/admin/soulseek/disconnect')
  Future<void> disconnectSoulseek();

  @GET('/admin/soulseek/settings')
  Future<SoulseekSettings> getSoulseekSettings();

  @POST('/admin/soulseek/settings')
  @FormUrlEncoded()
  Future<void> setSoulseekSettings({@Field('minutes') required int minutes});

  @GET('/soulseek/connection')
  Future<SoulseekConnection> getSoulseekConnection();

  @GET('/soulseek/search')
  Future<SoulseekSearchTicket> startSoulseekSearch(@Query('q') String query);

  @GET('/soulseek/search/results')
  Future<SoulseekSearchResults> getSoulseekSearchResults(@Query('ticket') int ticket);

  @POST('/soulseek/preload')
  @FormUrlEncoded()
  Future<SoulseekTempTrack> preloadSoulseekTrack({
    @Field('username') required String username,
    @Field('filename') required String filename,
  });

  @POST('/soulseek/save')
  @FormUrlEncoded()
  Future<Track> saveSoulseekTrack({
    @Field('id') required String id,
    @Field('artist') required String artist,
    @Field('title') required String title,
  });

  @DELETE('/soulseek/temp')
  Future<void> cleanupSoulseekSession();
}
