import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'package:tracking_app/core/common/models/order_model/order_item_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_shipping_address_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_store_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_user_model.dart';


void main() {
  group("OrderModel", () {
    group('OrderModel.toEntity', () {
      test(
        'should convert OrderModel with all nested data correctly',
        () {
          // Arrange
          final model = OrderModel(
            id: 'order123',
            user: RemoteUserModel(
              id: 'user1',
              firstName: 'Aya',
              lastName: 'Saber',
              email: 'aya@email.com',
              gender: 'female',
              phone: '0101010101',
              photo: 'photo.png',
            ),
            orderItems: [
              OrderItemModel(id: 'item1', price: 100, quantity: 2),
            ],
            totalPrice: 200,
            shippingAddress: OrderShippingAddressModel(
              street: 'Zagazig',
              city: 'Sharkia',
              phone: '01010518802',
              lat: '31.7195459',
              long: '31.7195459',
            ),
            paymentType: 'cash',
            isPaid: true,
            paidAt: '2025-10-11',
            isDelivered: false,
            state: 'on delivery',
            createdAt: '2025-10-10',
            updatedAt: '2025-10-11',
            orderNumber: 'ORD001',
            v: 1,
            store: OrderStoreModel(
              name: 'Aya Flowers',
              image: 'store.png',
              address: 'Cairo',
              phoneNumber: '0100000000',
              latLong: '30.0444,31.2357',
            ),
          );

          // Act
          final entity = model.toEntity();

          // Assert
          expect(entity.id, model.id);
          expect(entity.user.firstName, model.user!.firstName);
          expect(entity.orderItems.length, model.orderItems!.length);
          expect(entity.orderInfoEntity.totalPrice, model.totalPrice);
          expect(entity.paymentInfoEntity.paymentType, model.paymentType);
          expect(entity.shippingAddress.city, model.shippingAddress!.city);
          expect(entity.store.name, model.store!.name);
          expect(entity.orderInfoEntity.state, model.state);
        },
      );

      test('should return default values when OrderModel is null', () {
        // Arrange
        final model = OrderModel();

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.id, '');
        expect(entity.user.firstName, 'Fake');
        expect(entity.user.email, 'fake@email.com');
        expect(entity.orderItems, isEmpty);
        expect(entity.orderInfoEntity.totalPrice, 0);
        expect(entity.paymentInfoEntity.paymentType, '');
        expect(entity.paymentInfoEntity.isPaid, false);
        expect(entity.shippingAddress.city, 'Sharkia');
        expect(entity.store.name, 'Fake Store');
        expect(entity.orderInfoEntity.state, '');
      });
    });

    group('OrderModel.fromEntity', () {
      test('should convert from OrderEntity to OrderModel correctly', () {
        // Arrange
        final entity = OrderEntity(
          id: 'order123',
          user: UserEntity(
            id: 'user1',
            firstName: 'Aya',
            lastName: 'Saber',
            email: 'aya@email.com',
            gender: 'female',
            phone: '0101010101',
            photo: 'photo.png',
          ),
          orderItems: [
            OrderItemEntity(
              id: 'item1',
              price: 100,
              quantity: 2,
              product: ProductEntity(
                id: 'p1',
                title: 'Flower',
                slug: 'flower',
                description: 'Nice flower',
                imgCover: 'flower.png',
                images: ['img1.png'],
                price: 100,
                priceAfterDiscount: 80,
                quantity: 5,
                category: 'cat1',
                occasion: 'occ1',
              ),
            ),
          ],
          orderInfoEntity: OrderInfoEntity(
            false,
            'on delivery',
            'ORD001',
            '2025-10-10',
            '2025-10-11',
            1,
            200,
          ),
          shippingAddress: ShippingAddressEntity(
            street: 'Zagazig',
            city: 'Sharkia',
            phone: '01010518802',
            lat: '31.7195459',
            long: '31.7195459',
          ),
          paymentInfoEntity: PaymentInfoEntity('cash', '2025-10-11', true),
          store: StoreEntity(
            name: 'Aya Flowers',
            image: 'store.png',
            address: 'Cairo',
            phoneNumber: '0100000000',
            latLong: '30.0444,31.2357',
          ),
        );

        // Act
        final model = OrderModel.fromEntity(entity);

        // Assert

        expect(entity.id, model.id);
        expect(entity.user.firstName, model.user?.firstName);
        expect(entity.orderItems.first.id, model.orderItems?.first.id);
        expect(entity.orderInfoEntity.totalPrice, model.totalPrice);
        expect(entity.shippingAddress.city, model.shippingAddress?.city);
        expect(entity.paymentInfoEntity.paymentType, model.paymentType);
        expect(entity.store.name, model.store?.name);
        expect(entity.orderInfoEntity.state, model.state);
        expect(entity.orderInfoEntity.orderNumber, model.orderNumber);
        expect(entity.orderInfoEntity.v, model.v);
      });
    });
  });
}
