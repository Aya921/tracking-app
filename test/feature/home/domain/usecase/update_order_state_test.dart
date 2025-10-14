import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_response_entity.dart';

import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';
import 'package:tracking_app/feature/home/domain/usecase/start_order_state.dart';



import 'add_data_to_remote_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late StartOrderStateUseCase useCase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = StartOrderStateUseCase(mockHomeRepository);
  });

  const orderId = "12345";
  final responseEntity = OrderResponseEntity(
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

        final mockResult = SucessResult<OrderResponseEntity>(responseEntity);
        provideDummy<Result<OrderResponseEntity>>(mockResult);
        when(
          mockHomeRepository.startOrder(orderId),
        ).thenAnswer((_) async => mockResult);

        // act
        final result = await useCase.startOrder(orderId);

        // assert
        expect(result, isA<SucessResult<OrderResponseEntity>>());

        verify(mockHomeRepository.startOrder(orderId)).called(1);
      },
    );

    test(
      'should return FailedResult when repository throws exception',
      () async {
        // arrange
       final mockResult = FailedResult<OrderResponseEntity>("Error starting order");
        provideDummy<Result<OrderResponseEntity>>(mockResult);
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
