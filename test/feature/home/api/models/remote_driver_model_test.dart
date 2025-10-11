import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/home/api/models/remote_driver_model.dart';


void main() {
  group('RemoteDriverModel ↔ DriverEntity Conversion', () {
    group('toEntity()', () {
      test('should correctly convert model with data to entity', () {
        // Arrange
        final model = RemoteDriverModel(
          id: '1',
          country: 'Egypt',
          firstName: 'Aya',
          lastName: 'Saber',
          vehicleType: 'Car',
          vehicleNumber: 'ABC123',
          vehicleLicense: 'LIC123',
          nId: '987654321',
          nIdImg: 'nid_image_url',
          email: 'aya@example.com',
          gender: 'Female',
          phone: '01012345678',
          photo: 'photo_url',
          role: 'driver',
          createdAt: '2025-01-01',
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.id, model.id);
        expect(entity.country, model.country);
        expect(entity.firstName, model.firstName);
        expect(entity.lastName, model.lastName);
        expect(entity.vehicleType, model.vehicleType);
        expect(entity.vehicleNumber, model.vehicleNumber);
        expect(entity.vehicleLicense, model.vehicleLicense);
        expect(entity.nid, model.nId);
        expect(entity.nidImg, model.nIdImg);
        expect(entity.email, model.email);
        expect(entity.gender, model.gender);
        expect(entity.phone, model.phone);
        expect(entity.photo, model.photo);
        expect(entity.role, model.role);
        expect(entity.createdAt, model.createdAt);
      });

      test('should handle null values and return default entity', () {
        // Arrange
        final model = RemoteDriverModel();

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.id, '');
        expect(entity.country, '');
        expect(entity.firstName, '');
        expect(entity.lastName, '');
        expect(entity.vehicleType, '');
        expect(entity.vehicleNumber, '');
        expect(entity.vehicleLicense, '');
        expect(entity.nid, '');
        expect(entity.nidImg, '');
        expect(entity.email, '');
        expect(entity.gender, '');
        expect(entity.phone, '');
        expect(entity.photo, '');
        expect(entity.role, '');
        expect(entity.createdAt, '');
      });
    });

    group('fromEntity()', () {
      test('should correctly convert entity to model', () {
        // Arrange
        const entity = DriverEntity(
          id: '1',
          country: 'Egypt',
          firstName: 'Aya',
          lastName: 'Saber',
          vehicleType: 'Car',
          vehicleNumber: 'ABC123',
          vehicleLicense: 'LIC123',
          nid: '987654321',
          nidImg: 'nid_image_url',
          email: 'aya@example.com',
          gender: 'Female',
          phone: '01012345678',
          photo: 'photo_url',
          role: 'driver',
          createdAt: '2025-01-01',
        );

        // Act
        final model = RemoteDriverModel.fromEntity(entity);

        // Assert
        expect(model.id, entity.id);
        expect(model.country, entity.country);
        expect(model.firstName, entity.firstName);
        expect(model.lastName, entity.lastName);
        expect(model.vehicleType, entity.vehicleType);
        expect(model.vehicleNumber, entity.vehicleNumber);
        expect(model.vehicleLicense, entity.vehicleLicense);
        expect(model.nId, entity.nid);
        expect(model.nIdImg, entity.nidImg);
        expect(model.email, entity.email);
        expect(model.gender, entity.gender);
        expect(model.phone, entity.phone);
        expect(model.photo, entity.photo);
        expect(model.role, entity.role);
        expect(model.createdAt, entity.createdAt);
      });
    });
  });
}
