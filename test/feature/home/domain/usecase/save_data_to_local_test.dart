import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';
import 'package:tracking_app/feature/home/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_item_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
import 'package:tracking_app/feature/home/domain/usecase/save_data_to_local.dart';

import 'add_data_to_remote_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockHomeRepository;
  late SaveDataToLocalUseCase saveDataToLocalUseCase;
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
    saveDataToLocalUseCase = SaveDataToLocalUseCase(mockHomeRepository);

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

  group('SaveDataToLocalUseCase Tests', () {
    test(
        'when call saveDataToLocalStorage with valid data it should return SucessResult<void> and call repository once',
        () async {
      // arrange
      final mockResult = SucessResult<void>(null);
      provideDummy<Result<void>>(mockResult);

      when(mockHomeRepository.saveDataToLocalStorage([order]))
          .thenAnswer((_) async => mockResult);

      // act
      final res =
          await saveDataToLocalUseCase.saveDataToLocalStorage([order]);

      // assert
      expect(res, isA<SucessResult<void>>());
      verify(mockHomeRepository.saveDataToLocalStorage([order])).called(1);
    });

    test(
        'when call saveDataToLocalStorage and repository returns error it should return FailedResult<void>',
        () async {
      // arrange
      final mockResult = FailedResult<void>('Failed to save orders');
      provideDummy<Result<void>>(mockResult);

      when(mockHomeRepository.saveDataToLocalStorage([order]))
          .thenAnswer((_) async => mockResult);

      // act
      final res =
          await saveDataToLocalUseCase.saveDataToLocalStorage([order]);

      // assert
      expect(res, isA<FailedResult<void>>());
      final failed = res as FailedResult<void>;
      expect(failed.errorMessage, 'Failed to save orders');
      verify(mockHomeRepository.saveDataToLocalStorage([order])).called(1);
    });
  });
}
