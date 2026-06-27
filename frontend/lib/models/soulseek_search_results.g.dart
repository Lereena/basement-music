// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soulseek_search_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoulseekSearchTicket _$SoulseekSearchTicketFromJson(
  Map<String, dynamic> json,
) => SoulseekSearchTicket(ticket: (json['ticket'] as num).toInt());

Map<String, dynamic> _$SoulseekSearchTicketToJson(
  SoulseekSearchTicket instance,
) => <String, dynamic>{'ticket': instance.ticket};

SoulseekSearchResults _$SoulseekSearchResultsFromJson(
  Map<String, dynamic> json,
) => SoulseekSearchResults(
  results:
      (json['results'] as List<dynamic>?)
          ?.map((e) => SoulseekSearchResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  done: json['done'] as bool? ?? false,
);

Map<String, dynamic> _$SoulseekSearchResultsToJson(
  SoulseekSearchResults instance,
) => <String, dynamic>{'results': instance.results, 'done': instance.done};
