import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';
import 'package:tracking_app/feature/home/domain/usecase/delete_local_order.dart';

import 'add_data_to_remote_test.mocks.dart';


@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockHomeRepository;
  late DeleteLocalOrderUseCase deleteLocalOrderUseCase;

  setUpAll(() {
    mockHomeRepository = MockHomeRepository();
    deleteLocalOrderUseCase = DeleteLocalOrderUseCase(mockHomeRepository);
  });

  group('DeleteLocalOrderUseCase Tests', () {
    test(
        'when call deleteOrder with valid id it should return SucessResult<void> and call repository once',
        () async {
      // arrange
      const orderId = 'order123';
      final mockResult = SucessResult<void>(null);
      provideDummy<Result<void>>(mockResult);

      when(mockHomeRepository.deleteOrder(orderId))
          .thenAnswer((_) async => mockResult);

      // act
      final res = await deleteLocalOrderUseCase.deleteOrder(orderId);

      // assert
      expect(res, isA<SucessResult<void>>());
      verify(mockHomeRepository.deleteOrder(orderId)).called(1);
    });

    test(
        'when call deleteOrder and repository returns error it should return FailedResult<void>',
        () async {
      // arrange
      const orderId = 'wrong_id';
      final mockResult = FailedResult<void>('Order not found');
      provideDummy<Result<void>>(mockResult);

      when(mockHomeRepository.deleteOrder(orderId))
          .thenAnswer((_) async => mockResult);

      // act
      final res = await deleteLocalOrderUseCase.deleteOrder(orderId);

      // assert
      expect(res, isA<FailedResult<void>>());
      final failed = res as FailedResult<void>;
      expect(failed.errorMessage, 'Order not found');
      verify(mockHomeRepository.deleteOrder(orderId)).called(1);
    });
  });
}
