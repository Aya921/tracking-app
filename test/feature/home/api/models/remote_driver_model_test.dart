import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/core/common/models/driver_model.dart';


void main() {
  late DriverEntity driverEntity;


  
  setUpAll(() {
    driverEntity = const DriverEntity(
      id: '1',
      firstName: 'Aya',
      lastName: 'Saber',
      contactInfo: ContactInfo(
        country: 'Egypt',
        gender: 'female',
        email: 'aya.saber@example.com',
        phone: '+201012345678',
        photo: 'default-profile.png',
      ),
      vehicle: VehicleInfo(
        type: 'Car',
        number: 'ABC-1234',
        license: 'license-image.png',
      ),
      identity: IdentityInfo(nid: '29812345678901', nidImg: 'nid-photo.png'),
      meta: MetaInfo(role: 'driver', createdAt: '2025-01-01T10:00:00.000Z'),
    );

  });

  group('RemoteDriverModel ↔ DriverEntity Conversion', () {
    group('toEntity()', () {
      test('should correctly convert model with data to entity', () {
        // Arrange

        //entity==> model

        final model = DriverModel.fromEntity(driverEntity);

        // Act

        // Assert
        expect(driverEntity.id, model.id);
        expect(driverEntity.contactInfo.country, model.country);
        expect(driverEntity.firstName, model.firstName);
        expect(driverEntity.lastName, model.lastName);
        expect(driverEntity.vehicle.type, model.vehicleType);
        expect(driverEntity.vehicle.number, model.vehicleNumber);
        expect(driverEntity.vehicle.license, model.vehicleLicense);
        expect(driverEntity.identity.nid, model.nId);
        expect(driverEntity.identity.nidImg, model.nIdImg);
        expect(driverEntity.contactInfo.email, model.email);
        expect(driverEntity.contactInfo.gender, model.gender);
        expect(driverEntity.contactInfo.phone, model.phone);
        expect(driverEntity.contactInfo.photo, model.photo);
        expect(driverEntity.meta.role, model.role);
        expect(driverEntity.meta.createdAt, model.createdAt);
      });

      test('should handle null values and return default entity', () {
        // Arrange
        final model = DriverModel();

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.id, '');
        expect(entity.contactInfo.country, '');
        expect(entity.firstName, '');
        expect(entity.lastName, '');
        expect(entity.vehicle.type, '');
        expect(entity.vehicle.number, '');
        expect(entity.vehicle.license, '');
        expect(entity.identity.nid, '');
        expect(entity.identity.nidImg, '');
        expect(entity.contactInfo.email, '');
        expect(entity.contactInfo.gender, '');
        expect(entity.contactInfo.phone, '');
        expect(entity.contactInfo.photo, '');
        expect(entity.meta.role, '');
        expect(entity.meta.createdAt, '');
      });
    });

    group('fromEntity()', () {
      test('should correctly convert entity to model', () {
        // Arrange
     
        // Act
        final model = DriverModel.fromEntity(driverEntity);

        // Assert
        expect(model.id, driverEntity.id);
        expect(model.country, driverEntity.contactInfo.country);
        expect(model.firstName, driverEntity.firstName);
        expect(model.lastName, driverEntity.lastName);
        expect(model.vehicleType, driverEntity.vehicle.type);
        expect(model.vehicleNumber, driverEntity.vehicle.number);
        expect(model.vehicleLicense, driverEntity.vehicle.license);
        expect(model.nId, driverEntity.identity.nid);
        expect(model.nIdImg, driverEntity.identity.nidImg);
        expect(model.email, driverEntity.contactInfo.email);
        expect(model.gender, driverEntity.contactInfo.gender);
        expect(model.phone, driverEntity.contactInfo.phone);
        expect(model.photo, driverEntity.contactInfo.photo);
        expect(model.role, driverEntity.meta.role);
        expect(model.createdAt, driverEntity.meta.createdAt);
      });
    });
  });
}
