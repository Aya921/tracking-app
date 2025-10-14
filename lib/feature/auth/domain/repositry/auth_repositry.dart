import '../../../../core/api_result/result.dart';
import '../../api/models/login/request/login_request.dart';
import '../../api/models/login/response/login_response.dart';
import '../../api/models/apply/request/apply_request.dart';
import '../entity/country_entity.dart';
import '../../../../core/common/entity/driver_entity.dart';
import '../entity/vehicles_entity.dart';

abstract interface class AuthRepositry{
   Future<Result<LoginResponse>> login(LoginRequest request);
     Future<Result<String>> forgetPassword(String email);
  Future<Result<String>> verifyResetCode(String code);
  Future<Result<String>> resetPassword(String email,String newPassword);
  Future<Result<List<CountryEntity>>>getCountries();
  Future<Result<List<VehicleEntity>>>getAllVehicles();
  Future<Result<DriverEntity>> apply(ApplyRequest request ,
     );

}