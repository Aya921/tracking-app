import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/api/models/remote_store_model.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';

void main() {
  group('RemoteStoreModel', () {
    group('test toEntity function', () {
      test('should return correct StoreEntity when model is not null', () {
        // arrange
        final model = RemoteStoreModel(
          name: 'Super Store',
          image: 'https://example.com/store.png',
          address: '45 Downtown St, Cairo',
          phoneNumber: '01012345678',
          latLong: '30.0500,31.2400',
        );

        // act
        final entity = RemoteStoreModel.toEntity(model);

        // assert
        expect(entity.name, model.name);
        expect(entity.image, model.image);
        expect(entity.address, model.address);
        expect(entity.phoneNumber, model.phoneNumber);
        expect(entity.latLong, model.latLong);
      });

      test('should return default fake store when model is null', () {
        // act
        final entity = RemoteStoreModel.toEntity(null);

        // assert
        expect(entity.name, 'Fake Store');
        expect(entity.image, 'https://example.com/default-store.png');
        expect(entity.address, '123 Fake Street, Cairo, Egypt');
        expect(entity.phoneNumber, '0100000000');
        expect(entity.latLong, '30.0444,31.2357');
      });

      test('should fallback to default values when fields are null', () {
        // arrange
        final model = RemoteStoreModel();

        // act
        final entity = RemoteStoreModel.toEntity(model);

        // assert
        expect(entity.name, 'Fake Store');
        expect(entity.image, 'https://example.com/default-store.png');
        expect(entity.address, '123 Fake Street, Cairo, Egypt');
        expect(entity.phoneNumber, '0100000000');
        expect(entity.latLong, '30.0444,31.2357');
      });
    });

    group('test fromEntity function', () {
      test('should map all fields correctly from entity to model', () {
        // arrange
        final entity = StoreEntity(
          name: 'Super Store',
          image: 'https://example.com/store.png',
          address: '45 Downtown St, Cairo',
          phoneNumber: '01012345678',
          latLong: '30.0500,31.2400',
        );

        // act
        final model = RemoteStoreModel.fromEntity(entity);

        // assert
        expect(model.name, entity.name);
        expect(model.image, entity.image);
        expect(model.address, entity.address);
        expect(model.phoneNumber, entity.phoneNumber);
        expect(model.latLong, entity.latLong);
      });

    
    });
  });
}
