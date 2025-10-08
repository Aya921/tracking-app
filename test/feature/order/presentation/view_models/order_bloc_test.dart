import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import 'package:tracking_app/feature/order/domain/repository/order_repository.dart';
import 'package:tracking_app/feature/order/domain/usecase/get_all_driver_orders.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_bloc.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_events.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_states.dart';

import 'order_bloc_test.mocks.dart';

@GenerateMocks([GetAllDriverOrdersUseCase, OrderRepository])
void main() {
  late MockGetAllDriverOrdersUseCase mockUseCase;
  late MockOrderRepository mockRepository;
  late OrderBloc orderBloc;

  // Mock Data
  final tOrderDriverEntity = OrderDriverEntity(orders: const []);
  const tErrorMessage = 'Failed to fetch orders';
  const tPage = 1;
  const tLimit = 10;

  setUp(() {
    mockUseCase = MockGetAllDriverOrdersUseCase();
    mockRepository = MockOrderRepository();
    orderBloc = OrderBloc(mockUseCase, mockRepository);
  });

  tearDown(() {
    orderBloc.close();
  });

  const initialState = OrderStates();

  group('OrderBloc - GetDriverOrdersEvent', () {
    blocTest<OrderBloc, OrderStates>(
        'emits [loading, success] when data is fetched successfully',
        build: () {
          when(mockUseCase.call(page: tPage, limit: tLimit))
              .thenAnswer((_) async => SucessResult(tOrderDriverEntity));
          return orderBloc;
        },
        act: (bloc) => bloc.add(const GetDriverOrdersEvent(page: tPage, limit: tLimit)),
        expect: () => [
          initialState.copyWith(requestState: RequestState.loading),
          initialState.copyWith(
            requestState: RequestState.success,
            orders: tOrderDriverEntity,
          ),
        ],
        verify: (bloc) {
          verify(mockUseCase.call(page: tPage, limit: tLimit)).called(1);
        }
    );

    blocTest<OrderBloc, OrderStates>(
      'emits [loading, error] when data fetching fails',
      build: () {
        when(mockUseCase.call(page: tPage, limit: tLimit))
            .thenAnswer((_) async => FailedResult(tErrorMessage));
        return orderBloc;
      },
      act: (bloc) => bloc.add(const GetDriverOrdersEvent(page: tPage, limit: tLimit)),
      expect: () => [
        initialState.copyWith(requestState: RequestState.loading),
        initialState.copyWith(
          requestState: RequestState.error,
          errorMessage: tErrorMessage,
        ),
      ],
      verify: (bloc) {
        verify(mockUseCase.call(page: tPage, limit: tLimit)).called(1);
      },
    );
  });

  group('OrderBloc - RefreshDriverOrdersEvent', () {
    blocTest<OrderBloc, OrderStates>(
      'calls GetDriverOrders with default params and emits success',
      build: () {
        when(mockUseCase.call(page: tPage, limit: tLimit))
            .thenAnswer((_) async => SucessResult(tOrderDriverEntity));
        return orderBloc;
      },
      act: (bloc) => bloc.add(const RefreshDriverOrdersEvent()),
      expect: () => [
        initialState.copyWith(requestState: RequestState.loading),
        initialState.copyWith(
          requestState: RequestState.success,
          orders: tOrderDriverEntity,
        ),
      ],
      verify: (bloc) {
        verify(mockUseCase.call(page: tPage, limit: tLimit)).called(1);
      },
    );
  });
}