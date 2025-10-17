import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_error/api_error.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
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
  late MockProfileRemoteDataSource mockProfileRemoteDataSource;
  late ProfileRepositoryImpl profileRepositoryImpl;

  setUpAll(() {
    mockProfileRemoteDataSource = MockProfileRemoteDataSource();
    profileRepositoryImpl = ProfileRepositoryImpl(mockProfileRemoteDataSource);

    // Provide dummies for generic Result types
    provideDummy<Result<ChangePasswordResponse>>(FailedResult("Dummy Error"));
    provideDummy<Result<EditProfileEntity>>(FailedResult("Dummy Error"));
    provideDummy<Result<String>>(SucessResult<String>("success"));
  });

  // 🔹 Change Password Tests
  group("Change Password Repository Test", () {
    final request = ChangePasswordRequest(
      password: "Mari123@",
      newPassword: "Mari123@1",
    );

    final successResponse = ChangePasswordResponse(
      message: "success",
      token:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjhhMjE4MjVhOGJjYTMwN2Y5ZGU5MzY1Iiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NTY1NjU5MDh9.SG6OMFWYluNn__hIfstJXPbT00zoPlMEghSDGvdTkSY",
    );

    test("should return SuccessResult when remote data source returns success",
            () async {
          when(mockProfileRemoteDataSource.changePassword(request))
              .thenAnswer((_) async => SucessResult(successResponse));

          final result = await profileRepositoryImpl.changePassword(request);

          expect(result, isA<SucessResult<ChangePasswordResponse>>());
          expect((result as SucessResult).sucessResult, successResponse);
          verify(mockProfileRemoteDataSource.changePassword(request)).called(1);
        });

    test("should return FailedResult when remote data source returns failure",
            () async {
          final failureResponse =
          ChangePasswordResponse(message: "Something went wrong");

          when(mockProfileRemoteDataSource.changePassword(request))
              .thenAnswer((_) async => FailedResult(failureResponse.message));

          final result = await profileRepositoryImpl.changePassword(request);

          expect(result, isA<FailedResult<ChangePasswordResponse>>());
          expect((result as FailedResult).errorMessage, failureResponse.message);
          verify(mockProfileRemoteDataSource.changePassword(request)).called(1);
        });

    test("should return FailedResult on DioException", () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ""),
        type: DioExceptionType.connectionTimeout,
      );

      when(mockProfileRemoteDataSource.changePassword(request)).thenAnswer(
            (_) async => FailedResult(
          ServerFailure.fromDioError(dioException).errorMessage,
        ),
      );

      final result = await profileRepositoryImpl.changePassword(request);

      expect(result, isA<FailedResult<ChangePasswordResponse>>());
      expect((result as FailedResult).errorMessage,
          "ServerFailure with Api Server");
      verify(mockProfileRemoteDataSource.changePassword(request)).called(1);
    });
  });

  // 🔹 Upload Photo Tests
  group("Upload Photo Repository Test", () {
    final fakeFile = File('path/to/photo.jpg');

    test("should return SuccessResult when remote call succeeds", () async {
      when(mockProfileRemoteDataSource.uploadDriverPhoto(any)).thenAnswer(
            (_) async => SucessResult<String>("https://fakeurl.com/photo.jpg"),
      );

      final result = await profileRepositoryImpl.uploadDriverPhoto(fakeFile);

      expect(result, isA<SucessResult<String>>());
      expect((result as SucessResult).sucessResult,
          "https://fakeurl.com/photo.jpg");
      verify(mockProfileRemoteDataSource.uploadDriverPhoto(any)).called(1);
    });

    test("should return FailedResult when remote call fails", () async {
      when(mockProfileRemoteDataSource.uploadDriverPhoto(fakeFile))
          .thenAnswer((_) async => FailedResult<String>("Upload failed"));

      final result = await profileRepositoryImpl.uploadDriverPhoto(fakeFile);

      expect(result, isA<FailedResult<String>>());
      expect((result as FailedResult).errorMessage, "Upload failed");
      verify(mockProfileRemoteDataSource.uploadDriverPhoto(any)).called(1);
    });
  });

  // 🔹 Edit Profile Tests
  group("Edit Profile Repository Test", () {
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
      when(mockProfileRemoteDataSource.editProfile(fakeRequest))
          .thenAnswer((_) async => SucessResult<EditProfileEntity>(fakeEntity));

      final result = await profileRepositoryImpl.editProfile(fakeRequest);

      expect(result, isA<SucessResult<EditProfileEntity>>());
      final success = (result as SucessResult<EditProfileEntity>).sucessResult;
      expect(success.info?.firstName, "Rana");
      expect(success.contact?.phone, "01234567891");
      expect(success.vehicle?.vehicleType, "car");
      verify(mockProfileRemoteDataSource.editProfile(fakeRequest)).called(1);
    });

    test("should return FailedResult when remote call fails", () async {
      when(mockProfileRemoteDataSource.editProfile(fakeRequest))
          .thenAnswer((_) async =>
          FailedResult<EditProfileEntity>("Failed edit profile"));

      final result = await profileRepositoryImpl.editProfile(fakeRequest);

      expect(result, isA<FailedResult<EditProfileEntity>>());
      final failure = result as FailedResult<EditProfileEntity>;
      expect(failure.errorMessage, "Failed edit profile");
      verify(mockProfileRemoteDataSource.editProfile(any)).called(1);
    });
  });
}
