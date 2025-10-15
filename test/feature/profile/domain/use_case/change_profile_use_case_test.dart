import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_error/api_error.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
import 'package:tracking_app/feature/profile/domain/repository/profile_repository.dart';
import 'package:tracking_app/feature/profile/domain/use_case/change_profile_use_case.dart';

import 'change_profile_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main(){
  late ChangePasswordUseCase getChangePasswordUseCase;
  late MockProfileRepository mockProfileRepository;
  setUp
    ((){
    mockProfileRepository=MockProfileRepository();
    getChangePasswordUseCase=ChangePasswordUseCase(mockProfileRepository);
    provideDummy<Result<ChangePasswordResponse>>(
        FailedResult<ChangePasswordResponse>("Dummy Error")
    );
  });
  group("Change Password UseCase Test", (){
    final ChangePasswordRequest request=ChangePasswordRequest(
        password: "Mari123@",
        newPassword: "Mari123@1"
    );
    final successResponse=ChangePasswordResponse(
        message: "success",
        token:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjhhMjE4MjVhOGJjYTMwN2Y5ZGU5MzY1Iiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NTY1NjU5MDh9.SG6OMFWYluNn__hIfstJXPbT00zoPlMEghSDGvdTkSY"
    );
    test("return ApiSuccessResult when  ProfileRepository success", ()async{
      when(mockProfileRepository.changePassword(request)).
      thenAnswer((_)async=>SucessResult(successResponse));
      final result=await getChangePasswordUseCase.call(request);
      expect(result, isA<SucessResult<ChangePasswordResponse>>());
      expect((result as SucessResult).sucessResult, successResponse);
      verify(mockProfileRepository.changePassword(request)).called(1);
    });
    test("return ApiFailedResult when  ProfileRepository fails", ()async{
      final failureResponse=ChangePasswordResponse(
        message: "Something went wrong",

      );
      when(mockProfileRepository.changePassword(request)).thenAnswer((_)async=>
          FailedResult(failureResponse.message));
      final result=await getChangePasswordUseCase.call(request);
      expect(result, isA<FailedResult<ChangePasswordResponse>>());
      expect((result as FailedResult).errorMessage, failureResponse.message);
      verify(mockProfileRepository.changePassword(request)).called(1);
    });
    test("return ApiFailedResult when  ProfileRepository fails", ()async{
      final dioException=DioException(requestOptions: RequestOptions(
        path: "",

      ),type: DioExceptionType.connectionTimeout);
      when(mockProfileRepository.changePassword(request)).thenAnswer((_)async=>FailedResult
        (ServerFailure.fromDioError(dioException).errorMessage));

      final result=await getChangePasswordUseCase.call(request);
      expect(result, isA<FailedResult<ChangePasswordResponse>>());
      expect((result as FailedResult).errorMessage, "ServerFailure with Api Server");
      verify(mockProfileRepository.changePassword(request)).called(1);
    });

  });

}