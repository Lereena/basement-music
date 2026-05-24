import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final token = await user.getIdToken(true);
          final opts = err.requestOptions
            ..headers['Authorization'] = 'Bearer $token';
          final dio = Dio(BaseOptions(baseUrl: opts.baseUrl));
          final response = await dio.fetch(opts);
          handler.resolve(response);
          return;
        } catch (_) {}
      }
    }
    handler.next(err);
  }
}
