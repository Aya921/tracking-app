import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/models/order_model/order_shipping_address_model.dart';

void main() {
  group('RemoteShippingAddressModel', () {
    group('test toEntity function', () {
      test(
        'should return correct ShippingAddressEntity when model is not null',
        () {
          // arrange
          final model = OrderShippingAddressModel(
            street: 'El Tahrir',
            city: 'Cairo',
            phone: '01123456789',
            lat: '30.0444',
            long: '31.2357',
          );

          // act
          final entity = OrderShippingAddressModel.toEntity(model);

          // assert
          expect(entity.street, model.street);
          expect(entity.city, model.city);
          expect(entity.phone, model.phone);
          expect(entity.lat, model.lat);
          expect(entity.long, model.long);
        },
      );

      test('should return default fake address when model is null', () {
        // act
        final entity = OrderShippingAddressModel.toEntity(null);

        // assert
        expect(entity.street, 'Zagazig');
        expect(entity.city, 'Sharkia');
        expect(entity.phone, '01010518802');
        expect(entity.lat, '31.7195459');
        expect(entity.long, '31.7195459');
      });
    });

    group('test fromEntity function', () {
      test('should map all fields correctly from entity to model', () {
        // arrange
        final entity = ShippingAddressEntity(
          street: 'El Tahrir',
          city: 'Cairo',
          phone: '01123456789',
          lat: '30.0444',
          long: '31.2357',
        );

        // act
        final model = OrderShippingAddressModel.fromEntity(entity);

        // assert
        expect(model.street, entity.street);
        expect(model.city, entity.city);
        expect(model.phone, entity.phone);
        expect(model.lat, entity.lat);
        expect(model.long, entity.long);
      });
    });
  });
}
