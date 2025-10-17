import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/constants/end_points_constants.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/response/edit_profile_response.dart';
import 'package:tracking_app/feature/profile/api/models/get_logged_user_response.dart';

import '../models/change_password_request.dart';
import '../models/change_password_response.dart';
part 'profile_api_services.g.dart';
@RestApi(baseUrl: EndPointsConstants.baseUrl)
@injectable
abstract class ProfileApiServices {
  @factoryMethod
  factory ProfileApiServices(Dio dio) = _ProfileApiServices;
  @GET(EndPointsConstants.getprofileEndPoint)
  Future<GetLoggedUserResponse> getLoggedDriver();
  @GET(EndPointsConstants.logoutEndPoint)
  Future<GetLoggedUserResponse> logoutDriver();
  @PUT(EndPointsConstants.uploadDriverPhoto)
  @MultiPart()
  Future<String> uploadDriverPhoto(@Part(name: JsonSerlizationConstants.photo) File photo,);
  @PUT(EndPointsConstants.editDriverProfile)
  Future<EditProfileResponse> editProfile(@Body() EditProfileRequest request);
  @PUT(EndPointsConstants.editDriverProfile)
  // Future<EditProfileResponse> editVehicle
  //     (@Body() EditVehicleRequest request);
  @PATCH(EndPointsConstants.changePassword)
  Future<ChangePasswordResponse> changePassword(
      @Body() ChangePasswordRequest request,
      );

}
