import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/auth/api/client/auth_api_services.dart';
import 'package:tracking_app/feature/auth/api/data_source/remote/auth_remote_data_source_impl.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/apply_request.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/auth_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/location_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/personal_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/vehicle_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/response/apply_response/all_vehicles_response.dart';
import 'package:tracking_app/feature/auth/api/models/apply/response/apply_response/apply_response.dart';
import 'package:tracking_app/feature/auth/api/models/login/request/login_request.dart';
import 'package:tracking_app/feature/auth/api/models/login/response/login_response.dart';
import 'package:tracking_app/feature/auth/api/models/forget_password/forget_password_response.dart';
import 'package:tracking_app/feature/auth/api/models/forget_password/reset_password_response.dart';
import 'package:tracking_app/feature/auth/domain/entity/country_entity.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';
import 'package:flutter/services.dart';
@GenerateMocks([AuthApiServices,AssetBundle])
void main() {
  late MockAuthApiServices mockAuthApiServices;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late MockAssetBundle mockAssetBundle;
  TestWidgetsFlutterBinding.ensureInitialized();


  setUp(() async {
    // إنشاء فايل مؤقت لكل test

    mockAuthApiServices = MockAuthApiServices();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(mockAuthApiServices);
    mockAssetBundle=MockAssetBundle();
    provideDummy<Result<List<CountryEntity>>>(FailedResult("Dummy Error in countries"));
  });



  group("AuthRemoteDataSourceImpl Tests", () {
    group("Login", () {
      final request = LoginRequest(
        email: "mariammohmed.25720@gmail.com",
        password: "Mariam257@",
      );
      // final successResponse = LoginResponse(
      //   message: "success",
      //   token: "dummy_token",
      // );

      // test("return SuccessResult when API call succeeds", () async {
      //   when(mockAuthApiServices.login(request))
      //       .thenAnswer((_) async => successResponse);

      //   final result = await authRemoteDataSourceImpl.login(request);

      //   expect(result, isA<SucessResult<LoginResponse>>());
      //   expect((result as SucessResult).sucessResult, successResponse);
      //   verify(mockAuthApiServices.login(request)).called(1);
      // });

      test("return FailedResult when DioException is thrown", () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: "/"),
          type: DioExceptionType.connectionTimeout,
        );
        when(mockAuthApiServices.login(request)).thenThrow(dioException);

        final result = await authRemoteDataSourceImpl.login(request);

        expect(result, isA<FailedResult<LoginResponse>>());
        expect((result as FailedResult).errorMessage,
            "ServerFailure with Api Server");
        verify(mockAuthApiServices.login(request)).called(1);
      });

      test("return FailedResult when generic Exception is thrown", () async {
        final exception = Exception("Unexpected error");
        when(mockAuthApiServices.login(request)).thenThrow(exception);

        final result = await authRemoteDataSourceImpl.login(request);

        expect(result, isA<FailedResult<LoginResponse>>());
        expect((result as FailedResult).errorMessage, exception.toString());
        verify(mockAuthApiServices.login(request)).called(1);
      });
    });

    group("Forget Password", () {
      const email = "test11@gmail.com";

      test("return SuccessResult when OTP is sent", () async {
        final fakeResponse =
            ForgetPasswordResponse(info: "OTP sent to your email", message: "success");
        when(mockAuthApiServices.forgetPassword({"email": email}))
            .thenAnswer((_) async => fakeResponse);

        final result = await authRemoteDataSourceImpl.forgetPassword(email);

        expect(result, isA<SucessResult<String>>());
        expect((result as SucessResult).sucessResult, "OTP sent to your email");
        verify(mockAuthApiServices.forgetPassword(any)).called(1);
      });

      test("return FailedResult when API returns error", () async {
        final fakeResponse = ForgetPasswordResponse(
            error: "There is no account with this email address $email");
        when(mockAuthApiServices.forgetPassword({"email": email}))
            .thenAnswer((_) async => fakeResponse);

        final result = await authRemoteDataSourceImpl.forgetPassword(email);

        expect(result, isA<FailedResult<String>>());
        expect((result as FailedResult).errorMessage,
            "There is no account with this email address $email");
        verify(mockAuthApiServices.forgetPassword(any)).called(1);
      });

      test("return FailedResult when DioException is thrown", () async {
        final dioError = DioException(
          requestOptions: RequestOptions(path: "/forget-password"),
          response: Response(
            requestOptions: RequestOptions(path: "/forget-password"),
            statusCode: 400,
            data: {
              "error": "There is no account with this email address $email",
            },
          ),
          type: DioExceptionType.badResponse,
        );
        when(mockAuthApiServices.forgetPassword(any)).thenThrow(dioError);

        final result = await authRemoteDataSourceImpl.forgetPassword(email);

        expect(result, isA<FailedResult<String>>());
        expect((result as FailedResult).errorMessage,
            "There is no account with this email address $email");
        verify(mockAuthApiServices.forgetPassword(any)).called(1);
      });

      test("return FailedResult when generic Exception is thrown", () async {
        when(mockAuthApiServices.forgetPassword(any))
            .thenThrow(Exception("Unexpected error"));

        final result = await authRemoteDataSourceImpl.forgetPassword(email);

        expect(result, isA<FailedResult<String>>());
        expect((result as FailedResult).errorMessage,
            Exception("Unexpected error").toString());
        verify(mockAuthApiServices.forgetPassword(any)).called(1);
      });
    });

    group("Verify Reset Code", () {
      const code = "123456";

      test("return SuccessResult when code is valid", () async {
        final fakeResponse = {"status": "Code verified successfully"};
        when(mockAuthApiServices.verifyResetCode({"resetCode": code}))
            .thenAnswer((_) async => fakeResponse);

        final result = await authRemoteDataSourceImpl.verifyResetCode(code);

        expect(result, isA<SucessResult<String>>());
        expect((result as SucessResult).sucessResult, "Code verified successfully");
        verify(mockAuthApiServices.verifyResetCode(any)).called(1);
      });

      test("return FailedResult when API returns error", () async {
        final fakeResponse = {"error": "Invalid reset code"};
        when(mockAuthApiServices.verifyResetCode({"resetCode": code}))
            .thenAnswer((_) async => fakeResponse);

        final result = await authRemoteDataSourceImpl.verifyResetCode(code);

        expect(result, isA<FailedResult<String>>());
        expect((result as FailedResult).errorMessage, "Invalid reset code");
        verify(mockAuthApiServices.verifyResetCode(any)).called(1);
      });

      test("return FailedResult when DioException is thrown", () async {
        final dioError = DioException(
          requestOptions: RequestOptions(path: "/verify-reset-code"),
          response: Response(
            requestOptions: RequestOptions(path: "/verify-reset-code"),
            statusCode: 400,
            data: {"error": "Invalid reset code"},
          ),
          type: DioExceptionType.badResponse,
        );
        when(mockAuthApiServices.verifyResetCode(any)).thenThrow(dioError);

        final result = await authRemoteDataSourceImpl.verifyResetCode(code);

        expect(result, isA<FailedResult<String>>());
        expect((result as FailedResult).errorMessage, "Invalid reset code");
        verify(mockAuthApiServices.verifyResetCode(any)).called(1);
      });
    });

    group("Reset Password", () {
      const email = "test11@gmail.com";
      const newPassword = "12345678";

      test("return SuccessResult when reset is successful", () async {
        final fakeResponse =
            ResetPasswordResponse(message: "Password reset successfully");
        when(mockAuthApiServices
                .resetPassword({"email": email, "newPassword": newPassword}))
            .thenAnswer((_) async => fakeResponse);

        final result =
            await authRemoteDataSourceImpl.resetPassword(email, newPassword);

        expect(result, isA<SucessResult<String>>());
        expect((result as SucessResult).sucessResult, "Password reset successfully");
        verify(mockAuthApiServices.resetPassword(any)).called(1);
      });

      test("return FailedResult when API returns error", () async {
        final fakeResponse = ResetPasswordResponse(error: "Invalid request");
        when(mockAuthApiServices
                .resetPassword({"email": email, "newPassword": newPassword}))
            .thenAnswer((_) async => fakeResponse);

        final result =
            await authRemoteDataSourceImpl.resetPassword(email, newPassword);

        expect(result, isA<FailedResult<String>>());
        expect((result as FailedResult).errorMessage, "Invalid request");
        verify(mockAuthApiServices.resetPassword(any)).called(1);
      });

      test("return FailedResult when DioException is thrown", () async {
        final dioError = DioException(
          requestOptions: RequestOptions(path: "/reset-password"),
          response: Response(
            requestOptions: RequestOptions(path: "/reset-password"),
            statusCode: 400,
            data: {"error": "Invalid request"},
          ),
          type: DioExceptionType.badResponse,
        );
        when(mockAuthApiServices.resetPassword(any)).thenThrow(dioError);

        final result =
            await authRemoteDataSourceImpl.resetPassword(email, newPassword);

        expect(result, isA<FailedResult<String>>());
        expect((result as FailedResult).errorMessage, "Invalid request");
        verify(mockAuthApiServices.resetPassword(any)).called(1);
      });
    });
    group("get vehicles",(){
      final successResponse=AllVehiclesResponse(
        message: "success",metadata: Metadata(
          currentPage: 1,
          totalPages: 1,
          limit: 40,
          totalItems: 7
      ),
        vehicles: [
          Vehicles(
type: "Motor Cycle",
            speed: 90,
            id: "676b63c99f3884b3405c149b",
            image: "https://flower.elevateegy.com/uploads/3be99805-65e0-4f05-9e98-4ccfb0b2ca5f-Chopper.png",
            createdAt: DateTime.parse("2024-12-25T01:45:45.397Z").toString(),
            updatedAt: DateTime.parse("2024-12-25T01:45:45.397Z").toString(),
          )
        ]
      );
      test(
          "return SuccessResult when API call succeeds when get vehicles", () async {
        when(mockAuthApiServices.getAllVehicles()).thenAnswer((
            _) async => successResponse);

        final result = await authRemoteDataSourceImpl.getAllVehicles();
        final vehicles=successResponse.vehicles?.map((e)=>e.toEntity()).toList();
        expect(result, isA<SucessResult>());

        expect((result as SucessResult).sucessResult, vehicles);
        verify(mockAuthApiServices.getAllVehicles()).called(1);
      });
      test("return FailedResult when API call failed when get vehicles on dioException" , ()async{
        final dioException=DioException(requestOptions: RequestOptions(
          path: "/"
        ),type: DioExceptionType.connectionTimeout);
        when(mockAuthApiServices.getAllVehicles()).thenThrow(dioException);
        final result=await authRemoteDataSourceImpl.getAllVehicles();
        expect(result, isA<FailedResult>());
        expect((result as FailedResult).errorMessage, "ServerFailure with Api Server");
        verify(mockAuthApiServices.getAllVehicles()).called(1);
        
      });
      test("return FailedResult when API call failed when get vehicles on exception", ()async{
        final exception=Exception("Throw Exception");
        when(mockAuthApiServices.getAllVehicles()).thenThrow(exception);
        final result=await authRemoteDataSourceImpl.getAllVehicles();
        expect(result, isA<FailedResult>());
        expect((result as FailedResult).errorMessage, exception.toString());
        verify(mockAuthApiServices.getAllVehicles()).called(1);
      });
    });
group("get all countries", (){
   const countriesJson = '''
    [
       {
    "isoCode": "AF",
    "name": "Afghanistan",
    "phoneCode": "93",
    "flag": "🇦🇫",
    "currency": "AFN",
    "latitude": "33.00000000",
    "longitude": "65.00000000",
    "timezones": [
      {
        "zoneName": "Asia/Kabul",
        "gmtOffset": 16200,
        "gmtOffsetName": "UTC+04:30",
        "abbreviation": "AFT",
        "tzName": "Afghanistan Time"
      }
    ]
  }
    ]
  ''';
  // final List<CountryEntity> countries=[
  //   const CountryEntity(isoCode: "AF", name: "Afghanistan", phoneCode: "93", flag: "🇦🇫", currency: "AFN",
  //       latitude: "33.00000000", longitude: "65.00000000", timezones: [
  //         Timezone(zoneName: "Asia/Kabul", gmtOffset: 16200, gmtOffsetName: "UTC+04:30", abbreviation: "AFT", tzName: "Afghanistan Time")
  //       ])
  // ];
  test("Should return ApiSuccessResult when load json", ()async{
    when(mockAssetBundle.loadString("assets/json/country.json")).
    thenAnswer((_)async=>countriesJson);
    final result=await authRemoteDataSourceImpl.getCountries();
    expect(result, isA<SucessResult>());
   final  List<CountryEntity> data=((result as SucessResult).sucessResult);
    final d=data[0];
    expect(d.name,"Afghanistan");
    expect(d.phoneCode,"93");
  });
});
//     group("Apply ", (){
//    late    File fakeFile;
//
//       setUpAll(() async {
//         final tempDir = Directory.systemTemp;
//         fakeFile = File('${tempDir.path}/fake_image.png');
//         await fakeFile.writeAsBytes(Uint8List.fromList([0, 1, 2, 3]));
//       });
// final body=ApplyRequest(
//   authenticationInfo: AuthenticationInfo(
//      password: "Mariam257@",rePassword: "Mariam257@"
//   ),
//   locationInfo: LocationInfo(
//     country: "Egypt"
//   ),
//   vehicleInfo: VehicleInfo(
//     vehicleNumber: "12228",
//     vehicleLicense: fakeFile
//       ,vehicleType: ""
//   ),
//   personalInfo: PersonalInfo(
//     lastName: "mohmed2",
//     firstName: "mariam1",phone: "+20101070082", gender: "female",
//     email: "mariammohmed55@gmail.com",nid: "12345678912345",
//       nidimg: fakeFile
//   )
// ).toFormData();
// final request = ApplyRequest(
//   authenticationInfo: AuthenticationInfo(
//     password: "Mariam257@",
//     rePassword: "Mariam257@",
//   ),
//   locationInfo: LocationInfo(country: "Egypt"),
//   vehicleInfo: VehicleInfo(
//     vehicleNumber: "12228",
//     vehicleLicense: fakeFile,
//     vehicleType: "676b31a45d05310ca82657ac",
//   ),
//   personalInfo: PersonalInfo(
//     lastName: "mohmed2",
//     firstName: "mariam1",
//     phone: "+20101070082",
//     gender: "female",
//     email: "mariammohmed55@gmail.com",
//     nid: "12345678912345",
//     nidimg: fakeFile,
//   ),
// );
// final successResponse=ApplyResponse(
//   message: "success",token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OGQ5ODNlNGRkODkzN2UwNTczZmVhMjciLCJpYXQiOjE3NTkwODU1NDB9.HGJTNJltl0p87p8XKBjmefSZ7aSB0tv37fYOEjt5olI",
//   driver: Driver(
//       country: "Egypt",
//       firstName: "mariam1",
//       lastName: "mohmed2",
//       vehicleType: "676b31a45d05310ca82657ac",
//       vehicleNumber: "12221",
//       vehicleLicense: "fake_image.png",
//       nId: "12345678912345",
//       nIdImg: "fake_image.png",
//       email: "mariammohmed5@gmail.com",
//       gender: "female",
//       phone: "+20101070082",
//       photo: "default-profile.png",
//       role: "driver",
//       id: "68d983e4dd8937e0573fea27",
//       createdAt: "2025-09-28T18:52:20.452Z"
//   )
// );
// test("return SuccessResult when API call succeeds when sign up",
//         ()async{
//   when(mockAuthApiServices.apply(await body)).
//   thenAnswer((_)async=>successResponse);
//   final result=await authRemoteDataSourceImpl.apply(request);
//   expect(result, isA<SucessResult>());
//   expect((result as SucessResult).sucessResult, successResponse);
//         });
//
//     });
    group("Apply ", () {
      late File fakeFile;

      setUpAll(() async {
        final tempDir = await Directory.systemTemp.createTemp();
        fakeFile = File('${tempDir.path}/fake_image.png');
        await fakeFile.writeAsBytes(Uint8List.fromList([0, 1, 2, 3]));
      });

      tearDownAll(() async {
        try {
          await fakeFile.delete();
        } catch (e) {
          // Ignore deletion errors
        }
      });



      final successResponse = ApplyResponse(
          message: "success",
          token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OGQ5ODNlNGRkODkzN2UwNTczZmVhMjciLCJpYXQiOjE3NTkwODU1NDB9.HGJTNJltl0p87p8XKBjmefSZ7aSB0tv37fYOEjt5olI",
          driver: Driver(
              country: "Egypt",
              firstName: "mariam1",
              lastName: "mohmed2",
              vehicleType: "676b31a45d05310ca82657ac",
              vehicleNumber: "12221",
              vehicleLicense: "fake_image.png",
              nId: "12345678912345",
              nIdImg: "fake_image.png",
              email: "mariammohmed5@gmail.com",
              gender: "female",
              phone: "+20101070082",
              photo: "default-profile.png",
              role: "driver",
              id: "68d983e4dd8937e0573fea27",
              createdAt: "2025-09-28T18:52:20.452Z"
          )
      );
      // Helper method to create the request body
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
      //           vehicleLicense: fakeFile,
      //           vehicleType: "676b31a45d05310ca82657ac"
      //       ),
      //       personalInfo: PersonalInfo(
      //           lastName: "mohmed2",
      //           firstName: "mariam1",
      //           phone: "+20101070082",
      //           gender: "female",
      //           email: "mariammohmed55@gmail.com",
      //           nid: "12345678912345",
      //           nidimg: fakeFile
      //       )
      //   ).toFormData();
      // }

      // Create the request object
      ApplyRequest createRequest() {
        return ApplyRequest(
          authenticationInfo: AuthenticationInfo(
            password: "Mariam257@",
            rePassword: "Mariam257@",
          ),
          locationInfo: LocationInfo(country: "Egypt"),
          vehicleInfo: VehicleInfo(
            vehicleNumber: "12228",
            vehicleLicense: fakeFile,
            vehicleType: "676b31a45d05310ca82657ac",
          ),
          personalInfo: PersonalInfo(
            lastName: "mohmed2",
            firstName: "mariam1",
            phone: "+20101070082",
            gender: "female",
            email: "mariammohmed55@gmail.com",
            nid: "12345678912345",
            nidimg: fakeFile,
          ),
        );
      }
      test("return SuccessResult when API call succeeds when sign up", () async {


        when(mockAuthApiServices.apply(any))
            .thenAnswer((_) async => successResponse);

        final request = createRequest();
        final result = await authRemoteDataSourceImpl.apply(request);
        expect(result, isA<SucessResult>());

        verify(mockAuthApiServices.apply(any)).called(1);

     
      });
      test("return FailedResult when API call failed on dio Exception", ()async{
      final dioException=DioException(requestOptions: RequestOptions
        (
        path: ""
      ),type: DioExceptionType.receiveTimeout);
      final request=createRequest();
        when(mockAuthApiServices.apply(any)).thenThrow(dioException);
        final result=await authRemoteDataSourceImpl.apply(request);
        expect(result, isA<FailedResult>());
        expect((result as FailedResult).errorMessage, "receiveTimeout with Api Server");
        verify(mockAuthApiServices.apply(any)).called(1);
      });
    });
  });
}
