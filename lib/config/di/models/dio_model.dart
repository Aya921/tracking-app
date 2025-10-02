import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/network/token_interceptor.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';


@module
abstract class DioModule {
  @lazySingleton
  Dio provieDio(
      
      ) {
    final dio = Dio();
    dio.interceptors.add(getIt.get<PrettyDioLogger>());
    dio.options.headers = {Constants.contentType: Constants.appJson};
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
     dio.interceptors.add(TokenInterceptor());

    return dio;
  }

  @lazySingleton
  PrettyDioLogger get prettyDioLogger => PrettyDioLogger(
    request: true,
    requestBody: true,
    requestHeader: true,
    responseHeader: true,
    responseBody: true,
  );

  final cacheOptions = CacheOptions(
  store: MemCacheStore(),
  policy: CachePolicy.request, 
  maxStale: const Duration(days: 2),
);
}