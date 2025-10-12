import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';
import 'package:tracking_app/feature/home/local/models/shipping_address_local_model.dart';

void main() {
  group('ShippingAddressLocalModel Conversion Tests', () {

    final shippingEntity = ShippingAddressEntity(
      street: '12 Main St',
      city: 'Cairo',
      phone: '0123456789',
      lat: '30.0444',
      long: '31.2357',
    );

    test('fromEntity() should convert ShippingAddressEntity to model correctly', () {
      // act
      final model = ShippingAddressLocalModel.fromEntity(shippingEntity);

      // assert
      expect(model.street, shippingEntity.street);
      expect(model.city, shippingEntity.city);
      expect(model.phone, shippingEntity.phone);
      expect(model.lat, shippingEntity.lat);
      expect(model.long, shippingEntity.long);
    });

    test('toEntity() should convert ShippingAddressLocalModel back to entity correctly', () {
      // arrange
      final model = ShippingAddressLocalModel.fromEntity(shippingEntity);

      // act
      final entity = model.toEntity();

      // assert
      expect(entity.street, model.street);
      expect(entity.city, model.city);
      expect(entity.phone, model.phone);
      expect(entity.lat, model.lat);
      expect(entity.long, model.long);
    });
  });
}
