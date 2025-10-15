import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_error/api_error.dart';
import 'package:tracking_app/core/api_result/result.dart';
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
}