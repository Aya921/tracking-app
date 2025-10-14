import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_vehicle_request.dart';
import 'package:tracking_app/feature/profile/data/data_source/profile_remote_data_source.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/feature/profile/domain/repository/profile_repository.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _profileRemoteDataSource;
  ProfileRepositoryImpl(this._profileRemoteDataSource);

   @override
  Future<Result<DriverEntity>> getLoggedDriver() async {
    return await _profileRemoteDataSource.getLoggedDriver();
  }

  @override
  Future<Result<void>> logoutDriver() async {
    return await _profileRemoteDataSource.logoutDriver();
  }

  @override
  Future<Result<String>> uploadDriverPhoto(File photo) async {
    return await _profileRemoteDataSource.uploadDriverPhoto(photo);
  }

  @override
  Future<Result<EditProfileEntity>> editProfile(EditProfileRequest request) async{
    return await _profileRemoteDataSource.editProfile(request);
    
  }


   @override
  Future<Result<ChangePasswordResponse>> changePassword(ChangePasswordRequest request) async {
   return await _profileRemoteDataSource.changePassword(request);

  }

  @override
  Future<Result<EditProfileEntity>>
  editVehicle(EditVehicleRequest request)async {
  return await _profileRemoteDataSource.editVehicle(request);
  }
}
