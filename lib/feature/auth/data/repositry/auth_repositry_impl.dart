import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/apply_request.dart';
import 'package:tracking_app/feature/auth/api/models/login/request/login_request.dart';
import 'package:tracking_app/feature/auth/api/models/login/response/login_response.dart';
import 'package:tracking_app/feature/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:tracking_app/feature/auth/domain/entity/country_entity.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/feature/auth/domain/entity/vehicles_entity.dart';
import '../../domain/repositry/auth_repositry.dart';

@Injectable(as: AuthRepositry )
class AuthRepositryImpl implements  AuthRepositry{
   final AuthRemoteDataSource _authRemoteDataSource;
   AuthRepositryImpl(this._authRemoteDataSource);

  @override
  Future<Result<String>> forgetPassword(String email)async {
    return await _authRemoteDataSource.forgetPassword(email);
  }

  @override
  Future<Result<String>> verifyResetCode(String code)async{
    return await _authRemoteDataSource.verifyResetCode(code);
  }

  @override
  Future<Result<String>> resetPassword(String email, String newPassword) async{
   return await _authRemoteDataSource.resetPassword(email, newPassword);
  }
  @override
  Future<Result<LoginResponse>> login(LoginRequest request) async {
    return await _authRemoteDataSource.login(request);
}

 @override
  Future<Result<List<VehicleEntity>>> getAllVehicles()async {
    return await _authRemoteDataSource.getAllVehicles();
  }

  @override
  Future<Result<List<CountryEntity>>> getCountries()async {
    return await _authRemoteDataSource.getCountries();

  }

  @override
  Future<Result<DriverEntity>> apply(ApplyRequest request ,
    )async {
    return await _authRemoteDataSource.apply(request);
  }

}