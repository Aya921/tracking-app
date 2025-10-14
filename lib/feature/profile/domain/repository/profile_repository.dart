import 'dart:io';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_vehicle_request.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<DriverEntity>> getLoggedDriver();
  Future<Result<void>> logoutDriver();
  Future<Result<String>> uploadDriverPhoto(File photo);
  Future<Result<EditProfileEntity>> editProfile(EditProfileRequest request);
  Future<Result<ChangePasswordResponse>>changePassword(ChangePasswordRequest request);
  Future<Result<EditProfileEntity>> editVehicle(EditVehicleRequest request);
}
