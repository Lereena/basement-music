// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lyrics _$LyricsFromJson(Map<String, dynamic> json) => Lyrics(
  id: (json['id'] as num).toInt(),
  trackName: json['trackName'] as String,
  artistName: json['artistName'] as String,
  instrumental: json['instrumental'] as bool? ?? false,
  duration: (json['duration'] as num?)?.toDouble(),
  plainLyrics: json['plainLyrics'] as String?,
  syncedLyrics: json['syncedLyrics'] as String?,
);
