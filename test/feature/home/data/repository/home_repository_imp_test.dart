import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';

import 'package:tracking_app/feature/home/data/repository/home_repository_imp.dart';
import 'package:tracking_app/feature/home/data/source/home_local_data_source.dart';
import 'package:tracking_app/feature/home/data/source/home_remote_data_source.dart';

import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';

import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_item_entity.dart';

import 'home_repository_imp_test.mocks.dart';

import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_response_entity.dart';


@GenerateMocks([HomeRemoteDataSource, HomeLocalDataSource])
void main() {
  late MockHomeRemoteDataSource mockHomeRemoteDataSource;
  late MockHomeLocalDataSource mockHomeLocalDataSource;
  late HomeRepositoryImp homeRepositoryImp;
  late UserEntity user;
  late ProductEntity product;
  late StoreEntity store;
  late List<OrderItemEntity> orderItems;
  late ShippingAddressEntity shippingAddress;
  late PaymentInfoEntity paymentInfo;
  late OrderInfoEntity orderInfo;
  late OrderEntity order;
  late RemoteDataEntity remoteDataEntity;
  late DriverEntity driverEntity;

  setUpAll(() {
    mockHomeRemoteDataSource = MockHomeRemoteDataSource();
    mockHomeLocalDataSource = MockHomeLocalDataSource();
    homeRepositoryImp = HomeRepositoryImp(
      mockHomeRemoteDataSource,
      mockHomeLocalDataSource,
    );

    driverEntity = const DriverEntity(
      id: '1',
      firstName: 'Aya',
      lastName: 'Saber',
      contactInfo: ContactInfo(
        country: 'Egypt',
        gender: 'female',
        email: 'aya.saber@example.com',
        phone: '+201012345678',
        photo: 'default-profile.png',
      ),
      vehicle: VehicleInfo(
        type: 'Car',
        number: 'ABC-1234',
        license: 'license-image.png',
      ),
      identity: IdentityInfo(nid: '29812345678901', nidImg: 'nid-photo.png'),
      meta: MetaInfo(role: 'driver', createdAt: '2025-01-01T10:00:00.000Z'),
    );

    user = UserEntity(
      id: "user_1",
      firstName: "jana",
      lastName: "Tarek",
      email: "jana@example.com",
      gender: '',
      phone: '01111111111',
      photo: 'mmm.png',
    );
    product = ProductEntity(
      id: "prod_1",
      title: "Red Rose Bouquet",
      slug: "red-rose-bouquet",
      description:
          "A beautiful bouquet of fresh red roses, perfect for any occasion.",
      imgCover: "https://example.com/images/red_rose_cover.jpg",
      images: [
        "https://example.com/images/red_rose_1.jpg",
        "https://example.com/images/red_rose_2.jpg",
      ],
      price: 150,
      priceAfterDiscount: 120,
      quantity: 20,
      category: "Flowers",
      occasion: "Valentine's Day",
    );

    store = StoreEntity(
      name: "Flower Shop",
      image: "store_image_url",
      phoneNumber: "0222222222",
      address: 'giza',
      latLong: '1235',
    );

    orderItems = [
      OrderItemEntity(
        price: 50,
        quantity: 2,
        product: product,
        id: 'orderitem1',
      ),
    ];

    shippingAddress = ShippingAddressEntity(
      city: "Cairo",

      street: 'bb',
      phone: '011111',
      lat: '1234',
      long: '-1234',
    );

    paymentInfo = PaymentInfoEntity("Cash", "2025-10-10T12:00:00Z", true);

    orderInfo = OrderInfoEntity(
      true,
      "Delivered",
      "ORD-123456",
      "2025-10-09T09:00:00Z",
      "2025-10-11T10:00:00Z",
      1,
      170,
    );

    order = OrderEntity(
      id: "order_1",
      user: user,
      orderItems: orderItems,
      shippingAddress: shippingAddress,
      store: store,
      paymentInfoEntity: paymentInfo,
      orderInfoEntity: orderInfo,
    );

    remoteDataEntity = RemoteDataEntity(driverEntity, order, "Pending");
  });

  group("test getAllPendingOrders in HomeRepositoryImp", () {
    test(
      "when call getAllPendingOrders it should return SuccessResult with list of orders",
      () async {
        // arrange
        final orderList = [order];

        final mockResult = SucessResult<List<OrderEntity>?>(orderList);
        provideDummy<Result<List<OrderEntity>?>>(mockResult);

        when(
          mockHomeRemoteDataSource.getAllPendingOrders(),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.getAllPendingOrders();

        // assert
        expect(res, isA<SucessResult<List<OrderEntity>?>>());
        final acResult = res as SucessResult<List<OrderEntity>?>;
        expect(acResult.sucessResult, orderList);
        verify(mockHomeRemoteDataSource.getAllPendingOrders()).called(1);
      },
    );

    test(
      "when call getAllPendingOrders and fails it should return FailedResult",
      () async {
        // arrange
        final mockResult = FailedResult<List<OrderEntity>?>("error");
        provideDummy<Result<List<OrderEntity>?>>(mockResult);

        when(
          mockHomeRemoteDataSource.getAllPendingOrders(),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.getAllPendingOrders();

        // assert
        expect(res, isA<FailedResult<List<OrderEntity>?>>());
        final acResult = res as FailedResult<List<OrderEntity>?>;
        expect(acResult.errorMessage, "error");
        verify(mockHomeRemoteDataSource.getAllPendingOrders()).called(1);
      },
    );
  });

  group("test saveDataToLocalStorage in HomeRepositoryImp", () {
    test(
      "when call saveDataToLocalStorage with correct orders it should return SuccessResult<void>",
      () async {
        // arrange
        final orderList = [order];

        final mockResult = SucessResult<void>(null);
        provideDummy<Result<void>>(mockResult);

        when(
          mockHomeLocalDataSource.saveDataToLocalStorage(orderList),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.saveDataToLocalStorage(orderList);

        // assert
        expect(res, isA<SucessResult<void>>());
        verify(
          mockHomeLocalDataSource.saveDataToLocalStorage(orderList),
        ).called(1);
      },
    );

    test(
      "when call saveDataToLocalStorage and fails it should return FailedResult",
      () async {
        // arrange
        final orderList = [order];

        final mockResult = FailedResult<void>("error");
        provideDummy<Result<void>>(mockResult);

        when(
          mockHomeLocalDataSource.saveDataToLocalStorage(orderList),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.saveDataToLocalStorage(orderList);

        // assert
        expect(res, isA<FailedResult<void>>());
        final acResult = res as FailedResult<void>;
        expect(acResult.errorMessage, "error");
        verify(
          mockHomeLocalDataSource.saveDataToLocalStorage(orderList),
        ).called(1);
      },
    );
  });

  group("test getAllSavedOrders in HomeRepositoryImp", () {
    test(
      "when call getAllSavedOrders it should return SuccessResult with list of orders",
      () async {
        // arrange
        final orderList = [order];

        final mockResult = SucessResult<List<OrderEntity>?>(orderList);
        provideDummy<Result<List<OrderEntity>?>>(mockResult);

        when(
          mockHomeLocalDataSource.getAllSavedOrders(),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.getAllSavedOrders();

        // assert
        expect(res, isA<SucessResult<List<OrderEntity>?>>());
        final acResult = res as SucessResult<List<OrderEntity>?>;
        expect(acResult.sucessResult, orderList);
        verify(mockHomeLocalDataSource.getAllSavedOrders()).called(1);
      },
    );

    test(
      "when call getAllSavedOrders and fails it should return FailedResult",
      () async {
        // arrange
        final mockResult = FailedResult<List<OrderEntity>?>("error");
        provideDummy<Result<List<OrderEntity>?>>(mockResult);

        when(
          mockHomeLocalDataSource.getAllSavedOrders(),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.getAllSavedOrders();

        // assert
        expect(res, isA<FailedResult<List<OrderEntity>?>>());
        final acResult = res as FailedResult<List<OrderEntity>?>;
        expect(acResult.errorMessage, "error");
        verify(mockHomeLocalDataSource.getAllSavedOrders()).called(1);
      },
    );
  });

  group("test deleteOrder in HomeRepositoryImp", () {
    test(
      "when call deleteOrder with correct orderId it should return SuccessResult<void>",
      () async {
        // arrange
        const orderId = "123";

        final mockResult = SucessResult<void>(null);
        provideDummy<Result<void>>(mockResult);

        when(
          mockHomeLocalDataSource.deleteOrder(orderId),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.deleteOrder(orderId);

        // assert
        expect(res, isA<SucessResult<void>>());
        verify(mockHomeLocalDataSource.deleteOrder(orderId)).called(1);
      },
    );

    test(
      "when call deleteOrder and fails it should return FailedResult",
      () async {
        // arrange
        const orderId = "123";

        final mockResult = FailedResult<void>("error");
        provideDummy<Result<void>>(mockResult);

        when(
          mockHomeLocalDataSource.deleteOrder(orderId),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.deleteOrder(orderId);

        // assert
        expect(res, isA<FailedResult<void>>());
        final acResult = res as FailedResult<void>;
        expect(acResult.errorMessage, "error");
        verify(mockHomeLocalDataSource.deleteOrder(orderId)).called(1);
      },
    );
  });

  group("test startOrder in HomeRepositoryImp", () {
    test(
      "when call startOrder with correct orderId it should return SuccessResult<OrderResponseEntity>",
      () async {
        // arrange
        const orderId = "123";
        final fakeResponse = OrderResponseEntity(
          id: "1234",
          user: "19ri2921",
          orderItems: [
            OrderItemResponseEntity(
              product: "kefow",
              price: 123,
              quantity: 1,
              id: "2eefwe",
            ),
          ],
          totalPrice: 500,
          paymentType: "cash",
          isPaid: true,
          isDelivered: false,
          state: "outForDelivery",
          orderNumber: "#123",
        );

        final mockResult = SucessResult<OrderResponseEntity>(fakeResponse);
        provideDummy<Result<OrderResponseEntity>>(mockResult);

        when(
          mockHomeRemoteDataSource.startOrder(orderId),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.startOrder(orderId);

        // assert
        expect(res, isA<SucessResult<OrderResponseEntity>>());
        final acResult = res as SucessResult<OrderResponseEntity>;
        expect(acResult.sucessResult, fakeResponse);
        verify(mockHomeRemoteDataSource.startOrder(orderId)).called(1);
      },
    );

    test(
      "when call startOrder and fails it should return FailedResult",
      () async {
        // arrange
        const orderId = "123";

        final mockResult = FailedResult<OrderResponseEntity>("error");
        provideDummy<Result<OrderResponseEntity>>(mockResult);

        when(
          mockHomeRemoteDataSource.startOrder(orderId),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.startOrder(orderId);

        // assert
        expect(res, isA<FailedResult<OrderResponseEntity>>());
        final acResult = res as FailedResult<OrderResponseEntity>;
        expect(acResult.errorMessage, "error");
        verify(mockHomeRemoteDataSource.startOrder(orderId)).called(1);
      },
    );
  });

  group("test addDateToRemote in HomeRepositoryImp", () {
    test(
      "when call addDateToRemote with correct remoteData it should return SuccessResult<void>",
      () async {
        // arrange

        final mockResult = SucessResult<void>(null);
        provideDummy<Result<void>>(mockResult);

        when(
          mockHomeRemoteDataSource.addDateToRemote(remoteDataEntity),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.addDateToRemote(remoteDataEntity);

        // assert
        expect(res, isA<SucessResult<void>>());
        verify(
          mockHomeRemoteDataSource.addDateToRemote(remoteDataEntity),
        ).called(1);
      },
    );

    test(
      "when call addDateToRemote and fails it should return FailedResult",
      () async {
        // arrange
        final remoteData = remoteDataEntity;

        final mockResult = FailedResult<void>("error");
        provideDummy<Result<void>>(mockResult);

        when(
          mockHomeRemoteDataSource.addDateToRemote(remoteData),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await homeRepositoryImp.addDateToRemote(remoteData);

        // assert
        expect(res, isA<FailedResult<void>>());
        final acResult = res as FailedResult<void>;
        expect(acResult.errorMessage, "error");
        verify(mockHomeRemoteDataSource.addDateToRemote(remoteData)).called(1);
      },
    );
  });
}
