import 'package:json_annotation/json_annotation.dart';

part 'listen_stats.g.dart';

/// One recorded listen session, as returned by the admin stats endpoint —
/// any user's listens, with track info joined in.
@JsonSerializable(fieldRename: FieldRename.snake)
class ListenStat {
  final int id;
  final String userEmail;
  final String trackId;
  final String trackTitle;
  final String trackArtist;
  final int durationMs;
  final DateTime startedAt;

  const ListenStat({
    required this.id,
    required this.userEmail,
    required this.trackId,
    required this.trackTitle,
    required this.trackArtist,
    required this.durationMs,
    required this.startedAt,
  });

  factory ListenStat.fromJson(Map<String, dynamic> json) => _$ListenStatFromJson(json);
  Map<String, dynamic> toJson() => _$ListenStatToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ListenStatsPage {
  final List<ListenStat> listens;
  final int total;
  final int page;
  final int pageSize;

  const ListenStatsPage({required this.listens, required this.total, required this.page, required this.pageSize});

  int get totalPages => total == 0 ? 1 : (total + pageSize - 1) ~/ pageSize;

  factory ListenStatsPage.fromJson(Map<String, dynamic> json) => _$ListenStatsPageFromJson(json);
  Map<String, dynamic> toJson() => _$ListenStatsPageToJson(this);
}
