import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/local/models/store_local_model.dart';

void main() {
  group('StoreLocalModel Conversion Tests', () {

    final entity = StoreEntity(
      name: 'Aya Flowers',
      image: 'https://example.com/store.png',
      address: '123 Cairo Street',
      phoneNumber: '0100000000',
      latLong: '30.0444,31.2357',
    );

    test('fromEntity() should convert StoreEntity to StoreLocalModel correctly', () {
      // Act
      final model = StoreLocalModel.fromEntity(entity);

      // assert
      expect(model.name, entity.name);
      expect(model.image, entity.image);
      expect(model.address, entity.address);
      expect(model.phoneNumber, entity.phoneNumber);
      expect(model.latLong, entity.latLong);
    });

    test('toEntity() should convert StoreLocalModel back to StoreEntity correctly', () {
      // arrange
      final model = StoreLocalModel.fromEntity(entity);

      // act
      final convertedEntity = model.toEntity();

      // assert
      expect(convertedEntity.name, model.name);
      expect(convertedEntity.image, model.image);
      expect(convertedEntity.address, model.address);
      expect(convertedEntity.phoneNumber, model.phoneNumber);
      expect(convertedEntity.latLong, model.latLong);
    });
  });
}
