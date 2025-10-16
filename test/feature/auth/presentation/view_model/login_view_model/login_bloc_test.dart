import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';
import 'package:tracking_app/feature/auth/api/models/login/request/login_request.dart';
import 'package:tracking_app/feature/auth/api/models/login/response/login_response.dart';
import 'package:tracking_app/feature/auth/domain/use_case/login_use_case.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/login_view_model/login_bloc.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/login_view_model/login_states.dart';
import 'login_bloc_test.mocks.dart';

@GenerateMocks([LoginUseCase,UserLocalStorageImpl])
void main() {
  late MockLoginUseCase mockLoginUseCase;
  late LoginBloc bloc;
late MockUserLocalStorageImpl userLocalStorageImpl;
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    userLocalStorageImpl=MockUserLocalStorageImpl();
    bloc = LoginBloc(mockLoginUseCase);
    provideDummy<Result<LoginResponse>>(FailedResult("Dummy Error"));
  });
  final LoginRequest request = LoginRequest(
    email: "mariammohmed.25720@gmail.com",
    password: "Mariam257@",
  );
  final successResponse = LoginResponse(
    message: "success",
    token:
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OGQwNDIyY2RkODkzN2UwNTczZWUwNmMiLCJpYXQiOjE3NTg1NTIyNzF9.PHzemBMcIvQJN2J0NWtzPU5q3JdGq1mXiISTq25qMpY",
  );
  group("Login Event", () {


    // blocTest<LoginBloc, LoginStates>(
    //   "emits [loading, success] when LoginEvent succeed",
    //   build: () {
    //     when(
    //       mockLoginUseCase.login(request),
    //
    //     ).thenAnswer((_) async => SucessResult(successResponse));
    //
    //     when(userLocalStorageImpl.saveToken(successResponse.token))
    //         .thenAnswer((_) async {});
    //     when(userLocalStorageImpl.saveLoging(any))
    //         .thenAnswer((_) async {});
    //     return bloc;
    //   },
    //   act: (bloc) => bloc..add(GetLoginEvent(request)),
    //   expect: () => [
    //     const LoginStates(requestState: RequestState.loading),
    //     LoginStates(
    //       requestState: RequestState.success,
    //       loginResponse: successResponse,
    //     ),
    //   ],
    //   verify: (_) => verify(mockLoginUseCase.login(request)).called(1),
    // );
    const errorMessage = "incorrect email or password";
    blocTest<LoginBloc, LoginStates>(
      "emits [loading, failure] when LoginEvent failed",
      build: () {
        when(
          mockLoginUseCase.login(request),
        ).thenAnswer((_) async => FailedResult(errorMessage));
        return bloc;
      },
      act: (bloc) => bloc..add(GetLoginEvent(request)),
      expect: () => [
        const LoginStates(requestState: RequestState.loading),
        const LoginStates(
          requestState: RequestState.error,
          errorMessageLogin: errorMessage,
        ),
      ],
      verify: (_) => verify(mockLoginUseCase.login(request)).called(1),
    );
  });
  group("Remember Me Event", (){
    blocTest<LoginBloc, LoginStates>
      ("emits updated rememberMe state when RememberMeEvent is added with isLoggedIn true", build: (){
     when(mockLoginUseCase.login(request));
      return bloc;
    },act: (bloc)=>bloc..add(RememberMeEvent(true),

    ),expect: ()=>[
     const LoginStates(
       rememberMe: true
      )
    ]);
    blocTest<LoginBloc, LoginStates>
    ("emits updated rememberMe state when RememberMeEvent is added with"
        " isLoggedIn false", build: (){
    return bloc;
    },act: (bloc)=>bloc..add(RememberMeEvent(false),

    ),expect: ()=>[
    const LoginStates(
    rememberMe: false
    )
    ]);
  });
}
