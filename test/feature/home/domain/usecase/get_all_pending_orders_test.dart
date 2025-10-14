import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';

import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_pending_orders.dart';

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
  late GetAllPendingOrdersUseCase getAllPendingOrdersUseCase;

  late UserEntity user;
  late ProductEntity product;
  late StoreEntity store;
  late List<OrderItemEntity> orderItems;
  late ShippingAddressEntity shippingAddress;
  late PaymentInfoEntity paymentInfo;
  late OrderInfoEntity orderInfo;
  late OrderEntity order;

  setUpAll(() {
    mockHomeRepository = MockHomeRepository();
    getAllPendingOrdersUseCase = GetAllPendingOrdersUseCase(mockHomeRepository);

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
  });

  group('GetAllPendingOrdersUseCase Tests', () {
    test(
      'when call getAllPendingOrders and repository returns data it should return SucessResult<List<OrderEntity>>',
      () async {
        // arrange
        final mockResult = SucessResult<List<OrderEntity>?>([order]);
        provideDummy<Result<List<OrderEntity>?>>(mockResult);

        when(
          mockHomeRepository.getAllPendingOrders(),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await getAllPendingOrdersUseCase.getAllPendingOrders();

        // assert
        expect(res, isA<SucessResult<List<OrderEntity>?>>());

        verify(mockHomeRepository.getAllPendingOrders()).called(1);
      },
    );

    test(
      'when call getAllPendingOrders and repository returns error it should return FailedResult<List<OrderEntity>>',
      () async {
        // arrange
        final mockResult = FailedResult<List<OrderEntity>?>('Database error');
        provideDummy<Result<List<OrderEntity>?>>(mockResult);

        when(
          mockHomeRepository.getAllPendingOrders(),
        ).thenAnswer((_) async => mockResult);

        // act
        final res = await getAllPendingOrdersUseCase.getAllPendingOrders();

        // assert
        expect(res, isA<FailedResult<List<OrderEntity>?>>());
        final failedResult = res as FailedResult<List<OrderEntity>?>;
        expect(failedResult.errorMessage, 'Database error');
        verify(mockHomeRepository.getAllPendingOrders()).called(1);
      },
    );
  });
}
