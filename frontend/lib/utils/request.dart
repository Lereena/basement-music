import 'dart:convert';

import 'package:http/http.dart';

import 'log/log_service.dart';

Future<Response> getAsync(Uri uri, {Map<String, String>? headers}) async {
  return _logRequest(() async => get(uri, headers: headers));
}

Future<Response> postAsync(
  Uri uri, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  return _logRequest(
    () async => post(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    ),
  );
}

Future<Response> patchAsync(
  Uri uri, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  return _logRequest(
    () async => patch(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    ),
  );
}

Future<Response> deleteAsync(
  Uri uri, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  return _logRequest(
    () async => delete(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    ),
  );
}

extension Logged on MultipartRequest {
  Future<Response> sendAsync() async {
    return _logRequest(() async => send());
  }
}

Future<Response> _logRequest(Function request) async {
  final response = await request() as Response;

  LogService.log(response.request.toString());
  LogService.log(response.body);

  return response;
}
