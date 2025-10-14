import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/apply_request.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/auth_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/location_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/personal_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/vehicle_info.dart';
import 'package:tracking_app/feature/auth/api/models/login/request/login_request.dart';
import 'package:tracking_app/feature/auth/api/models/login/response/login_response.dart';
import 'package:tracking_app/feature/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:tracking_app/feature/auth/data/repositry/auth_repositry_impl.dart';
import 'package:tracking_app/feature/auth/domain/entity/country_entity.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/feature/auth/domain/entity/time_zone.dart';
import 'package:tracking_app/feature/auth/domain/entity/vehicles_entity.dart';
import 'package:tracking_app/feature/auth/domain/repositry/auth_repositry.dart';

import 'auth_repositry_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late AuthRepositryImpl authRepositoryImp;
  late AuthRepositry authRepository;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImp = AuthRepositryImpl(mockAuthRemoteDataSource);
    authRepository = AuthRepositryImpl(mockAuthRemoteDataSource);

    // Dummy values
    provideDummy<Result<String>>(SucessResult<String>("success"));
    provideDummy<Result<LoginResponse>>(FailedResult("Dummy Error"));
    provideDummy<Result<List<VehicleEntity>>>(FailedResult("Dummy Error"));
    provideDummy<Result<List<CountryEntity>>>(FailedResult("Dummy Error"));
    provideDummy<Result<DriverEntity>>(FailedResult("Dummy Error"));
  });

  group("Auth Repositry", () {
    group("Login Repositry", () {
      final LoginRequest request = LoginRequest(
        email: "mariammohmed.25720@gmail.com",
        password: "Mariam257@",
      );
      final successResponse = LoginResponse(
        message: "success",
        token:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OGQwNDIyY2RkODkzN2UwNTczZWUwNmMiLCJpYXQiOjE3NTg1NTIyNzF9.PHzemBMcIvQJN2J0NWtzPU5q3JdGq1mXiISTq25qMpY",
      );

      test("return SuccessResult when data source success", () async {
        when(
          mockAuthRemoteDataSource.login(request),
        ).thenAnswer((_) async => SucessResult(successResponse));

        final result = await authRepositoryImp.login(request);

        expect(result, isA<Result<LoginResponse>>());
        expect((result as SucessResult).sucessResult, successResponse);
        verify(mockAuthRemoteDataSource.login(request)).called(1);
      });

      test("return FailedResult when data source failed", () async {
        final exception = Exception("Throw Exception");
        when(
          mockAuthRemoteDataSource.login(request),
        ).thenAnswer((_) async => FailedResult(exception.toString()));

        final result = await authRepositoryImp.login(request);

        expect(result, isA<Result<LoginResponse>>());
        expect((result as FailedResult).errorMessage, exception.toString());
        verify(mockAuthRemoteDataSource.login(request)).called(1);
      });
    });

    group("Forget Password", () {
      const String email = "test@gmail.com";

      test("should return SuccessResult when remote call succeeds", () async {
        when(mockAuthRemoteDataSource.forgetPassword(email)).thenAnswer(
          (_) async => SucessResult<String>("OTP sent to your email"),
        );

        final result = await authRepository.forgetPassword(email);

        expect(result, isA<SucessResult<String>>());
        final success = result as SucessResult<String>;
        expect(success.sucessResult, "OTP sent to your email");
        verify(mockAuthRemoteDataSource.forgetPassword(email)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });

      test("should return FailedResult when remote call fails", () async {
        when(
          mockAuthRemoteDataSource.forgetPassword(email),
        ).thenAnswer((_) async => FailedResult<String>("Server error"));

        final result = await authRepository.forgetPassword(email);

        expect(result, isA<FailedResult<String>>());
        final error = result as FailedResult<String>;
        expect(error.errorMessage, "Server error");
        verify(mockAuthRemoteDataSource.forgetPassword(email)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
    });

    group("Verify Reset Code", () {
      const code = "123456";

      test("should return SuccessResult when remote call succeeds", () async {
        when(mockAuthRemoteDataSource.verifyResetCode(code)).thenAnswer(
          (_) async => SucessResult<String>("Code verified successfully"),
        );

        final result = await authRepository.verifyResetCode(code);

        expect(result, isA<SucessResult<String>>());
        final success = result as SucessResult<String>;
        expect(success.sucessResult, "Code verified successfully");
        verify(mockAuthRemoteDataSource.verifyResetCode(code)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });

      test("should return FailedResult when remote call fails", () async {
        when(
          mockAuthRemoteDataSource.verifyResetCode(code),
        ).thenAnswer((_) async => FailedResult<String>("Invalid reset code"));

        final result = await authRepository.verifyResetCode(code);

        expect(result, isA<FailedResult<String>>());
        final error = result as FailedResult<String>;
        expect(error.errorMessage, "Invalid reset code");
        verify(mockAuthRemoteDataSource.verifyResetCode(code)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
    });

    group("Reset Password", () {
      const email = "test@gmail.com";
      const newPassword = "12345678";

      test("should return SuccessResult when remote call succeeds", () async {
        when(
          mockAuthRemoteDataSource.resetPassword(email, newPassword),
        ).thenAnswer(
          (_) async => SucessResult<String>("Password reset successfully"),
        );

        final result = await authRepository.resetPassword(email, newPassword);

        expect(result, isA<SucessResult<String>>());
        final success = result as SucessResult<String>;
        expect(success.sucessResult, "Password reset successfully");
        verify(
          mockAuthRemoteDataSource.resetPassword(email, newPassword),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });

      test("should return FailedResult when remote call fails", () async {
        when(
          mockAuthRemoteDataSource.resetPassword(email, newPassword),
        ).thenAnswer((_) async => FailedResult<String>("Invalid request"));

        final result = await authRepository.resetPassword(email, newPassword);

        expect(result, isA<FailedResult<String>>());
        final error = result as FailedResult<String>;
        expect(error.errorMessage, "Invalid request");
        verify(
          mockAuthRemoteDataSource.resetPassword(email, newPassword),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      });
    });
    group("Get Vehicles", () {
      final successResponse = [
        VehicleEntity(
          type: "Motor Cycle",
          speed: 90,
          id: "676b63c99f3884b3405c149b",
          image:
              "https://flower.elevateegy.com/uploads/3be99805-65e0-4f05-9e98-4ccfb0b2ca5f-Chopper.png",
          createdAt: DateTime.parse("2024-12-25T01:45:45.397Z").toString(),
          updatedAt: DateTime.parse("2024-12-25T01:45:45.397Z").toString(),
        ),
      ];
      test(
        "should return SuccessResult when remote call succeeds on get vehicles",
        () async {
          when(
            mockAuthRemoteDataSource.getAllVehicles(),
          ).thenAnswer((_) async => SucessResult(successResponse));
          final result = await authRepositoryImp.getAllVehicles();
          expect(result, isA<SucessResult>());
          expect((result as SucessResult).sucessResult, successResponse);
          verify(mockAuthRemoteDataSource.getAllVehicles()).called(1);
        },
      );
      test(
        "should return FailedsResult when datasource  call failed on get vehicles",
        () async {
          when(
            mockAuthRemoteDataSource.getAllVehicles(),
          ).thenAnswer((_) async => FailedResult("Something went wrong"));
          final result = await authRepositoryImp.getAllVehicles();
          expect(result, isA<FailedResult>());
          expect((result as FailedResult).errorMessage, "Something went wrong");
          verify(mockAuthRemoteDataSource.getAllVehicles()).called(1);
        },
      );
    });
    group("Get Countries", () {
      final countries = [
        const CountryEntity(
          isoCode: "AF",
          name: "Afghanistan",
          phoneCode: "93",
          flag: "🇦🇫",
          currency: "AFN",
          latitude: "33.00000000",
          longitude: "65.00000000",
          timezones: [
            Timezone(
              zoneName: "Asia/Kabul",
              gmtOffset: 16200,
              gmtOffsetName: "UTC+04:30",
              abbreviation: "AFT",
              tzName: "Afghanistan Time",
            ),
          ],
        ),
      ];
      test(
        "should return SuccessResult when remote call  success when get countries",

        () async {
          when(
            mockAuthRemoteDataSource.getCountries(),
          ).thenAnswer((_) async => SucessResult(countries));
          final result = await authRepositoryImp.getCountries();
          expect(result, isA<SucessResult>());
          expect((result as SucessResult).sucessResult, countries);
          verify(mockAuthRemoteDataSource.getCountries()).called(1);
        },
      );
      test(
        "should return SuccessResult when remote call  failed when get countries",

        () async {
          const error = "failed to get country";
          when(
            mockAuthRemoteDataSource.getCountries(),
          ).thenAnswer((_) async => FailedResult(error));
          final result = await authRepositoryImp.getCountries();
          expect(result, isA<FailedResult>());
          expect((result as FailedResult).errorMessage, error);
          verify(mockAuthRemoteDataSource.getCountries()).called(1);
        },
      );
    });
    group("Apply ", () {
      // late File fakeFile;
      //
      // setUpAll(() async {
      //   final tempDir = await Directory.systemTemp.createTemp();
      //   fakeFile = File('${tempDir.path}/fake_image.png');
      //   await fakeFile.writeAsBytes(Uint8List.fromList([0, 1, 2, 3]) as List<int>);
      // });
      //
      // tearDownAll(() async {
      //   try {
      //     await fakeFile.delete();
      //   } catch (e) {
      //     // Ignore deletion errors
      //   }
      // });
      // Future<FormData> createRequestBody() async {
      //   return ApplyRequest(
      //       authenticationInfo: AuthenticationInfo(
      //           password: "Mariam257@",
      //           rePassword: "Mariam257@"
      //       ),
      //       locationInfo: LocationInfo(
      //           country: "Egypt"
      //       ),
      //       vehicleInfo: VehicleInfo(
      //           vehicleNumber: "12228",
      //           vehicleLicense: File("fake_image.png"),
      //           vehicleType: "676b31a45d05310ca82657ac"
      //       ),
      //       personalInfo: PersonalInfo(
      //           lastName: "mohmed2",
      //           firstName: "mariam1",
      //           phone: "+20101070082",
      //           gender: "female",
      //           email: "mariammohmed55@gmail.com",
      //           nid: "12345678912345",
      //           nidimg: File("fake_image.png")
      //       )
      //   ).toFormData();
      // }
      const successResponse = DriverEntity(
        id: "68d983e4dd8937e0573fea27",
        firstName: "mariam1",
        lastName: "mohmed2",
        contactInfo: ContactInfo(
          country: "Egypt",
          gender: "female",
          email: "mariammohmed5@gmail.com",
          phone: "+20101070082",
          photo: "default-profile.png",
        ),
        vehicle: VehicleInfo(
          type: "676b31a45d05310ca82657ac",
          number: "12221",
          license: "fake_image.png",
        ),
        identity: IdentityInfo(nid: "12345678912345", nidImg: "fake_image.png"),
        meta: MetaInfo(role: "driver", createdAt: "2025-09-28T18:52:20.452Z"),
      );

      ApplyRequest createRequest() {
        return ApplyRequest(
          authenticationInfo: AuthenticationInfo(
            password: "Mariam257@",
            rePassword: "Mariam257@",
          ),
          locationInfo: LocationInfo(country: "Egypt"),
          vehicleInfo: VehicleInfoModel(
            vehicleNumber: "12228",
            vehicleLicense: File("fake_image.png"),
            vehicleType: "676b31a45d05310ca82657ac",
          ),
          personalInfo: PersonalInfo(
            lastName: "mohmed2",
            firstName: "mariam1",
            phone: "+20101070082",
            gender: "female",
            email: "mariammohmed55@gmail.com",
            nid: "12345678912345",
            nidimg: File("fake_image.png"),
          ),
        );
      }

      test("return SuccessResult when datasource success when apply", () async {
        final request = createRequest();
        when(
          mockAuthRemoteDataSource.apply(request),
        ).thenAnswer((_) async => SucessResult(successResponse));
        final result = await authRepositoryImp.apply(request);
        expect(result, isA<SucessResult>());
        expect((result as SucessResult).sucessResult, successResponse);
        verify(mockAuthRemoteDataSource.apply(request)).called(1);
      });
      test("return FailedResult when datasource failed when apply", () async {
        final request = createRequest();

        when(
          mockAuthRemoteDataSource.apply(request),
        ).thenAnswer((_) async => FailedResult("failed to apply"));
        final result = await authRepositoryImp.apply(request);
        expect(result, isA<FailedResult>());
        expect((result as FailedResult).errorMessage, "failed to apply");
        verify(mockAuthRemoteDataSource.apply(request)).called(1);
      });
    });
  });
}
