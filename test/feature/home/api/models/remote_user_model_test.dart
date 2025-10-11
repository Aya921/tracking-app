import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/api/models/remote_user_model.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';

void main() {
  group('RemoteUserModel', () {
    group('test toEntity function', () {
      test('should convert RemoteUserModel to UserEntity when model is not null', () {
        // arrange
        final model = RemoteUserModel(
          id: 'user123',
          firstName: 'Aya',
          lastName: 'Saber',
          email: 'aya@example.com',
          gender: 'female',
          phone: '0100001111',
          photo: 'https://example.com/aya.png',
        );

        // act
        final entity = RemoteUserModel.toEntity(model);

        // assert
        expect(entity.id, model.id);
        expect(entity.firstName, model.firstName);
        expect(entity.lastName, model.lastName);
        expect(entity.email, model.email);
        expect(entity.gender, model.gender);
        expect(entity.phone, model.phone);
        expect(entity.photo, model.photo);
      });

      test('should return default fake UserEntity when model is null', () {
        // act
        final entity = RemoteUserModel.toEntity(null);

        // assert
        expect(entity.id, 'fake-user-id');
        expect(entity.firstName, 'Fake');
        expect(entity.lastName, 'User');
        expect(entity.email, 'fake@email.com');
        expect(entity.gender, 'unknown');
        expect(entity.phone, '0000000000');
        expect(entity.photo,
            'https://flower.elevateegy.com/uploads/default-profile.png');
      });

      test('should fallback to default values when fields are null', () {
        // arrange
        final model = RemoteUserModel();

        // act
        final entity = RemoteUserModel.toEntity(model);

        // assert
        expect(entity.id, 'fake-user-id');
        expect(entity.firstName, 'Fake');
        expect(entity.lastName, 'User');
        expect(entity.email, 'fake@email.com');
        expect(entity.gender, 'unknown');
        expect(entity.phone, '0000000000');
        expect(entity.photo, 'https://example.com/default-profile.png');
      });
    });

    group('fromEntity', () {
      test('should map all fields correctly from entity to model', () {
        // arrange
        final   entity = UserEntity(
          id: 'user999',
          firstName: 'Aya',
          lastName: 'Saber',
          email: 'aya@domain.com',
          gender: 'female',
          phone: '0102223333',
          photo: 'https://example.com/photo.png',
        );

        // act
        final model = RemoteUserModel.fromEntity(entity);

        // assert
        expect(model.id, entity.id);
        expect(model.firstName, entity.firstName);
        expect(model.lastName, entity.lastName);
        expect(model.email, entity.email);
        expect(model.gender, entity.gender);
        expect(model.phone, entity.phone);
        expect(model.photo, entity.photo);
      });

      
    
    });
  });
}
