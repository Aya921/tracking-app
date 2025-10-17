import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/feature/auth/api/models/apply/response/apply_response/apply_response.dart';
import 'package:tracking_app/feature/profile/api/client/profile_api_services.dart';
import 'package:tracking_app/feature/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
import 'package:tracking_app/feature/profile/api/models/get_logged_user_response.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';




@GenerateMocks([ProfileApiServices])

void main() {
  late MockProfileApiServices mockProfileApiService;
  late ProfileRemoteDataSourceImpl profileRemoteDataSourceImp;
  setUp((){
    mockProfileApiService=MockProfileApiServices();
    profileRemoteDataSourceImp=ProfileRemoteDataSourceImpl(mockProfileApiService);
  });

  group("Change Password Test", (){

    final ChangePasswordRequest request=ChangePasswordRequest(password:
    "Mari123@", newPassword:  "Mari123@1");

    final successResponse=ChangePasswordResponse(
        message: "success",
        token:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjhhMjE4MjVhOGJjYTMwN2Y5ZGU5MzY1Iiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NTY1NjU5MDh9.SG6OMFWYluNn__hIfstJXPbT00zoPlMEghSDGvdTkSY"
    );
    test("return ApiSuccessResult when api return success", ()async{
      when(mockProfileApiService.changePassword(request)).thenAnswer((_)
      async=>successResponse);
      final result=await profileRemoteDataSourceImp.changePassword(request);
      expect(result, isA<SucessResult>());
      expect((result as SucessResult).sucessResult,
          successResponse);
      verify(mockProfileApiService.changePassword(request)).called(1);
    });

    test("should return ApiFailedResult on DioException", ()async{
      final  dioException=DioException(requestOptions: RequestOptions(
        path: "",
      ),type: DioExceptionType.connectionTimeout);
      when(mockProfileApiService.changePassword(request)).
      thenThrow(dioException);
      final result=await profileRemoteDataSourceImp.changePassword(request);
      expect(result, isA<FailedResult<ChangePasswordResponse>>());
      expect((result as FailedResult).errorMessage, "ServerFailure with Api Server");
      verify(mockProfileApiService.changePassword(request)).called(1);
    });
    test("should return ApiFailed Result when throw exception", ()async{
      final exception=Exception("Throw Exception");
      when(mockProfileApiService.changePassword(request)).thenThrow(exception);
      final result=await profileRemoteDataSourceImp.changePassword(request);
      expect(result , isA<FailedResult<ChangePasswordResponse>>());
      expect((result as FailedResult).errorMessage, exception.toString());
    });
  });
  group("Get logout Driver", (){
    final successResponse=GetLoggedUserResponse(
      message: "success",
      driver: Driver(
          id: "68d983e4dd8937e0573fea27",
          firstName: "mariam1",
          lastName: "mohmed2",

            country: "Egypt",
            gender: "female",
            email: "mariammohmed5@gmail.com",
            phone: "+20101070082",
            photo: "default-profile.png",
        vehicleType: "676b31a45d05310ca82657ac",
        vehicleNumber: "12221",
        vehicleLicense: "fake_image.png",
          nId: "12345678912345", nIdImg: "fake_image.png",
          role: "driver", createdAt: "2025-09-28T18:52:20.452Z"
      )
    );

    const driver=DriverEntity(
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
    test("should return success Result whn api call success",
            ()async{
      when(mockProfileApiService.getLoggedDriver()).thenAnswer((_)async=>
      successResponse);
      final result=await 
      profileRemoteDataSourceImp.getLoggedDriver();
      expect(result, isA<SucessResult>());
      expect((result as SucessResult).sucessResult, driver);
      verify(mockProfileApiService.getLoggedDriver()).called(1);
      
    });
    test("should return Failed Result whn api call failed on DioException", ()async{
      final dioException=DioException(requestOptions: RequestOptions(

path: "/"
      ),type: DioExceptionType.connectionTimeout);
      when(mockProfileApiService.getLoggedDriver()).
      thenThrow(dioException);
      final result=await
      profileRemoteDataSourceImp.getLoggedDriver();
      expect(result, isA<FailedResult<DriverEntity>>());
      expect((result as FailedResult).errorMessage,
          "ServerFailure with Api Server");
      verify(mockProfileApiService.getLoggedDriver()).called(1);
    });
test("should return Failed Result whn api call failed ", ()async
{
  final exception=Exception("some thing went wrong");
  when(mockProfileApiService.getLoggedDriver()).thenThrow(exception);
  final result=await profileRemoteDataSourceImp.getLoggedDriver();
  expect(result, isA<FailedResult<DriverEntity>>());
  expect((result as FailedResult).errorMessage, exception.toString());
  verify(mockProfileApiService.getLoggedDriver()).called(1);

});
  });
  group("Logout Driver", (){
    final successResponse=GetLoggedUserResponse(
      message: "succcess",
      driver: Driver(
          id: "68d983e4dd8937e0573fea27",
          firstName: "mariam1",
          lastName: "mohmed2",

          country: "Egypt",
          gender: "female",
          email: "mariammohmed5@gmail.com",
          phone: "+20101070082",
          photo: "default-profile.png",
          vehicleType: "676b31a45d05310ca82657ac",
          vehicleNumber: "12221",
          vehicleLicense: "fake_image.png",
          nId: "12345678912345", nIdImg: "fake_image.png",
          role: "driver", createdAt: "2025-09-28T18:52:20.452Z"
      )
    );
    test("should return success Result whn api call success",
            ()async{
          when(mockProfileApiService.logoutDriver()).thenAnswer((_)async=>
          successResponse);
          final result=await
          profileRemoteDataSourceImp.logoutDriver();
          expect(result, isA<SucessResult>());
          expect((result as SucessResult).sucessResult, null);
          verify(mockProfileApiService.logoutDriver()).called(1);

        });
    test(" should return Failed Result when api failed on dio exception on get log out",
        ()async{
      final dioException=DioException(requestOptions: RequestOptions(
        path: ""
      ),type: DioExceptionType.receiveTimeout);
      when(mockProfileApiService.logoutDriver()).
      thenThrow(dioException);
      final result=await
      profileRemoteDataSourceImp.logoutDriver();
      expect(result, isA<FailedResult<void>>());
      expect((result as FailedResult).errorMessage, "receiveTimeout with Api Server");
      verify(mockProfileApiService.logoutDriver()).called(1);
        });
    test(" should return Failed Result when api failed on dio exception on get log out",
            ()async{
          final exception=Exception("throw Exception");
          when(mockProfileApiService.logoutDriver()).
          thenThrow(exception);
          final result=await
          profileRemoteDataSourceImp.logoutDriver();
          expect(result, isA<FailedResult<void>>());
          expect((result as FailedResult).errorMessage, exception.toString());
          verify(mockProfileApiService.logoutDriver()).called(1);
        });
  });
}

