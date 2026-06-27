import 'package:basement_music/models/soulseek_search_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'soulseek_search_results.g.dart';

/// Ticket identifying a started search; results are fetched incrementally with it.
@JsonSerializable()
class SoulseekSearchTicket {
  final int ticket;

  const SoulseekSearchTicket({required this.ticket});

  factory SoulseekSearchTicket.fromJson(Map<String, dynamic> json) => _$SoulseekSearchTicketFromJson(json);

  Map<String, dynamic> toJson() => _$SoulseekSearchTicketToJson(this);
}

/// Incremental search snapshot: results collected so far plus whether the
/// daemon's peer-response window has closed.
@JsonSerializable()
class SoulseekSearchResults {
  @JsonKey(defaultValue: [])
  final List<SoulseekSearchResult> results;
  @JsonKey(defaultValue: false)
  final bool done;

  const SoulseekSearchResults({required this.results, required this.done});

  factory SoulseekSearchResults.fromJson(Map<String, dynamic> json) => _$SoulseekSearchResultsFromJson(json);

  Map<String, dynamic> toJson() => _$SoulseekSearchResultsToJson(this);
}
