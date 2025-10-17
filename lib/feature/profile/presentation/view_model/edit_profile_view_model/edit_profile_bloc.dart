import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';
import 'package:tracking_app/feature/profile/domain/use_case/edit_profile_use_case.dart';
import 'package:tracking_app/feature/profile/domain/use_case/upload_driver_photo_use_case.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

@injectable
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UploadDriverPhotoUseCase _uploadDriverPhotoUseCase;
  final EditProfileUseCase _editProfileUseCase;
  //final EditVehicleUseCase _editVehicleUseCase;
  final ImagePicker _picker = ImagePicker();
  EditProfileBloc(this._uploadDriverPhotoUseCase,
      this._editProfileUseCase)
    : super(const EditProfileState()) {
    on<UploadDriverPhotoEvent>(_uploadDriverPhoto);
    on<EditBtnSubmitEvent>(_editBtnSubmitEvent);
    on<PickImageEvent>(_onPickImage);
    // on<EditVehicleBtnSubmitEvent>(_editVehicle);
  }

  // Future<void> _editVehicle(
  //     EditVehicleBtnSubmitEvent event,
  //     Emitter<EditProfileState> emit,
  //     ) async {
  //   emit(state.copyWith(editVehicleRequestState: RequestState.loading));
  //   final result = await _editVehicleUseCase.editVehicle(
  //       event.request);
  //
  //   switch (result) {
  //
  //     case SucessResult<EditProfileEntity>():
  //   emit(state.copyWith(
  //     editVehicleRequestState: RequestState.success,
  //     editedVehicleInfo: result.sucessResult
  //   ));
  //     case FailedResult<EditProfileEntity>():
  //       emit(state.copyWith(
  //           editVehicleRequestState: RequestState.error,
  //        editVehicleErrorMessage: result.errorMessage
  //       ));
  //   }
  // }
  Future<void> _uploadDriverPhoto(
    UploadDriverPhotoEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(uploadPhotoRequestState: RequestState.loading));
    final result = await _uploadDriverPhotoUseCase.call(event.photo);

    switch (result) {
      case SucessResult<String>():
        emit(
          state.copyWith(
            uploadPhotoRequestState: RequestState.success,
            uploadPhotoResponse: result.sucessResult,
            selectedPhoto: event.photo,
          ),
        );
      case FailedResult<String>():
        emit(
          state.copyWith(
            uploadPhotoRequestState: RequestState.error,
            uploadPhotoErrorMessage: result.errorMessage,
          ),
        );
    }
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<EditProfileState> emit,
  ) async {

    try {
      final image = await _picker.pickImage(
        source: event.source,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);

        emit(state.copyWith(selectedPhoto: File(image.path)));
        add(UploadDriverPhotoEvent(file));
      } else {
        emit(state.copyWith(uploadPhotoErrorMessage: Constants.noImgSelected));
      }
    } catch (e) {
      emit(state.copyWith(uploadPhotoErrorMessage: Constants.failedPickImg));
    }
  }

  Future<void> _editBtnSubmitEvent(
    EditBtnSubmitEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(editProfileRequestState: RequestState.loading));
    final result = await _editProfileUseCase.call(event.request);

    switch (result) {
      case SucessResult<EditProfileEntity>():
        emit(
          state.copyWith(
            editProfileRequestState: RequestState.success,
            editedProfileInfo: result.sucessResult,
          ),
        );
      case FailedResult<EditProfileEntity>():
        emit(
          state.copyWith(
            editProfileRequestState: RequestState.error,
            editProfileErrorMessage: result.errorMessage,
          ),
        );
    }
  }
}
