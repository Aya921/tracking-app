import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/start_order_response_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';
import 'package:tracking_app/feature/home/domain/usecase/update_order_state.dart';

import 'add_data_to_remote_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late UpdateOrderStateUseCase useCase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = UpdateOrderStateUseCase(mockHomeRepository);
  });

  const orderId = "12345";
  final responseEntity = StartOrderResponseEntity(
    id: '',
    user: '',
    orderItems: [],
    totalPrice: 12,
    paymentType: '',
    isPaid: true,
    isDelivered: true,
    state: '',
    orderNumber: '',
  );

  group('UpdateOrderStateUseCase', () {
    test(
      'should return SuccessResult when repository returns success',
      () async {
        // arrange

        final mockResult = SucessResult<StartOrderResponseEntity>(responseEntity);
        provideDummy<Result<StartOrderResponseEntity>>(mockResult);
        when(
          mockHomeRepository.startOrder(orderId),
        ).thenAnswer((_) async => mockResult);

        // act
        final result = await useCase.startOrder(orderId);

        // assert
        expect(result, isA<SucessResult<StartOrderResponseEntity>>());

        verify(mockHomeRepository.startOrder(orderId)).called(1);
      },
    );

    test(
      'should return FailedResult when repository throws exception',
      () async {
        // arrange
       final mockResult = FailedResult<StartOrderResponseEntity>("Error starting order");
        provideDummy<Result<StartOrderResponseEntity>>(mockResult);
        when(
          mockHomeRepository.startOrder(orderId),
        ).thenAnswer((_) async => mockResult);

        // act
        final result = await useCase.startOrder(orderId);

        // assert
        expect(result, isA<FailedResult>());
        expect((result as FailedResult).errorMessage, "Error starting order");
        verify(mockHomeRepository.startOrder(orderId)).called(1);
      },
    );
  });
}
