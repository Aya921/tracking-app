import 'package:dio/dio.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/core/helper/shared_preference.dart';
import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)async {
    final token =await  SharedPreferHelper.getString(Constants.token);

    if (token != null) {
   options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
