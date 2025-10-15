import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/client/profile_api_services.dart';
import 'package:tracking_app/feature/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';

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
      when(mockProfileApiService.changePassword(request)).thenThrow(dioException);
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
}

