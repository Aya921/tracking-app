import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_error/api_error.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/core/common/models/metadata_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_item_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_model.dart';
import 'package:tracking_app/core/firebase_error/firebase_error.dart';

import 'package:tracking_app/feature/home/api/client/api%20_service/home_api_service.dart';
import 'package:tracking_app/feature/home/api/client/firebase_service/home_firebase_service.dart';
import 'package:tracking_app/feature/home/api/models/pending_order_response_model.dart';

import 'package:tracking_app/feature/home/api/models/remote_data_model.dart';

import 'package:tracking_app/core/common/models/order_model/order_product_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_shipping_address_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_store_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_user_model.dart';
import 'package:tracking_app/feature/home/api/models/update_state_order_items.dart';
import 'package:tracking_app/feature/home/api/models/update_state_order_model.dart';
import 'package:tracking_app/feature/home/api/models/update_state_response_model.dart';
import 'package:tracking_app/feature/home/api/source/home_remote_data_source_imp.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
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

import 'home_remote_data_source_imp_test.mocks.dart';

@GenerateMocks([HomeApiService, HomeFirebaseService])
void main() {
  late HomeRemoteDataSourceImp homeRemoteDataSourceImp;
  late MockHomeApiService mockHomeApiService;
  late MockHomeFirebaseService mockHomeFirebaseService;
  late List<OrderModel> fakeRemoteOrder;
  late PendingOrderResponseModel fakeOrderResponse;
  late UpdateStateResponseModel fakeUpdateStateResponse;
  late RemoteDataEntity remoteDataEntity;
  late UserEntity user;
  late ProductEntity product;
  late StoreEntity store;
  late List<OrderItemEntity> orderItems;
  late ShippingAddressEntity shippingAddress;
  late PaymentInfoEntity paymentInfo;
  late OrderInfoEntity orderInfo;
  late OrderEntity order;
  late DriverEntity driverEntity;

  setUpAll(() {
    mockHomeFirebaseService = MockHomeFirebaseService();
    mockHomeApiService = MockHomeApiService();
    homeRemoteDataSourceImp = HomeRemoteDataSourceImp(
      mockHomeApiService,
      mockHomeFirebaseService,
    );

    fakeRemoteOrder = [
      OrderModel(
        id: "68e934597fee68a4c2eaa5bd",
        isDelivered: false,
        isPaid: false,
        paymentType: "cash",
        paidAt: "",
        orderNumber: "#125777",
        totalPrice: 4469,
        state: "inProgress",
        createdAt: "2025-10-10T16:29:13.506Z",
        updatedAt: "2025-10-10T16:29:13.506Z",
        v: 0,
        user: RemoteUserModel(
          id: "user_123",
          firstName: "Saber",
          lastName: "saber",
          email: "aya@example.com",
          phone: "01010518802",
        ),
        shippingAddress: OrderShippingAddressModel(
          city: "Sharkia",
          street: "Zagazig",
          lat: "31.7195459",
          long: "31.7195459",
          phone: "01010518802",
        ),
        store: OrderStoreModel(
          name: "Elevate FlowerApp Store",
          address: "123 Fixed Address, City, Country",
          phoneNumber: "1234567890",
          image: "https://www.elevateegy.com/elevate.png",
          latLong: "37.7749,-122.4194",
        ),
        orderItems: [
          OrderItemModel(
            id: "68d05bdadd8937e0573ee54a",
            price: 1200,
            quantity: 1,
            product: OrderProductModel(
              id: "673e32c7115992017182817b",
              title: "Moko's Assorted Chocolate Box | Bright Roses",
              description:
                  "Presenting the Moko Chocolate Box, a luxurious indulgence crafted to delight the senses...",
              category: "673c479e1159920171827c99",
              imgCover: "772fba4d-4c99-480f-bc67-f3d28483648e-cover_image.png",
              images: [
                "05b528fc-7551-4a3d-8841-da0e8b97e049-image_four.png",
                "a3d326bf-c883-4a19-8445-cf15e44c0cd0-image_one.png",
                "cef9431f-6022-4d0d-b2c1-7282d0bc1a18-image_three.png",
                "0b8df0fc-19e1-4b39-80b5-1c52d0a196ee-image_two.png",
              ],
              price: 1200,
              priceAfterDiscount: 999,
              quantity: 355,
              slug: "moko's-assorted-chocolate-box-or-bright-roses",
            ),
          ),
        ],
      ),
    ];
    fakeOrderResponse = PendingOrderResponseModel(
      message: "Orders fetched successfully",
      metadata: MetadataModel(
        totalItems: 1,
        currentPage: 1,
        totalPages: 1,
        limit: 1,
      ),
      orders: fakeRemoteOrder,
    );

    fakeUpdateStateResponse = UpdateStateResponseModel(
      message: "Order state updated successfully",
      orders: UpdateStateOrderModel(
        id: "order_001",
        user: "user_123",
        totalPrice: 2500,
        paymentType: "cash",
        isPaid: false,
        isDelivered: false,
        state: "inProgress",
        createdAt: DateTime.parse("2025-10-10T16:29:13.506Z"),
        updatedAt: DateTime.parse("2025-10-10T16:29:13.506Z"),
        orderNumber: "#123456",
        v: 0,
        orderItems: [
          UpdateStateOrderItems(
            id: "item_001",
            price: 1200,
            quantity: 2,
            product: "product_123",
          ),
          UpdateStateOrderItems(
            id: "item_002",
            price: 1100,
            quantity: 1,
            product: "product_124",
          ),
        ],
      ),
    );

    driverEntity = const
    DriverEntity(
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

  group("test getAllPendingOrder Function", () {
    test(
      "when call getAllPendingOrder it should return SucessResult with orderResponseModel  ",
      () async {
        when(
          mockHomeApiService.getAllPendingOrders(),
        ).thenAnswer((_) async => fakeOrderResponse);

        //act

        final res = await homeRemoteDataSourceImp.getAllPendingOrders();

        //assert

        expect(res, isA<SucessResult<List<OrderEntity>?>>());
        final acResult = res as SucessResult<List<OrderEntity>?>;
        expect(acResult.sucessResult!.length, 1);
        expect(acResult.sucessResult![0].id, fakeRemoteOrder[0].id);
        verify(mockHomeApiService.getAllPendingOrders()).called(1);
      },
    );

    //................................................................................................................

    test(
      "when call getAllPendingOrder it should return Failed Result with dioException  ",
      () async {
        const String dioException = "dio Exception";
        final DioException mockDioException = DioException(
          requestOptions: RequestOptions(path: ''),
          message: dioException,
        );

        when(
          mockHomeApiService.getAllPendingOrders(),
        ).thenThrow(mockDioException);

        // act

        final res = await homeRemoteDataSourceImp.getAllPendingOrders();

        //assert

        expect(res, isA<FailedResult<List<OrderEntity>?>>());
        final acResult = res as FailedResult<List<OrderEntity>?>;
        expect(
          acResult.errorMessage,
          ServerFailure.fromDioError(mockDioException).errorMessage,
        );
        verify(mockHomeApiService.getAllPendingOrders()).called(1);
      },
    );

    //................................................................................................................

    test(
      "when call getAllPendingOrder it should return Failed Result with any exception   ",
      () async {
        const String exceptionMessage = "Exception";
        final Exception mockException = Exception(exceptionMessage);

        when(mockHomeApiService.getAllPendingOrders()).thenThrow(mockException);

        // act

        final res = await homeRemoteDataSourceImp.getAllPendingOrders();

        //assert

        expect(res, isA<FailedResult<List<OrderEntity>?>>());
        final acResult = res as FailedResult<List<OrderEntity>?>;
        expect(
          acResult.errorMessage.toString(),
          "Exception: $exceptionMessage",
        );
        verify(mockHomeApiService.getAllPendingOrders()).called(1);
      },
    );
  });

  //##############################################################################

  group("test startOrder Function", () {
    const orderId = "test_order_id";

    test(
      "when call startOrder it should return SuccessResult with StartOrderResponseEntity",
      () async {
        // arrange
        when(
          mockHomeApiService.startOrder(orderId),
        ).thenAnswer((_) async => fakeUpdateStateResponse);

        // act
        final res = await homeRemoteDataSourceImp.startOrder(orderId);

        // assert
        expect(res, isA<SucessResult<OrderResponseEntity>>());
        final acResult = res as SucessResult<OrderResponseEntity>;
        expect(acResult.sucessResult.id, fakeUpdateStateResponse.orders.id);
        verify(mockHomeApiService.startOrder(orderId)).called(1);
      },
    );

    //................................................................................................................
    test(
      "when call startOrder it should return FailedResult with DioException",
      () async {
        const String dioException = "dio Exception";
        final DioException mockDioException = DioException(
          requestOptions: RequestOptions(path: ''),
          message: dioException,
        );

        when(
          mockHomeApiService.startOrder(orderId),
        ).thenThrow(mockDioException);

        // act
        final res = await homeRemoteDataSourceImp.startOrder(orderId);

        // assert
        expect(res, isA<FailedResult<OrderResponseEntity>>());
        final acResult = res as FailedResult<OrderResponseEntity>;
        expect(
          acResult.errorMessage,
          ServerFailure.fromDioError(mockDioException).errorMessage,
        );
        verify(mockHomeApiService.startOrder(orderId)).called(1);
      },
    );

    //................................................................................................................
    test(
      "when call startOrder it should return FailedResult with Exception",
      () async {
        const String exceptionMessage = "Exception";
        final Exception mockException = Exception(exceptionMessage);

        when(mockHomeApiService.startOrder(orderId)).thenThrow(mockException);

        // act
        final res = await homeRemoteDataSourceImp.startOrder(orderId);

        // assert
        expect(res, isA<FailedResult<OrderResponseEntity>>());
        final acResult = res as FailedResult<OrderResponseEntity>;
        expect(
          acResult.errorMessage.toString(),
          "Exception: $exceptionMessage",
        );
        verify(mockHomeApiService.startOrder(orderId)).called(1);
      },
    );
  });

  //##############################################################################

  group("test addDateToRemote Function", () {
    test(
      "should call firebaseService.addOrders() successfully and return SuccessResult<void>",
      () async {
        // arrange
        when(
          mockHomeFirebaseService.addOrders(
            RemoteDataModel.fromEntity(remoteDataEntity),
          ),
        ).thenAnswer((_) async => Future.value());

        // act
        final res = await homeRemoteDataSourceImp.addDateToRemote(
          remoteDataEntity,
        );

        // assert
        expect(res, isA<SucessResult<void>>());
        verify(mockHomeFirebaseService.addOrders(any)).called(1);
      },
    );

    test(
      "should return FailedResult<void> when an any exception occurs",
      () async {
        // arrange
        when(
          mockHomeFirebaseService.addOrders(any),
        ).thenThrow(Exception("Exception"));

        // act
        final res = await homeRemoteDataSourceImp.addDateToRemote(
          remoteDataEntity,
        );

        // assert
        expect(res, isA<FailedResult<void>>());
        final result = res as FailedResult<void>;
        expect(result.errorMessage, contains("Exception"));
        verify(mockHomeFirebaseService.addOrders(any)).called(1);
      },
    );
    test(
      "should return FailedResult<void> when an firebase exception occurs",
      () async {
        // arrange
        final FirebaseException firebaseException = FirebaseException(
          plugin: "",
          message: "Exception: firebaseError",
        );
        when(
          mockHomeFirebaseService.addOrders(any),
        ).thenThrow(firebaseException);

        // act
        final res = await homeRemoteDataSourceImp.addDateToRemote(
          remoteDataEntity,
        );

        // assert
        expect(res, isA<FailedResult<void>>());
        final result = res as FailedResult<void>;
        expect(
          result.errorMessage,
          FirebaseErrorHandler.handle(firebaseException).errorMessage,
        );
        verify(mockHomeFirebaseService.addOrders(any)).called(1);
      },
    );
  });

  //##############################################################################

  group('test getOrderFromRemote Function', () {
    test(
      "should emit SuccessResult<RemoteDataEntity> when data is fetched successfully",
      () async {
        // arrange

        final remoteDataModel = RemoteDataModel.fromEntity(remoteDataEntity);

        when(
          mockHomeFirebaseService.getDataFromRemote('order123'),
        ).thenAnswer((_) => Stream.value(remoteDataModel));

        // act
        final resultStream = homeRemoteDataSourceImp.getOrderFromRemote(
          'order123',
        );

        // assert
        await expectLater(
          resultStream,
          emits(
            predicate<SucessResult<RemoteDataEntity>>((result) {
              final entity = result.sucessResult;
              return entity.driverEntity.id ==
                      remoteDataEntity.driverEntity.id &&
                  entity.orderEntity.id == remoteDataEntity.orderEntity.id &&
                  entity.orderDeliveryStatus ==
                      remoteDataEntity.orderDeliveryStatus;
            }),
          ),
        );

        verify(mockHomeFirebaseService.getDataFromRemote('order123')).called(1);
        verifyNoMoreInteractions(mockHomeFirebaseService);
      },
    );

    //------------------------------------------------------------------------------
    test("should emit FailedResult when an exception occurs", () async {
      // arrange
      when(
        mockHomeFirebaseService.getDataFromRemote('order123'),
      ).thenThrow(Exception("Exception"));

      // act
      final resultStream = homeRemoteDataSourceImp.getOrderFromRemote(
        'order123',
      );

      // assert
      await expectLater(
        resultStream,
        emits(
          isA<FailedResult>().having(
            (r) => (r).errorMessage,
            'errorMessage',
            contains("Exception"),
          ),
        ),
      );

      verify(mockHomeFirebaseService.getDataFromRemote('order123')).called(1);
    });

    test("should emit FailedResult when an fiebaseException occurs", () async {
      final FirebaseException firebaseException = FirebaseException(
        plugin: "",
        message: "Exception: firebaseError",
      );
      // arrange
      when(
        mockHomeFirebaseService.getDataFromRemote('order123'),
      ).thenThrow(Exception(firebaseException));

      // act
      final resultStream = homeRemoteDataSourceImp.getOrderFromRemote(
        'order123',
      );

      // assert
      await expectLater(
        resultStream,
        emits(
          isA<FailedResult>().having(
            (r) => (r).errorMessage,
            'errorMessage',
            contains('firebaseError'),
          ),
        ),
      );

      verify(mockHomeFirebaseService.getDataFromRemote('order123')).called(1);
    });
  });
}
