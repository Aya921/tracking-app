import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';
import 'package:tracking_app/feature/auth/api/models/login/response/login_response.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/login_view_model/login_states.dart';

import '../../../domain/use_case/login_use_case.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginStates> {
  final LoginUseCase useCase;

  LoginBloc(this.useCase) : super(const LoginStates()) {
    on<GetLoginEvent>((event, emit) async {
      emit(state.copyWith(requestState: RequestState.loading));
      final result = await useCase.login(event.request);
      switch (result) {
        case SucessResult<LoginResponse>():

          emit(
            state.copyWith(
              requestState: RequestState.success,
              loginResponse: result.sucessResult,
            ),
          );
          final    token = result.sucessResult.token;
          if (token != null) {
            await UserLocalStorageImpl().saveToken(token);
          }
          if(state.rememberMe==true){
            await UserLocalStorageImpl().saveLoging(token!);
          }
        case FailedResult<LoginResponse>():
          emit(
            state.copyWith(
              requestState: RequestState.error,
              errorMessageLogin: result.errorMessage,
            ),
          );
      }
    });
    on<RememberMeEvent>((event, emit) async {

      emit(state.copyWith(rememberMe: event.isLoggedIn));
    });
  }
}


