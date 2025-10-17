import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_error/api_error.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
import 'package:tracking_app/feature/profile/data/data_source/profile_remote_data_source.dart';
import 'package:tracking_app/feature/profile/data/repository/profile_repository_impl.dart';

import 'profile_repository_impl_test.mocks.dart';
@GenerateMocks([ProfileRemoteDataSource])
void main() {
  late MockProfileRemoteDataSource mockProfileRemoteDataSourceImp;
  late  ProfileRepositoryImpl profileRepositoryImp;
  setUp((){
    mockProfileRemoteDataSourceImp=MockProfileRemoteDataSource();
    profileRepositoryImp=ProfileRepositoryImpl(mockProfileRemoteDataSourceImp);
    provideDummy<Result<ChangePasswordResponse>>(
        FailedResult<ChangePasswordResponse>("Dummy Error")
    );
    provideDummy<Result<DriverEntity>>(
        FailedResult<DriverEntity>("DriverEntity Error")
    );
    provideDummy<Result<void>>(
        FailedResult<void>("log out Error")
    );
  });
  group("Change Password Repositry Test", (){
    final ChangePasswordRequest request=ChangePasswordRequest(
        password: "Mari123@",
        newPassword: "Mari123@1"
    );
    final successResponse=ChangePasswordResponse(
        message: "success",
        token:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjhhMjE4MjVhOGJjYTMwN2Y5ZGU5MzY1Iiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NTY1NjU5MDh9.SG6OMFWYluNn__hIfstJXPbT00zoPlMEghSDGvdTkSY"
    );
    test("should return ApiSuccessResult when remote data source returns success",
            ()async{
          when(mockProfileRemoteDataSourceImp.changePassword(request))
              .thenAnswer((_)async=>SucessResult(successResponse));
          final result=await profileRepositoryImp.changePassword(request);
          expect(result, isA<SucessResult<ChangePasswordResponse>>());
          expect((result as SucessResult).sucessResult, successResponse);
          verify(mockProfileRemoteDataSourceImp.changePassword(request)).called(1);
        });

    test("should return ApiFailedResult when remote data source returns Fails",
            ()async{
          final failureResponse=ChangePasswordResponse(message: "Something went wrong");
          when(mockProfileRemoteDataSourceImp.changePassword(request))
              .thenAnswer((_)async=>FailedResult(failureResponse.message));
          final result=await profileRepositoryImp.changePassword(request);
          expect(result, isA<FailedResult<ChangePasswordResponse>>());
          expect((result as FailedResult).errorMessage, failureResponse.message);
          verify(mockProfileRemoteDataSourceImp.changePassword(request)).called(1);
        });
    test("should return ApiFailedResult on DioException", ()async{
      final dioException=DioException(requestOptions: RequestOptions(
          path: ""
      ),type: DioExceptionType.connectionTimeout);
      when(mockProfileRemoteDataSourceImp.changePassword(request)).
      thenAnswer((_)async=>FailedResult(ServerFailure.fromDioError(dioException).errorMessage));
      final result=await profileRepositoryImp.changePassword(request);
      expect(result, isA<FailedResult<ChangePasswordResponse>>());
      expect((result as FailedResult).errorMessage,"ServerFailure with Api Server");
      verify(mockProfileRemoteDataSourceImp.changePassword(request)).called(1);
    });

  });
  group("Get Logout Driver", (){
    const successResponse=DriverEntity(
      id: "68d983e4dd8937e0573fea27",
      firstName: "mariam1",
      lastName: "mohmed2",
      contactInfo: ContactInfo(
        country: "Egypt",
        gender: "female",
        email: "mariammohmed5@gmail.com",
        phone: "+20101070082",
        photo: "default-profile.png",
      ),
      vehicle: VehicleInfo(
        type: "676b31a45d05310ca82657ac",
        number: "12221",
        license: "fake_image.png",
      ),
      identity: IdentityInfo(
          nid: "12345678912345", nidImg: "fake_image.png"),
      meta: MetaInfo(
          role: "driver", createdAt: "2025-09-28T18:52:20.452Z"),
    );
test("should return Success Result when data remote success", ()async{
  when(mockProfileRemoteDataSourceImp.getLoggedDriver())
      .thenAnswer((_)async=>SucessResult(successResponse));
  final result=await profileRepositoryImp.getLoggedDriver();
  expect(result, isA<SucessResult>());
  expect((result as SucessResult).sucessResult, successResponse);
verify(mockProfileRemoteDataSourceImp.getLoggedDriver()).called(1);

});
    test("should return Falied Result when data remote failed", ()async{
      final exception=Exception("throw Exception");
      when(mockProfileRemoteDataSourceImp.getLoggedDriver())
          .thenAnswer((_)async=>FailedResult(exception.toString()));
      final result=await profileRepositoryImp.getLoggedDriver();
      expect(result, isA<FailedResult>());
      expect((result as FailedResult).errorMessage, exception.toString());
      verify(mockProfileRemoteDataSourceImp.getLoggedDriver()).called(1);

    });
    
  });
  group(" Logout Driver", (){

    test("should return Success Result when data remote success", ()async{
      when(mockProfileRemoteDataSourceImp.logoutDriver())
          .thenAnswer((_)async=>SucessResult(null));
      final result=await profileRepositoryImp.logoutDriver();
      expect(result, isA<SucessResult>());
      expect((result as SucessResult).sucessResult, null);
      verify(mockProfileRemoteDataSourceImp.logoutDriver()).called(1);

    });
    test("should return Falied Result when data remote failed", ()async{
      final exception=Exception("throw Exception");
      when(mockProfileRemoteDataSourceImp.logoutDriver())
          .thenAnswer((_)async=>FailedResult(exception.toString()));
      final result=await profileRepositoryImp.logoutDriver();
      expect(result, isA<FailedResult>());
      expect((result as FailedResult).errorMessage, exception.toString());
      verify(mockProfileRemoteDataSourceImp.logoutDriver()).called(1);

    });

  });
}