import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/auth/api/models/login/request/login_request.dart';
import 'package:tracking_app/feature/auth/api/models/login/response/login_response.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/apply_request.dart';
import 'package:tracking_app/feature/auth/domain/entity/country_entity.dart';
import 'package:tracking_app/feature/auth/domain/entity/vehicles_entity.dart';
import '../../../../../core/common/driver_entity/driver_entity.dart';

abstract interface class AuthRemoteDataSource{
  Future<Result<LoginResponse>>login(LoginRequest request);

  Future<Result<String>> forgetPassword(String email);
  Future<Result<String>> verifyResetCode(String code);
  Future<Result<String>> resetPassword(String email,String newPassword);
  Future<Result<List<CountryEntity>>>getCountries();
  Future<Result<List<VehicleEntity>>>getAllVehicles();
  Future<Result<DriverEntity>> apply(ApplyRequest request);
}