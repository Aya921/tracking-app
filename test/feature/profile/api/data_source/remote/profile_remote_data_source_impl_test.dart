import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/client/profile_api_services.dart';
import 'package:tracking_app/feature/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:tracking_app/feature/profile/api/models/driver_contact_info.dart';
import 'package:tracking_app/feature/profile/api/models/driver_info.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/response/driver_model.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/response/edit_profile_response.dart';
import 'package:tracking_app/feature/profile/api/models/vehicle_info.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiServices])
void main() {
  late ProfileRemoteDataSourceImpl profileRemoteDataSourceImpl;
  late MockProfileApiServices mockProfileApiServices;

  setUpAll(() {
    mockProfileApiServices = MockProfileApiServices();
    profileRemoteDataSourceImpl = ProfileRemoteDataSourceImpl(
      mockProfileApiServices,
    );
  });

  group('uploadDriverPhoto test', () {
    final fakeFile = File('path/to/photo.jpg');

    test('should return success when API succeeds', () async {
      // Arrange
      when(
        mockProfileApiServices.uploadDriverPhoto(fakeFile),
      ).thenAnswer((_) async => 'https://fakeurl.com/photo.jpg');

      // Act
      final result = await profileRemoteDataSourceImpl.uploadDriverPhoto(
        fakeFile,
      );

      // Assert
      expect(result, isA<SucessResult<String>>());
      expect(
        (result as SucessResult<String>).sucessResult,
        'https://fakeurl.com/photo.jpg',
      );
      verify(mockProfileApiServices.uploadDriverPhoto(fakeFile)).called(1);
    });

    test('should return failure when API throws', () async {
      // Arrange
      when(
        mockProfileApiServices.uploadDriverPhoto(fakeFile),
      ).thenThrow(Exception('Upload failed'));

      // Act
      final result = await profileRemoteDataSourceImpl.uploadDriverPhoto(
        fakeFile,
      );

      // Assert
      expect(result, isA<FailedResult<String>>());
      expect(
        (result as FailedResult<String>).errorMessage,
        Exception("Upload failed").toString(),
      );
      verify(mockProfileApiServices.uploadDriverPhoto(fakeFile)).called(1);
    });
  });

  group("editProfile test", () {
    final fakeRequest = EditProfileRequest(
      email: "Test1@gmail.com",
      firstName: "Rana",
      lastName: "Gebril",
      phone: "01234567891",
    );

    final fakeResponse = EditProfileResponse(
      driver: DriverModel(
        info: DriverInfo(firstName: "Rana", lastName: "Gebril"),
        contact: DriverContactInfo(
          email: "Test1@gmail.com",
          phone: "01234567891",
        ),
        vehicle: VehicleInfo(
          vehicleNumber: "4511",
          vehicleType: "car"
        )
      ),
      message: "success",
    );

    test("should return success when API succeeds", ()async {
      //Arrange
      when(
        mockProfileApiServices.editProfile(fakeRequest),
      ).thenAnswer((_) async => fakeResponse);

      //Act
      final result=await profileRemoteDataSourceImpl.editProfile(fakeRequest);

      //Assert
      expect(result, isA<SucessResult<EditProfileEntity>>());
      final success=(result as SucessResult<EditProfileEntity>).sucessResult;
      expect(success.info?.firstName, "Rana");
      expect(success.contact?.phone,"01234567891" );
      expect(success.vehicle?.vehicleType, "car");
      verify(mockProfileApiServices.editProfile(fakeRequest)).called(1);
    });

    test("should return failure when API throws", ()async {
      //Arrange
      when(mockProfileApiServices.editProfile(any)).thenThrow(Exception("Error editing profile"));

      //Act
      final result=await profileRemoteDataSourceImpl.editProfile(fakeRequest);

      //Assert
      expect(result, isA<FailedResult<EditProfileEntity>>());
      final failure=(result as FailedResult<EditProfileEntity>);
      expect(failure.errorMessage, Exception("Error editing profile").toString());
      verify(mockProfileApiServices.editProfile(any)).called(1);
    },);
  });
}
