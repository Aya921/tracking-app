import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/start_order_response_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';
import 'package:tracking_app/feature/home/domain/usecase/add_data_to_remote.dart';
import 'package:tracking_app/feature/home/domain/usecase/delete_local_order.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_pending_orders.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_saved_orders.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_data_from_remote.dart';
import 'package:tracking_app/feature/home/domain/usecase/save_data_to_local.dart';
import 'package:tracking_app/feature/home/domain/usecase/update_order_state.dart';

import 'home_use_cases_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockRepository;

  const String tOrderId = 'test_order_123';

  final tFakeUser = UserEntity(id: 'u1', firstName: 'F', lastName: 'U', email: 'a@a.com', gender: 'm', phone: '123', photo: '');
  final tFakeStore = StoreEntity(name: 'S', address: 'A', image: '', phoneNumber: '123', latLong: '');
  final tFakeShippingAddress = ShippingAddressEntity(street: 'St', city: 'C', phone: '123', lat: '1', long: '1');
  final tFakePaymentInfo = PaymentInfoEntity('cash', '2024', false);
  final tFakeOrderInfo = OrderInfoEntity(false, 'p', '#001', '2024', '2024', 0, 100);
  const tFakeDriver = DriverEntity(id: 'd1', country: '', firstName: '', lastName: '', vehicleType: '', vehicleNumber: '', vehicleLicense: '', nid: '', nidImg: '', email: '', gender: '', phone: '', photo: '', role: '', createdAt: '');


  final tOrderEntity = OrderEntity(
    id: tOrderId,
    user: tFakeUser,
    orderItems: const [],
    shippingAddress: tFakeShippingAddress,
    store: tFakeStore,
    paymentInfoEntity: tFakePaymentInfo,
    orderInfoEntity: tFakeOrderInfo,
  );

  final tOrderList = [tOrderEntity];
  final tStartOrderResponse = StartOrderResponseEntity(id: 's1', user: '', orderItems: const [], totalPrice: 0, paymentType: '', isPaid: false, isDelivered: false, state: '', orderNumber: '');
  final tRemoteData = RemoteDataEntity(tFakeDriver, tOrderEntity, null);
  final tOrderListResult = SucessResult<List<OrderEntity>?>(tOrderList);
  final tStartOrderResult = SucessResult<StartOrderResponseEntity>(tStartOrderResponse);
  final tVoidResult = SucessResult<void>(null);

  setUp(() {
    mockRepository = MockHomeRepository();
  });

  group('Home Use Cases Unit Tests', () {

    test('UpdateOrderStateUseCase should call startOrder and return result', () async {
      when(mockRepository.startOrder(tOrderId)).thenAnswer((_) async => tStartOrderResult);

      final useCase = UpdateOrderStateUseCase(mockRepository);
      final result = await useCase.startOrder(tOrderId);

      verify(mockRepository.startOrder(tOrderId)).called(1);
      expect(result, tStartOrderResult);
    });

    test('SaveDataToLocalUseCase should call saveDataToLocalStorage and return result', () async {
      when(mockRepository.saveDataToLocalStorage(tOrderList)).thenAnswer((_) async => tVoidResult);

      final useCase = SaveDataToLocalUseCase(mockRepository);
      final result = await useCase.saveDataToLocalStorage(tOrderList);

      verify(mockRepository.saveDataToLocalStorage(tOrderList)).called(1);
      expect(result, tVoidResult);
    });

    test('GetDataFromRemoteUseCase should call getOrderFromRemote and return stream', () async {
      final tRemoteStream = Stream.value(SucessResult<RemoteDataEntity>(tRemoteData));
      when(mockRepository.getOrderFromRemote(tOrderId)).thenAnswer((_) => tRemoteStream);

      final useCase = GetDataFromRemoteUseCase(mockRepository);
      final stream = useCase.getOrderFromRemote(tOrderId);

      expect(stream, emitsInOrder([SucessResult<RemoteDataEntity>(tRemoteData)]));
      verify(mockRepository.getOrderFromRemote(tOrderId)).called(1);
    });

    test('GetAllSavedOrdersUseCase should call getAllSavedOrders and return result', () async {
      when(mockRepository.getAllSavedOrders()).thenAnswer((_) async => tOrderListResult);

      final useCase = GetAllSavedOrdersUseCase(mockRepository);
      final result = await useCase.getAllSavedOrders();

      verify(mockRepository.getAllSavedOrders()).called(1);
      expect(result, tOrderListResult);
    });

    test('GetAllPendingOrdersUseCase should call getAllPendingOrders and return result', () async {
      when(mockRepository.getAllPendingOrders()).thenAnswer((_) async => tOrderListResult);

      final useCase = GetAllPendingOrdersUseCase(mockRepository);
      final result = await useCase.getAllPendingOrders();

      verify(mockRepository.getAllPendingOrders()).called(1);
      expect(result, tOrderListResult);
    });

    test('DeleteLocalOrderUseCase should call deleteOrder and return void result', () async {
      when(mockRepository.deleteOrder(tOrderId)).thenAnswer((_) async => tVoidResult);

      final useCase = DeleteLocalOrderUseCase(mockRepository);
      final result = await useCase.deleteOrder(tOrderId);

      verify(mockRepository.deleteOrder(tOrderId)).called(1);
      expect(result, tVoidResult);
    });

    test('AddDataToRemoteUseCase should call addDateToRemote and return void result', () async {
      when(mockRepository.addDateToRemote(tRemoteData)).thenAnswer((_) async => tVoidResult);

      final useCase = AddDataToRemoteUseCase(mockRepository);
      final result = await useCase.addDateToRemote(tRemoteData);

      verify(mockRepository.addDateToRemote(tRemoteData)).called(1);
      expect(result, tVoidResult);
    });
  });
}