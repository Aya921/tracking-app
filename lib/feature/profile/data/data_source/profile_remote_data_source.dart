import 'dart:io';

import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_vehicle_request.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';

import '../../../../core/api_result/result.dart';

abstract interface class ProfileRemoteDataSource {

  Future<Result<DriverEntity>> getLoggedDriver();
   Future<Result<void>> logoutDriver();
 Future<Result<String>> uploadDriverPhoto(File photo);
  Future<Result<EditProfileEntity>> editProfile(EditProfileRequest request);
  Future<Result<EditProfileEntity>>
  editVehicle(EditVehicleRequest request);

    Future<Result<ChangePasswordResponse>>changePassword(ChangePasswordRequest request);
}
