import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/safe_api_call/safe_api_call.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_request.dart';
import 'package:tracking_app/feature/profile/api/models/change_password_response.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/feature/profile/api/client/profile_api_services.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_vehicle_request.dart';
import 'package:tracking_app/feature/profile/data/data_source/profile_remote_data_source.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiServices _profileApiServices;
  ProfileRemoteDataSourceImpl(this._profileApiServices);

  @override
  Future<Result<DriverEntity>> getLoggedDriver() async {
    try {
      final driverRespnse = await _profileApiServices.getLoggedDriver();

      final driverEntity = driverRespnse.driver!.toEntity();
   
      return SucessResult(driverEntity);
    } catch (e) {
      return FailedResult(e.toString());
    }
  }
  
  @override
  Future<Result<void>> logoutDriver()async {
   try {
     await _profileApiServices.logoutDriver();

      return SucessResult(null);
    } catch (e) {
      return FailedResult(e.toString());
    }
  
  
  }

  @override
  Future<Result<String>> uploadDriverPhoto(File photo) async {
    return safeCall(
          () => _profileApiServices.uploadDriverPhoto(photo),
    );
  }

  @override
  Future<Result<EditProfileEntity>> editProfile(EditProfileRequest request) {
    return safeCall(() async {
      final response = await _profileApiServices.editProfile(request);
      return response.toEntity();
    });
  }

   @override
  Future<Result<ChangePasswordResponse>> changePassword(ChangePasswordRequest request)async {

     return safeCall(() async {
      final response =await _profileApiServices.changePassword(request);
      return response;
    });
  
  }

  @override
  Future<Result<EditProfileEntity>> editVehicle(EditVehicleRequest request) {
  return safeCall(()async{
    final response=await _profileApiServices.editVehicle(request);
    return response.toEntity();
  });

  }
 
}

