part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {}

class UploadDriverPhotoEvent extends EditProfileEvent{
  final File photo;
  UploadDriverPhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo];
}

class EditBtnSubmitEvent extends EditProfileEvent{
  final EditProfileRequest request;
  EditBtnSubmitEvent(this.request);

  @override
  List<Object?> get props => [request];
}
// class EditVehicleBtnSubmitEvent extends EditProfileEvent{
//   final EditVehicleRequest request;
//   EditVehicleBtnSubmitEvent(this.request);
//
//   @override
//   List<Object?> get props => [request];
// }

class PickImageEvent extends EditProfileEvent {
  final ImageSource source;
  PickImageEvent(this.source);

  @override
  List<Object?> get props => [source];
}





