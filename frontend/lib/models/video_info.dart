import 'package:json_annotation/json_annotation.dart';

part 'video_info.g.dart';

@JsonSerializable()
class VideoInfo {
  @JsonKey(fromJson: _urlDecode)
  final String artist;
  @JsonKey(fromJson: _urlDecode)
  final String title;

  VideoInfo({required this.artist, required this.title});

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoFromJson(json);

  static String _urlDecode(String json) => Uri.decodeQueryComponent(json);
}
