// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listen_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListenStat _$ListenStatFromJson(Map<String, dynamic> json) => ListenStat(
  id: (json['id'] as num).toInt(),
  userEmail: json['user_email'] as String,
  trackId: json['track_id'] as String,
  trackTitle: json['track_title'] as String,
  trackArtist: json['track_artist'] as String,
  durationMs: (json['duration_ms'] as num).toInt(),
  startedAt: DateTime.parse(json['started_at'] as String),
);

Map<String, dynamic> _$ListenStatToJson(ListenStat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_email': instance.userEmail,
      'track_id': instance.trackId,
      'track_title': instance.trackTitle,
      'track_artist': instance.trackArtist,
      'duration_ms': instance.durationMs,
      'started_at': instance.startedAt.toIso8601String(),
    };

ListenStatsPage _$ListenStatsPageFromJson(Map<String, dynamic> json) =>
    ListenStatsPage(
      listens: (json['listens'] as List<dynamic>)
          .map((e) => ListenStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
    );

Map<String, dynamic> _$ListenStatsPageToJson(ListenStatsPage instance) =>
    <String, dynamic>{
      'listens': instance.listens,
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.pageSize,
    };
