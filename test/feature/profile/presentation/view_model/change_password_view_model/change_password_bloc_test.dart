import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
import 'package:tracking_app/feature/profile/domain/use_case/change_profile_use_case.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/change_password_view_model/change_password_bloc.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/change_password_view_model/change_password_event.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/change_password_view_model/change_password_state.dart';

import 'change_password_bloc_test.mocks.dart';
@GenerateMocks([ChangePasswordUseCase])
void main() {
  late MockChangePasswordUseCase mockGetChangePasswordUseCase;
  late ChangePasswordBloc changePasswordBloc;
  setUp((){
    mockGetChangePasswordUseCase=MockChangePasswordUseCase();
    changePasswordBloc=ChangePasswordBloc(
        mockGetChangePasswordUseCase);
    provideDummy<Result<ChangePasswordResponse>>(
        FailedResult<ChangePasswordResponse>("Dummy Error")
    );
  });
  group("ChangePassword Bloc", (){
    final ChangePasswordRequest request=ChangePasswordRequest(
        password: "Mari123@",
        newPassword: "Mari123@1"
    );
    final successResponse=ChangePasswordResponse(
        message: "success",
        token:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiNjhhMjE4MjVhOGJjYTMwN2Y5ZGU5MzY1Iiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NTY1NjU5MDh9.SG6OMFWYluNn__hIfstJXPbT00zoPlMEghSDGvdTkSY"
    );
    blocTest<ChangePasswordBloc, ChangePasswordState>(
        "emits loading, Success when changePassword succeeds",
        build: () {
          when(mockGetChangePasswordUseCase.call(request)).
          thenAnswer((_)async=>SucessResult(successResponse));
          return changePasswordBloc;
        },
        act:(bloc) =>bloc.add(SubmitChangePasswordEvent(
           request)),
        expect: () => [
          ChangePasswordLoading(),
    const  ChangePasswordSuccess("success")

        ],
        verify: (_){
          verify(mockGetChangePasswordUseCase.call(request)).called(1);
        }
    );
    final failureResponse=ChangePasswordResponse(message: "invalid token .. login again");
    blocTest<ChangePasswordBloc, ChangePasswordState>

      (    "emits loading, Failure when changePassword succeeds",
        build: (){
          when(mockGetChangePasswordUseCase.call(request)).thenAnswer((_)async=>
              FailedResult<ChangePasswordResponse>(failureResponse.message));
          return changePasswordBloc;
        },
        act: (bloc)=>bloc.add(SubmitChangePasswordEvent( request,
            )),expect: ()=>[
          ChangePasswordLoading(),
          const ChangePasswordFailure('invalid token .. login again'),

        ],verify: (_){

          verify(mockGetChangePasswordUseCase.call(request)).called(1);
        });

  });
}