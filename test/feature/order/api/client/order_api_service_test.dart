import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/constants/end_points_constants.dart';
import 'package:tracking_app/feature/order/api/client/api%20_service/order_api_service.dart';
import 'package:tracking_app/feature/order/api/models/order_driver_response.dart';

import 'order_api_service_test.mocks.dart';

class FakeOrderDriverResponse extends Fake implements OrderDriverResponse {
}

@GenerateMocks([Dio, OrderApiService])
void main() {
  late MockDio mockDio;
  late OrderApiService apiService;

  const String tEndpoint = EndPointsConstants.getAllDriverOrders;
  const String tBaseUrl = EndPointsConstants.baseUrl;

  final Map<String, dynamic> tResponseJson = {
    'orders': [{'id': 1}],
    'pagination': {'page': 1, 'limit': 10}
  };

  final tResponse = Response(
    data: tResponseJson,
    statusCode: 200,
    requestOptions: RequestOptions(path: tEndpoint),
  );

  setUp(() {
    mockDio = MockDio();
    apiService = MockOrderApiService();
  });

  group('OrderApiService', () {
    const int tPage = 1;
    const int tLimit = 10;

    test('should return OrderDriverResponse when API call is successful', () async {
      when(apiService.getAllDriverOrders(tPage, tLimit))
          .thenAnswer((_) async => FakeOrderDriverResponse());

      final result = await apiService.getAllDriverOrders(tPage, tLimit);

      verify(apiService.getAllDriverOrders(tPage, tLimit)).called(1);

      expect(result, isA<OrderDriverResponse>());
    });

    test('should send GET request with correct path and query parameters', () async {
      when(mockDio.fetch<Map<String, dynamic>>(any)).thenAnswer((_) async => tResponse);

      final realApiService = OrderApiService(mockDio);

      await realApiService.getAllDriverOrders(tPage, tLimit);

      verify(mockDio.fetch(
        argThat(isA<RequestOptions>()
            .having((ro) => ro.method, 'method', 'GET')
            .having((ro) => ro.path, 'path', tBaseUrl + tEndpoint)
            .having((ro) => ro.queryParameters, 'queryParameters', {'page': tPage, 'limit': tLimit})
        ),
      )).called(1);
    });

    test('should throw DioError on failed API call (e.g., 404)', () async {
      final tDioError = DioException(
        requestOptions: RequestOptions(path: tEndpoint),
        response: Response(statusCode: 404, requestOptions: RequestOptions(path: tEndpoint)),
        type: DioExceptionType.badResponse,
      );

      when(mockDio.fetch<Map<String, dynamic>>(any)).thenThrow(tDioError);

      final realApiService = OrderApiService(mockDio);

      expect(
            () => realApiService.getAllDriverOrders(tPage, tLimit),
        throwsA(isA<DioException>()),
      );
    });
  });
}