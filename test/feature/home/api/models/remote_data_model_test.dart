import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_item_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/api/models/remote_data_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_driver_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_order_model.dart';
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';

void main() {
  group('RemoteDataModel ↔ RemoteDataEntity Conversion', () {
    group('toEntity()', () {
      test('should correctly convert model with data to entity', () {
        // Arrange
        final driverModel = RemoteDriverModel(
          id: '1',
          firstName: 'Aya',
          country: 'Egypt',
          phone: '01012345678',
        );

        final orderModel = RemoteOrderModel(
          id: '10',
          state: 'on delivery',
          totalPrice: 200,
          paymentType: 'cash',
          orderNumber: 'ORD001',
          v: 1,
        );

        final model = RemoteDataModel(
          driverModel: driverModel,
          orderModel: orderModel,
          orderDeliveryStatus: 'delivered',
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.driverEntity.id, driverModel.id);
        expect(entity.driverEntity.firstName, driverModel.firstName);
        expect(entity.orderEntity.id, orderModel.id);
        expect(entity.orderEntity.orderInfoEntity.totalPrice, orderModel.totalPrice);
        expect(entity.orderDeliveryStatus, model.orderDeliveryStatus);
      });

    
    });

    group('fromEntity()', () {
      test('should correctly convert entity to model', () {
        // Arrange
        const driverEntity =  DriverEntity(
          id: '1',
          firstName: 'Aya',
          country: 'Egypt',
          phone: '01012345678',
          lastName: '',
          vehicleType: '',
          vehicleNumber: '',
          vehicleLicense: '',
          nid: '',
          nidImg: '',
          email: '',
          gender: '',
          photo: '',
          role: '',
          createdAt: '',
        );

        final  orderEntity = OrderEntity(
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


        final  entity = RemoteDataEntity(
          driverEntity,
          orderEntity,
          'delivered',
        );

        // Act
        final model = RemoteDataModel.fromEntity(entity);

        // Assert
        expect(model.driverModel?.id, entity.driverEntity.id);
        expect(model.driverModel?.firstName, entity.driverEntity.firstName);
        expect(model.orderModel?.id, entity.orderEntity.id);
        expect(model.orderModel?.totalPrice, entity.orderEntity.orderInfoEntity.totalPrice);
        expect(model.orderDeliveryStatus, entity.orderDeliveryStatus);
      });
    });
  });
}
