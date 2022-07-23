import 'dart:convert';

import 'package:http/http.dart';

import 'log/log_service.dart';

Future<Response> getAsync(Uri uri, {Map<String, String>? headers}) async {
  return await _logRequest(() async => await get(uri, headers: headers));
}

Future<Response> patchAsync(
  Uri uri, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  return await _logRequest(() async => await patch(
        uri,
        headers: headers,
        body: body,
        encoding: encoding,
      ));
}

extension Logged on MultipartRequest {
  Future<Response> sendAsync() async {
    return await _logRequest(() async => await this.send());
  }
}

Future<Response> _logRequest(Function request) async {
  final response = await request();

  LogService.log(response.request.toString());
  LogService.log(response.body);

  return response;
}
