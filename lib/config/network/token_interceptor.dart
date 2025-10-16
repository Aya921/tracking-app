import 'package:dio/dio.dart';

import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)async {
    final token =await UserLocalStorageImpl().getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
