import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/data/data_source/profile_remote_data_source.dart';
import 'package:tracking_app/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:tracking_app/feature/profile/domain/entity/driver_contact_info_entity.dart';
import 'package:tracking_app/feature/profile/domain/entity/driver_info_entity.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';
import 'package:tracking_app/feature/profile/domain/entity/vehicle_info_entity.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource])
void main() {
  late ProfileRepositoryImpl profileRepositoryImpl;
  late MockProfileRemoteDataSource mockProfileRemoteDataSource;

  setUpAll(() {
    provideDummy<Result<EditProfileEntity>>(FailedResult("Dummy Error"));
    provideDummy<Result<String>>(SucessResult<String>("success"));
    mockProfileRemoteDataSource = MockProfileRemoteDataSource();
    profileRepositoryImpl = ProfileRepositoryImpl(mockProfileRemoteDataSource);
  });

  group("upload photo test", () {
    final fakeFile = File('path/to/photo.jpg');

    test("should return SuccessResult when remote call succeeds", () async {
      //Arrange
      when(mockProfileRemoteDataSource.uploadDriverPhoto(any)).thenAnswer(
        (_) async => SucessResult<String>("https://fakeurl.com/photo.jpg"),
      );

      //Act
      final result = await profileRepositoryImpl.uploadDriverPhoto(fakeFile);

      //Assert
      expect(result, isA<SucessResult<String>>());
      final success = result as SucessResult<String>;
      expect(success.sucessResult, "https://fakeurl.com/photo.jpg");
      verify(mockProfileRemoteDataSource.uploadDriverPhoto(any)).called(1);
    });

    test("should return FailedResult when remote call fails", () async {
      //Arrange
      when(
        mockProfileRemoteDataSource.uploadDriverPhoto(fakeFile),
      ).thenAnswer((_) async => FailedResult<String>("Upload failed"));

      //Act
      final result = await profileRepositoryImpl.uploadDriverPhoto(fakeFile);

      //Assert
      expect(result, isA<FailedResult<String>>());
      final failure = result as FailedResult<String>;
      expect(failure.errorMessage, "Upload failed");
      verify(mockProfileRemoteDataSource.uploadDriverPhoto(any)).called(1);
    });
  });

  group("edit profile test", () {
    const fakeEntity = EditProfileEntity(
      info: DriverInfoEntity(firstName: "Rana", lastName: "Gebril"),
      contact: DriverContactInfoEntity(
        email: "Test1@gmail.com",
        phone: "01234567891",
      ),
      vehicle: VehicleInfoEntity(vehicleNumber: "4511", vehicleType: "car"),
    );

    final fakeRequest = EditProfileRequest(
      email: "Test1@gmail.com",
      firstName: "Rana",
      lastName: "Gebril",
      phone: "01234567891",
    );

    test("should return SuccessResult when remote call succeeds", () async {
      //Arrange
      when(
        mockProfileRemoteDataSource.editProfile(fakeRequest),
      ).thenAnswer((_) async => SucessResult<EditProfileEntity>(fakeEntity));

      //Act
      final result=await profileRepositoryImpl.editProfile(fakeRequest);

      //Assert
      expect(result, isA<SucessResult<EditProfileEntity>>());
      final success=(result as SucessResult<EditProfileEntity>).sucessResult;
      expect(success.info?.firstName, "Rana");
      expect(success.contact?.phone,"01234567891" );
      expect(success.vehicle?.vehicleType, "car");
      verify(mockProfileRemoteDataSource.editProfile(fakeRequest)).called(1);
    });

    test("should return FailedResult when remote call fails", () async{
      //Arrange
      when(
        mockProfileRemoteDataSource.editProfile(fakeRequest),
      ).thenAnswer((_) async => FailedResult<EditProfileEntity>("Failed edit profile"));

      //Act
      final result=await profileRepositoryImpl.editProfile(fakeRequest);

      //Assert
      expect(result, isA<FailedResult<EditProfileEntity>>());
      final failure = result as FailedResult<EditProfileEntity>;
      expect(failure.errorMessage, "Failed edit profile");
      verify(mockProfileRemoteDataSource.editProfile(any)).called(1);

    },);
  });
}
