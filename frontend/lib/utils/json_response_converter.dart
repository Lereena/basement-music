import 'dart:convert';

import 'package:dio/dio.dart';

class JsonResponseConverter extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is String) {
      response.data = json.decode(response.data as String);
    }
    super.onResponse(response, handler);
  }
}
