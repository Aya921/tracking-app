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
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/feature/auth/domain/repositry/auth_repositry.dart';
import 'package:tracking_app/feature/auth/domain/use_case/apply_use_case.dart';

import 'login_use_case_test.mocks.dart';
@GenerateMocks([AuthRepositry])
void main() {
  late MockAuthRepositry mockAuthRepositry;
  late ApplyUseCase applyUseCase;
  setUp((){
    mockAuthRepositry=MockAuthRepositry();
    applyUseCase=ApplyUseCase(mockAuthRepositry);
    provideDummy<Result<DriverEntity>>(FailedResult("Dummy Error"));
  });
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
  test('should return successResult when repo success', () async{
    final request=createRequest();
  when(mockAuthRepositry.apply(request)).thenAnswer((_)async=>
      SucessResult(successResponse));
  final result=await applyUseCase.apply(request);
  expect(result, isA<SucessResult>());
  expect((result as SucessResult).sucessResult, successResponse);
  verify(mockAuthRepositry.apply(request)).called(1);
  });
  test("should return FailedResult when repo failed", ()async{
    final request=createRequest();
    when(mockAuthRepositry.apply(request)).thenAnswer((_)async=>
        FailedResult("failed to apply"));
    final result=await applyUseCase.apply(request);
    expect(result, isA<FailedResult>());
    expect((result as FailedResult).errorMessage, "failed to apply");
    verify(mockAuthRepositry.apply(request)).called(1);
  });

}