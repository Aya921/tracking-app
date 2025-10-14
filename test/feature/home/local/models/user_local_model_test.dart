import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
import 'package:tracking_app/feature/home/local/models/user_local_model.dart';

void main() {
  group('UserLocalModel Conversion Tests', () {
    final entity = UserEntity(
      id: '123',
      firstName: 'Aya',
      lastName: 'Saber',
      email: 'aya@example.com',
      gender: 'female',
      phone: '0123456789',
      photo: 'https://example.com/photo.png',
    );

    test('fromEntity() should convert UserEntity to UserLocalModel correctly', () {
      // act
      final model = UserLocalModel.fromEntity(entity);

      // assert
      expect(model.id, entity.id);
      expect(model.firstName, entity.firstName);
      expect(model.lastName, entity.lastName);
      expect(model.email, entity.email);
      expect(model.gender, entity.gender);
      expect(model.phone, entity.phone);
      expect(model.photo, entity.photo);
    });

    test('toEntity() should convert UserLocalModel back to UserEntity correctly', () {
      // arrange
      final model = UserLocalModel.fromEntity(entity);

      // act
      final convertedEntity = model.toEntity();

      // assert
      expect(convertedEntity.id, model.id);
      expect(convertedEntity.firstName, model.firstName);
      expect(convertedEntity.lastName, model.lastName);
      expect(convertedEntity.email, model.email);
      expect(convertedEntity.gender, model.gender);
      expect(convertedEntity.phone, model.phone);
      expect(convertedEntity.photo, model.photo);
    });
  });
}
