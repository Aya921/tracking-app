import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/api/models/remote_data_model.dart';

void main() {
  late DriverEntity driverEntity;
  late UserEntity user;
  late ProductEntity product;
  late StoreEntity store;
  late List<OrderItemEntity> orderItems;
  late ShippingAddressEntity shippingAddress;
  late PaymentInfoEntity paymentInfo;
  late OrderInfoEntity orderInfo;
  late OrderEntity order;
  late RemoteDataEntity remoteDataEntity;
  setUpAll(() {
     driverEntity =const DriverEntity(
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
  
  
  
  group('RemoteDataModel ↔ RemoteDataEntity Conversion', () {
    group('toEntity()', () {
      test('should correctly convert model with data to entity', () {
        // Arrange

        final model = RemoteDataModel.fromEntity(remoteDataEntity);

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.driverEntity.id, driverEntity.id);
        expect(entity.driverEntity.firstName, driverEntity.firstName);
        expect(entity.orderEntity.id, order.id);
        expect(
          entity.orderEntity.orderInfoEntity.totalPrice,
          order.orderInfoEntity.totalPrice,
        );
        expect(entity.orderDeliveryStatus, model.orderDeliveryStatus);
      });
    });

    group('fromEntity()', () {
      test('should correctly convert entity to model', () {
     
        // Act
        final model = RemoteDataModel.fromEntity(remoteDataEntity);

        // Assert
        expect(model.driverModel?.id, remoteDataEntity.driverEntity.id);
        expect(model.driverModel?.firstName, remoteDataEntity.driverEntity.firstName);
        expect(model.orderModel?.id, remoteDataEntity.orderEntity.id);
        expect(
          model.orderModel?.totalPrice,
          remoteDataEntity.orderEntity.orderInfoEntity.totalPrice,
        );
        expect(model.orderDeliveryStatus, remoteDataEntity.orderDeliveryStatus);
      });
    });
  });
}
