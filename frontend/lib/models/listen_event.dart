import 'package:json_annotation/json_annotation.dart';

part 'listen_event.g.dart';

/// Sessions at or under this playtime are discarded (matches server-side
/// minListenDurationMs validation).
const minListenDurationMs = 4000;

@JsonSerializable()
class ListenEvent {
  @JsonKey(name: 'client_event_id')
  final String clientEventId;
  @JsonKey(name: 'track_id')
  final String trackId;
  @JsonKey(name: 'duration_ms')
  final int durationMs;
  @JsonKey(name: 'started_at')
  final DateTime startedAt;

  const ListenEvent({
    required this.clientEventId,
    required this.trackId,
    required this.durationMs,
    required this.startedAt,
  });

  factory ListenEvent.fromJson(Map<String, dynamic> json) => _$ListenEventFromJson(json);

  Map<String, dynamic> toJson() => _$ListenEventToJson(this);
}
