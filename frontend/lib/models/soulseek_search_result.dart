import 'package:json_annotation/json_annotation.dart';

part 'soulseek_search_result.g.dart';

@JsonSerializable()
class SoulseekSearchResult {
  @JsonKey(name: 'username')
  final String peerUsername;
  final String filename;
  final String extension;
  final int bitrate;
  final int size;
  @JsonKey(name: 'free_slots')
  final bool freeSlots;
  final int speed;

  const SoulseekSearchResult({
    required this.peerUsername,
    required this.filename,
    required this.extension,
    required this.bitrate,
    required this.size,
    required this.freeSlots,
    required this.speed,
  });

  factory SoulseekSearchResult.fromJson(Map<String, dynamic> json) => _$SoulseekSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SoulseekSearchResultToJson(this);
}
