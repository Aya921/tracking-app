import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/start_order_response_entity.dart';
import 'package:tracking_app/feature/home/domain/usecase/add_data_to_remote.dart';
import 'package:tracking_app/feature/home/domain/usecase/delete_local_order.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_pending_orders.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_saved_orders.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_data_from_remote.dart';
import 'package:tracking_app/feature/home/domain/usecase/save_data_to_local.dart';
import 'package:tracking_app/feature/home/domain/usecase/update_order_state.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_states.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([
  GetAllPendingOrdersUseCase,
  SaveDataToLocalUseCase,
  GetAllSavedOrdersUseCase,
  DeleteLocalOrderUseCase,
  UpdateOrderStateUseCase,
  AddDataToRemoteUseCase,
  GetDataFromRemoteUseCase,
])
void main() {
  late MockGetAllPendingOrdersUseCase mockGetAllPendingOrders;
  late MockSaveDataToLocalUseCase mockSaveDataToLocal;
  late MockUpdateOrderStateUseCase mockUpdateOrderState;
  late MockAddDataToRemoteUseCase mockAddDataToRemote;

  late HomeViewModel viewModel;

  final tFakeUser = UserEntity(id: 'u1', firstName: 'Fake', lastName: 'User', email: 'a@a.com', gender: 'male', phone: '123', photo: '');
  final tFakeStore = StoreEntity(name: 'Fake Store', address: 'Fake Address', image: '', phoneNumber: '123', latLong: '');
  final tFakeShippingAddress = ShippingAddressEntity(street: 'St', city: 'City', phone: '123', lat: '', long: '');
  final tFakePaymentInfo = PaymentInfoEntity('cash', '2024', false);
  final tFakeOrderInfo = OrderInfoEntity(false, 'pending', '#001', '2024', '2024', 0, 100);
  const tFakeDriver = DriverEntity(id: 'd1', country: '', firstName: '', lastName: '', vehicleType: '', vehicleNumber: '', vehicleLicense: '', nid: '', nidImg: '', email: '', gender: '', phone: '', photo: '', role: '', createdAt: '');


  final tOrderEntity = OrderEntity(
      id: '123',
      user: tFakeUser,
      orderItems: const [],
      shippingAddress: tFakeShippingAddress,
      store: tFakeStore,
      paymentInfoEntity: tFakePaymentInfo,
      orderInfoEntity: tFakeOrderInfo);

  final tRemoteDataEntity = RemoteDataEntity(tFakeDriver, tOrderEntity, null);

  final tStartOrderResponse = StartOrderResponseEntity(
    id: 'start_id',
    user: 'u1',
    orderItems: const [],
    totalPrice: 200,
    paymentType: 'cash',
    isPaid: true,
    isDelivered: false,
    state: 'Started',
    orderNumber: '#999',
  );

  final tOrderList = [tOrderEntity];
  const tErrorMessage = 'Test Error';

  final tProcessEvent = StartProgressEvnet(tRemoteDataEntity);


  setUp(() {
    mockGetAllPendingOrders = MockGetAllPendingOrdersUseCase();
    mockSaveDataToLocal = MockSaveDataToLocalUseCase();
    mockUpdateOrderState = MockUpdateOrderStateUseCase();
    mockAddDataToRemote = MockAddDataToRemoteUseCase();

    viewModel = HomeViewModel(
      mockGetAllPendingOrders,
      mockSaveDataToLocal,
      MockGetAllSavedOrdersUseCase(),
      MockDeleteLocalOrderUseCase(),
      mockUpdateOrderState,
      mockAddDataToRemote,
      MockGetDataFromRemoteUseCase(),
    );
  });

  tearDown(() {
    viewModel.close();
  });

  group('StartOrderProcess', () {
    final initialState = HomeStates();


    blocTest<HomeViewModel, HomeStates>(
        'emits [loading, addedToRemote, orderStarted, success] on full success chain',
        build: () {
          when(mockAddDataToRemote.addDateToRemote(tRemoteDataEntity))
              .thenAnswer((_) async => SucessResult(null));

          when(mockUpdateOrderState.startOrder(tOrderEntity.id))
              .thenAnswer((_) async => SucessResult(tStartOrderResponse));

          when(mockGetAllPendingOrders.getAllPendingOrders())
              .thenAnswer((_) async => SucessResult(tOrderList));

          return viewModel;
        },
        act: (bloc) => bloc.add(tProcessEvent),
        expect: () => [
          initialState.copyWith(isLoading: true),
          initialState.copyWith(isLoading: true, addedToRemote: true),
          initialState.copyWith(isLoading: true, addedToRemote: true, orderStarted: true),
          initialState.copyWith(
            isLoading: true,
            addedToRemote: true,
            orderStarted: true,
            orders: tOrderList,
            processCompleted: true,
            remoteData: tRemoteDataEntity,
          ),
        ],
        verify: (bloc) {
          verify(mockAddDataToRemote.addDateToRemote(tRemoteDataEntity)).called(1);
          verify(mockUpdateOrderState.startOrder(tOrderEntity.id)).called(1);
          verify(mockGetAllPendingOrders.getAllPendingOrders()).called(1);
          verify(mockSaveDataToLocal.saveDataToLocalStorage(tOrderList)).called(1);
        }
    );

    blocTest<HomeViewModel, HomeStates>(
        'emits [loading, error] when AddDataToRemote fails',
        build: () {
          when(mockAddDataToRemote.addDateToRemote(tRemoteDataEntity))
              .thenAnswer((_) async => FailedResult(tErrorMessage));
          return viewModel;
        },
        act: (bloc) => bloc.add(tProcessEvent),
        expect: () => [
          initialState.copyWith(isLoading: true),
          initialState.copyWith(
            isLoading: false,
            errorMessage: tErrorMessage,
            addedToRemote: false,
          ),
        ],
        verify: (bloc) {
          verify(mockAddDataToRemote.addDateToRemote(tRemoteDataEntity)).called(1);
          verifyZeroInteractions(mockUpdateOrderState);
        }
    );

    blocTest<HomeViewModel, HomeStates>(
        'emits [loading, addedToRemote, error] when StartOrder fails',
        build: () {
          when(mockAddDataToRemote.addDateToRemote(tRemoteDataEntity))
              .thenAnswer((_) async => SucessResult(null));

          when(mockUpdateOrderState.startOrder(tOrderEntity.id))
              .thenAnswer((_) async => FailedResult(tErrorMessage));

          return viewModel;
        },
        act: (bloc) => bloc.add(tProcessEvent),
        expect: () => [
          initialState.copyWith(isLoading: true),
          initialState.copyWith(isLoading: true, addedToRemote: true),
          initialState.copyWith(
            isLoading: false,
            errorMessage: tErrorMessage,
            orderStarted: false,
          ),
        ],
        verify: (bloc) {
          verify(mockAddDataToRemote.addDateToRemote(tRemoteDataEntity)).called(1);
          verify(mockUpdateOrderState.startOrder(tOrderEntity.id)).called(1);
          verifyZeroInteractions(mockGetAllPendingOrders);
        }
    );
    blocTest<HomeViewModel, HomeStates>(
        'emits [loading, orderStarted, error] when GetPendingOrders fails',
        build: () {
          when(mockAddDataToRemote.addDateToRemote(tRemoteDataEntity))
              .thenAnswer((_) async => SucessResult(null));

          when(mockUpdateOrderState.startOrder(tOrderEntity.id))
              .thenAnswer((_) async => SucessResult(tStartOrderResponse));

          when(mockGetAllPendingOrders.getAllPendingOrders())
              .thenAnswer((_) async => FailedResult(tErrorMessage));

          return viewModel;
        },
        act: (bloc) => bloc.add(tProcessEvent),
        expect: () => [
          initialState.copyWith(isLoading: true),
          initialState.copyWith(isLoading: true, addedToRemote: true),
          initialState.copyWith(isLoading: true, addedToRemote: true, orderStarted: true),
          initialState.copyWith(
            isLoading: false,
            processCompleted: false,
            errorMessage: "Order started but refreshing orders failed. Please reload.",
          ),
        ],
        verify: (bloc) {
          verify(mockAddDataToRemote.addDateToRemote(tRemoteDataEntity)).called(1);
          verify(mockUpdateOrderState.startOrder(tOrderEntity.id)).called(1);
          verify(mockGetAllPendingOrders.getAllPendingOrders()).called(1);
          verifyZeroInteractions(mockSaveDataToLocal);
        }
    );
  });
}