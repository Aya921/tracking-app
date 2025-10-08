import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import 'package:tracking_app/feature/order/domain/repository/order_repository.dart';
import 'package:tracking_app/feature/order/domain/usecase/get_all_driver_orders.dart';

import 'get_all_driver_orders_use_case_test.mocks.dart';

@GenerateMocks([OrderRepository])
void main() {
  late MockOrderRepository mockRepository;
  late GetAllDriverOrdersUseCase useCase;

  // Mock Data
  final tOrderDriverEntity = OrderDriverEntity(orders: const []);
  const tPage = 1;
  const tLimit = 10;

  setUp(() {
    mockRepository = MockOrderRepository();
    useCase = GetAllDriverOrdersUseCase(mockRepository);
  });

  group('GetAllDriverOrdersUseCase', () {
    test('should call getDriverOrders from the repository with correct parameters', () async {
      when(mockRepository.getDriverOrders(page: tPage, limit: tLimit))
          .thenAnswer((_) async => SucessResult(tOrderDriverEntity));

      await useCase.call(page: tPage, limit: tLimit);

      verify(mockRepository.getDriverOrders(page: tPage, limit: tLimit)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return the same result (success) from the repository', () async {
      final expectedResult = SucessResult(tOrderDriverEntity);
      when(mockRepository.getDriverOrders(page: tPage, limit: tLimit))
          .thenAnswer((_) async => expectedResult);

      final result = await useCase.call(page: tPage, limit: tLimit);

      expect(result, expectedResult);
    });

    test('should return the same result (failure) from the repository', () async {
      const tErrorMessage = 'Connection Failed';
      final expectedResult = FailedResult<OrderDriverEntity>(tErrorMessage);
      when(mockRepository.getDriverOrders(page: tPage, limit: tLimit))
          .thenAnswer((_) async => expectedResult);

      final result = await useCase.call(page: tPage, limit: tLimit);

      expect(result, expectedResult);
    });
  });
}