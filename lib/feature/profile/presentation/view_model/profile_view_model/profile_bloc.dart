// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// import 'package:tracking_app/feature/profile/domain/entity/driver_info_entity.dart';

// import '../../domain/entity/driver_contact_info_entity.dart';
// import '../../domain/entity/vehicle_info_entity.dart';

// part 'profile_event.dart';
// part 'profile_state.dart';

// class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
//   ProfileBloc() : super(ProfileInitial()) {
//     on<ProfileEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/core/helper/shared_preference.dart';
import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/profile/domain/use_case/get_logged_driver.dart';
import 'package:tracking_app/feature/profile/domain/use_case/logout_driver.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetLoggedDriverUseCase _getLoggedDriverUseCase;
  final LogoutDriverUseCase _logoutDriverUseCase;

  ProfileBloc(this._getLoggedDriverUseCase, this._logoutDriverUseCase)
    : super(const ProfileState()) {
    on<GetLoggedDriverEvent>(_getLoggedDriver);
    on<LogoutDriverEvent>(_logoutDriver);
  }

  Future<void> _getLoggedDriver(
    GetLoggedDriverEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final res = await _getLoggedDriverUseCase.getLoggedDriver();

    switch (res) {
      case SucessResult<DriverEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            driver: res.sucessResult,
            errorMessage: null,
          ),
        );
      case FailedResult<DriverEntity>():
        emit(state.copyWith(isLoading: false, errorMessage: res.errorMessage));
    }
  }

  Future<void> _logoutDriver(LogoutDriverEvent event, Emitter emit) async {

    final res = await _logoutDriverUseCase.logoutDriver();

    switch (res) {
      case SucessResult<void>():
      await  SharedPreferHelper.removeData(Constants.token);
        emit(
          state.copyWith(isLoading: false, loggedOut: true, errorMessage: null),
        );
      case FailedResult<void>():
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: res.errorMessage,
            loggedOut: false,
          ),
        );
    }
  }
}
