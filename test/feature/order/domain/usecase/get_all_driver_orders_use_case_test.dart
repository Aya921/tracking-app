import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import 'package:tracking_app/feature/order/domain/repository/order_repository.dart';
import 'package:tracking_app/feature/order/domain/usecase/get_all_driver_orders.dart';

import 'get_all_driver_orders_use_case_test.mocks.dart';

@GenerateMocks([OrderRepository])
void main() {
  late GetAllDriverOrdersUseCase useCase;
  late MockOrderRepository mockOrderRepository;

  const String tErrorMessage = 'Network Error';


  final tOrderDriverEntity = OrderDriverEntity(
    orders: const [], pagination: 12,
  );

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    useCase = GetAllDriverOrdersUseCase(mockOrderRepository);
  });

  group('GetAllDriverOrdersUseCase', () {
    const int tPage = 1;
    const int tLimit = 10;

    test('should call getDriverOrders on the repository and return SucessResult', () async {
      when(mockOrderRepository.getDriverOrders(page: tPage, limit: tLimit))
          .thenAnswer((_) async => SucessResult(tOrderDriverEntity));

      final result = await useCase(page: tPage, limit: tLimit);

      expect(result, isA<SucessResult<OrderDriverEntity>>());
      expect((result as SucessResult).sucessResult, tOrderDriverEntity);

      verify(mockOrderRepository.getDriverOrders(page: tPage, limit: tLimit)).called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });

    test('should return FailedResult when the repository call is unsuccessful', () async {
      when(mockOrderRepository.getDriverOrders(page: tPage, limit: tLimit))
          .thenAnswer((_) async => FailedResult(tErrorMessage));

      final result = await useCase(page: tPage, limit: tLimit);

      expect(result, isA<FailedResult<OrderDriverEntity>>());
      expect((result as FailedResult).errorMessage, tErrorMessage);

      verify(mockOrderRepository.getDriverOrders(page: tPage, limit: tLimit)).called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });
  });
}