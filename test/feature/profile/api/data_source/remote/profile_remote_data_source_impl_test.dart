import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/client/profile_api_services.dart';
import 'package:tracking_app/feature/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
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
  late MockProfileApiServices mockProfileApiService;
  late ProfileRemoteDataSourceImpl profileRemoteDataSourceImpl;

  setUp(() {
    mockProfileApiService = MockProfileApiServices();
    profileRemoteDataSourceImpl = ProfileRemoteDataSourceImpl(mockProfileApiService);
  });

  // 🔹 Change Password Tests
  group("Change Password Test", () {
    final request = ChangePasswordRequest(
      password: "Mari123@",
      newPassword: "Mari123@1",
    );

    final successResponse = ChangePasswordResponse(
      message: "success",
      token:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjhhMjE4MjVhOGJjYTMwN2Y5ZGU5MzY1Iiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NTY1NjU5MDh9.SG6OMFWYluNn__hIfstJXPbT00zoPlMEghSDGvdTkSY",
    );

    test("should return SuccessResult when API returns success", () async {
      when(mockProfileApiService.changePassword(request))
          .thenAnswer((_) async => successResponse);

      final result = await profileRemoteDataSourceImpl.changePassword(request);

      expect(result, isA<SucessResult<ChangePasswordResponse>>());
      expect((result as SucessResult).sucessResult, successResponse);
      verify(mockProfileApiService.changePassword(request)).called(1);
    });

    test("should return FailedResult on DioException", () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ""),
        type: DioExceptionType.connectionTimeout,
      );

      when(mockProfileApiService.changePassword(request)).thenThrow(dioException);

      final result = await profileRemoteDataSourceImpl.changePassword(request);

      expect(result, isA<FailedResult<ChangePasswordResponse>>());
      expect((result as FailedResult).errorMessage, "ServerFailure with Api Server");
      verify(mockProfileApiService.changePassword(request)).called(1);
    });

    test("should return FailedResult when generic exception thrown", () async {
      final exception = Exception("Throw Exception");
      when(mockProfileApiService.changePassword(request)).thenThrow(exception);

      final result = await profileRemoteDataSourceImpl.changePassword(request);

      expect(result, isA<FailedResult<ChangePasswordResponse>>());
      expect((result as FailedResult).errorMessage, exception.toString());
      verify(mockProfileApiService.changePassword(request)).called(1);
    });
  });

  // 🔹 Upload Driver Photo Tests
  group("Upload Driver Photo Test", () {
    final fakeFile = File('path/to/photo.jpg');

    test("should return SuccessResult when API succeeds", () async {
      when(mockProfileApiService.uploadDriverPhoto(fakeFile))
          .thenAnswer((_) async => "https://fakeurl.com/photo.jpg");

      final result = await profileRemoteDataSourceImpl.uploadDriverPhoto(fakeFile);

      expect(result, isA<SucessResult<String>>());
      expect((result as SucessResult<String>).sucessResult, "https://fakeurl.com/photo.jpg");
      verify(mockProfileApiService.uploadDriverPhoto(fakeFile)).called(1);
    });

    test("should return FailedResult when API throws exception", () async {
      when(mockProfileApiService.uploadDriverPhoto(fakeFile))
          .thenThrow(Exception("Upload failed"));

      final result = await profileRemoteDataSourceImpl.uploadDriverPhoto(fakeFile);

      expect(result, isA<FailedResult<String>>());
      expect((result as FailedResult<String>).errorMessage, Exception("Upload failed").toString());
      verify(mockProfileApiService.uploadDriverPhoto(fakeFile)).called(1);
    });
  });

  // 🔹 Edit Profile Tests
  group("Edit Profile Test", () {
    final fakeRequest = EditProfileRequest(
      email: "Test1@gmail.com",
      firstName: "Rana",
      lastName: "Gebril",
      phone: "01234567891",
    );

    final fakeResponse = EditProfileResponse(
      driver: DriverModel(
        info: DriverInfo(firstName: "Rana", lastName: "Gebril"),
        contact: DriverContactInfo(email: "Test1@gmail.com", phone: "01234567891"),
        vehicle: VehicleInfo(vehicleNumber: "4511", vehicleType: "car"),
      ),
      message: "success",
    );

    test("should return SuccessResult when API succeeds", () async {
      when(mockProfileApiService.editProfile(fakeRequest))
          .thenAnswer((_) async => fakeResponse);

      final result = await profileRemoteDataSourceImpl.editProfile(fakeRequest);

      expect(result, isA<SucessResult<EditProfileEntity>>());
      final success = (result as SucessResult<EditProfileEntity>).sucessResult;
      expect(success.info?.firstName, "Rana");
      expect(success.contact?.phone, "01234567891");
      expect(success.vehicle?.vehicleType, "car");
      verify(mockProfileApiService.editProfile(fakeRequest)).called(1);
    });

    test("should return FailedResult when API throws exception", () async {
      when(mockProfileApiService.editProfile(any))
          .thenThrow(Exception("Error editing profile"));

      final result = await profileRemoteDataSourceImpl.editProfile(fakeRequest);

      expect(result, isA<FailedResult<EditProfileEntity>>());
      expect((result as FailedResult<EditProfileEntity>).errorMessage,
          Exception("Error editing profile").toString());
      verify(mockProfileApiService.editProfile(any)).called(1);
    });
  });
}
