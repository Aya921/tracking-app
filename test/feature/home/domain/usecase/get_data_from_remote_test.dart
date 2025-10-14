import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_data_from_remote.dart';


import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';

import 'add_data_to_remote_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockHomeRepository;
  late GetDataFromRemoteUseCase getDataFromRemoteUseCase;
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
    mockHomeRepository = MockHomeRepository();
    getDataFromRemoteUseCase = GetDataFromRemoteUseCase(mockHomeRepository);

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

  group('GetDataFromRemoteUseCase Tests', () {
    test(
      'when call getOrderFromRemote with valid orderId it should emit SucessResult<RemoteDataEntity>',
      () async {
        // arrange
        const orderId = 'order456';
        final mockResult = SucessResult<RemoteDataEntity>(remoteDataEntity);
        provideDummy<Result<RemoteDataEntity>>(mockResult);

        when(
          mockHomeRepository.getOrderFromRemote(orderId),
        ).thenAnswer((_) => Stream.value(mockResult));

        // act
        final resultStream = getDataFromRemoteUseCase.getOrderFromRemote(
          orderId,
        );

        // assert
        await expectLater(
          resultStream,
          emits(isA<SucessResult<RemoteDataEntity>>()),
        );

        verify(mockHomeRepository.getOrderFromRemote(orderId)).called(1);
      },
    );

    test(
      'when call getOrderFromRemote and repository emits error it should emit FailedResult<RemoteDataEntity>',
      () async {
        // arrange
        const orderId = 'invalid_order';
        final mockResult = FailedResult<RemoteDataEntity>(
          'Order not found on remote',
        );
        provideDummy<Result<RemoteDataEntity>>(mockResult);

        when(
          mockHomeRepository.getOrderFromRemote(orderId),
        ).thenAnswer((_) => Stream.value(mockResult));

        // act
        final resultStream = getDataFromRemoteUseCase.getOrderFromRemote(
          orderId,
        );

        // assert
        await expectLater(
          resultStream,
          emits(isA<FailedResult<RemoteDataEntity>>()),
        );

        verify(mockHomeRepository.getOrderFromRemote(orderId)).called(1);
      },
    );
  });
}
