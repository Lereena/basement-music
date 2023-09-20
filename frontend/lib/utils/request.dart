import 'dart:convert';

import 'package:http/http.dart';

import '../logger.dart';

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
  Future<StreamedResponse> sendAsync() async {
    final response = await send();

    logger.i(response.request.toString());

    return response;
  }
}

Future<Response> _logRequest(Function request) async {
  final response = await request() as Response;

  logger.i(response.request.toString());
  logger.i(response.body);

  return response;
}
