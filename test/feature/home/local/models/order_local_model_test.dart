import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'package:tracking_app/feature/home/local/models/order_local_model.dart';

void main() {
  group('OrderLocalModel Conversion Tests', () {
  
    final user = UserEntity(
      id: 'user1',
      firstName: 'Aya',
      lastName: 'Saber',
      email: 'aya@example.com',
      gender: 'female',
      phone: '0123456789',
      photo: 'https://example.com/photo.png',
    );

    final product = ProductEntity(
      id: 'p1',
      title: 'Flower',
      slug: 'flower',
      description: 'Beautiful flower',
      imgCover: 'cover.png',
      images: ['1.png', '2.png'],
      price: 100,
      priceAfterDiscount: 80,
      quantity: 5,
      category: 'Roses',
      occasion: 'Birthday',
    );

    final orderItem = OrderItemEntity(
      id: 'item1',
      price: 100,
      quantity: 2,
      product: product,
    );

    final shippingAddress = ShippingAddressEntity(
      street: 'Tahrir St',
      city: 'Cairo',
      phone: '0100000000',
      lat: '30.0444',
      long: '31.2357',
    );

    final store = StoreEntity(
      name: 'Aya Flowers',
      image: 'https://example.com/store.png',
      address: '123 Cairo Street',
      phoneNumber: '0100000000',
      latLong: '30.0444,31.2357',
    );

    final orderInfo = OrderInfoEntity(
      false, // isDelivered
      'on delivery', // state
      'ORD001', // orderNumber
      '2025-10-10', // createdAt
      '2025-10-11', // updatedAt
      1, // v
      200, // totalPrice
    );

    final paymentInfo = PaymentInfoEntity(
      'cash',
      '2025-10-10',
      true,
    );

    final orderEntity = OrderEntity(
      id: 'order123',
      user: user,
      orderItems: [orderItem],
      orderInfoEntity: orderInfo,
      shippingAddress: shippingAddress,
      paymentInfoEntity: paymentInfo,
      store: store,
    );

    test('toLocalModel() should convert OrderEntity to OrderLocalModel correctly', () {
      // act
      final model = OrderLocalModel.toLocalModel(orderEntity);

      // assert
      expect(model.orderId, orderEntity.id);
      expect(model.user.firstName, 'Aya');
      expect(model.orderItems.first.id, 'item1');
      expect(model.totalPrice, 200);
      expect(model.shippingAddress.city, 'Cairo');
      expect(model.paymentType, 'cash');
      expect(model.store.name, 'Aya Flowers');
      expect(model.state, 'on delivery');
      expect(model.orderNumber, 'ORD001');
      expect(model.v, 1);
    });

    test('toEntity() should convert OrderLocalModel back to OrderEntity correctly', () {
      // arrange
      final model = OrderLocalModel.toLocalModel(orderEntity);

      // act
      final convertedEntity = model.toEntity();

      // assert
      expect(convertedEntity.id, model.orderId);
      expect(convertedEntity.user.firstName, model.user.firstName);
      expect(convertedEntity.orderItems.first.id, model.orderItems.first.id);
      expect(convertedEntity.orderInfoEntity.totalPrice, model.totalPrice);
      expect(convertedEntity.shippingAddress.city, model.shippingAddress.city);
      expect(convertedEntity.paymentInfoEntity.paymentType, model.paymentType);
      expect(convertedEntity.store.name, model.store.name);
      expect(convertedEntity.orderInfoEntity.state, model.state);
      expect(convertedEntity.orderInfoEntity.orderNumber, model.orderNumber);
      expect(convertedEntity.orderInfoEntity.v, model.v);
    });
  });
}
