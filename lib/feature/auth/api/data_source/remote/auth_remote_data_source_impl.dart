import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_error/api_error.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/extensions/apply_request_extension.dart';
import 'package:tracking_app/feature/auth/api/client/auth_api_services.dart';
import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';
import 'package:tracking_app/feature/auth/api/models/login/request/login_request.dart';
import 'package:tracking_app/feature/auth/api/models/login/response/login_response.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/apply_request.dart';
import 'package:tracking_app/feature/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:tracking_app/feature/auth/domain/entity/country_entity.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/feature/auth/domain/entity/time_zone.dart';
import 'package:tracking_app/feature/auth/domain/entity/vehicles_entity.dart';
import 'package:tracking_app/core/constants/constants.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiServices _authApiServices;

  const AuthRemoteDataSourceImpl(this._authApiServices,);

  @override
  Future<Result<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _authApiServices.login(request);
      await UserLocalStorageImpl().saveToken(response.token!);
      return SucessResult(response);
    } catch (error) {
      if (error is DioException) {
        return FailedResult(ServerFailure.
        fromDioError(error).errorMessage);
      } else {
        return FailedResult(error.toString());
      }
    }
  }

  @override
  Future<Result<List<VehicleEntity>>> getAllVehicles() async {
    try {
      final response = await _authApiServices.getAllVehicles();
      final vehicles =
          response.vehicles?.map((e) => e.toEntity()).toList() ?? [];
      return SucessResult(vehicles);
    } catch (error) {
      if (error is DioException) {
        return FailedResult(ServerFailure.fromDioError(error).errorMessage);
      } else {
        return FailedResult(error.toString());
      }
    }
  }

  @override
  Future<Result<String>> forgetPassword(String email) async {
    try {
      final response = await _authApiServices.forgetPassword({
        Constants.email: email,
      });
      if (response.info != null && response.info!.isNotEmpty) {
        return SucessResult<String>(response.info!);
      } else {
        final errorMessage =
            response.error ?? response.message ?? Constants.unknownError;
        return FailedResult<String>(errorMessage);
      }
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data[Constants.error] ?? dioError.message;
      return FailedResult<String>(errorMessage);
    } catch (error) {
      return FailedResult<String>(error.toString());
    }
  }

  @override
  Future<Result<String>> verifyResetCode(String code) async {
    try {
      final response = await _authApiServices.verifyResetCode({
        Constants.resetCode: code,
      });

      if (response[Constants.error] != null &&
          (response[Constants.error] as String).isNotEmpty) {
        return FailedResult<String>(response[Constants.error]!);
      }

      final message =
          response[Constants.status] ??
          response[Constants.message] ??
          Constants.success;
      return SucessResult<String>(message);
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data[Constants.error] ??
          dioError.response?.data[Constants.message] ??
          dioError.message;
      return FailedResult<String>(errorMessage);
    } catch (error) {
      return FailedResult<String>(error.toString());
    }
  }

  @override
  Future<Result<String>> resetPassword(String email, String newPassword) async {
    try {
      final response = await _authApiServices.resetPassword({
        Constants.email: email,
        Constants.newPassword: newPassword,
      });
      if (response.message != null && response.message!.isNotEmpty) {
        return SucessResult<String>(response.message!);
      } else {
        final errorMessage = response.error ?? Constants.unknownError;
        return FailedResult<String>(errorMessage);
      }
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data[Constants.error] ??
          dioError.response?.data[Constants.message] ??
          dioError.message;
      return FailedResult<String>(errorMessage);
    } catch (error) {
      return FailedResult<String>(error.toString());
    }
  }

  @override
  Future<Result<List<CountryEntity>>> getCountries() async {
    try {
      final response = await rootBundle.loadString(Constants.countriesJson);
      final data = jsonDecode(response) as List<dynamic>;

      final countries = data.map((json) {
        final timezonesJson = json[Constants.timezones] as List<dynamic>;
        final times = timezonesJson
            .map(
              (e) => Timezone(
                zoneName: e[Constants.zoneName],
                gmtOffset: e[Constants.gmtOffset],
                gmtOffsetName: e[Constants.gmtOffsetName],
                abbreviation: e[Constants.abbreviation],
                tzName: e[Constants.tzName],
              ),
            )
            .toList();
        return CountryEntity(
          isoCode: json[Constants.isoCode],
          name: json[Constants.name],
          phoneCode: json[Constants.phoneCode],
          flag: json[Constants.flag],
          currency: json[Constants.currency],
          latitude: json[Constants.latitude],
          longitude: json[Constants.longitude],
          timezones: times,
        );
      }).toList();
      return SucessResult(countries);
    } catch (error) {
      return FailedResult(error.toString());
    }
  }

  @override
  Future<Result<DriverEntity>> apply(ApplyRequest request) async {
    try {
      final formData = request.toFormData();
      final response = await _authApiServices.apply(await formData);
      final driver = response.driver!.toEntity();
      return SucessResult(driver);
    } catch (error) {
      if (error is DioException) {
        return FailedResult(ServerFailure.fromDioError(error).errorMessage);
      } else {
        return FailedResult(error.toString());
      }
    }
  }
}

