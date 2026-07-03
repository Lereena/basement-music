// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listen_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListenEvent _$ListenEventFromJson(Map<String, dynamic> json) => ListenEvent(
  clientEventId: json['client_event_id'] as String,
  trackId: json['track_id'] as String,
  durationMs: (json['duration_ms'] as num).toInt(),
  startedAt: DateTime.parse(json['started_at'] as String),
);

Map<String, dynamic> _$ListenEventToJson(ListenEvent instance) =>
    <String, dynamic>{
      'client_event_id': instance.clientEventId,
      'track_id': instance.trackId,
      'duration_ms': instance.durationMs,
      'started_at': instance.startedAt.toIso8601String(),
    };
