import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:tracking_app/feature/profile/domain/entity/driver_contact_info_entity.dart';
import 'package:tracking_app/feature/profile/domain/entity/driver_info_entity.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';
import 'package:tracking_app/feature/profile/domain/entity/vehicle_info_entity.dart';
import 'package:tracking_app/feature/profile/domain/use_case/edit_profile_use_case.dart';

import 'upload_driver_photo_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepositoryImpl])
void main() {
  late EditProfileUseCase editProfileUseCase;
  late MockProfileRepositoryImpl mockProfileRepositoryImpl;

  setUpAll(() {
    provideDummy<Result<EditProfileEntity>>(FailedResult("Dummy Error"));
    mockProfileRepositoryImpl =MockProfileRepositoryImpl();
    editProfileUseCase = EditProfileUseCase(mockProfileRepositoryImpl);
  },);

  const fakeEntity = EditProfileEntity(
    info: DriverInfoEntity(firstName: "Rana", lastName: "Gebril"),
    contact: DriverContactInfoEntity(
      email: "Test1@gmail.com",
      phone: "01234567891",
    ),
    vehicle: VehicleInfoEntity(vehicleNumber: "4511", vehicleType: "car"),
  );

  final fakeRequest = EditProfileRequest(
    email: "Test1@gmail.com",
    firstName: "Rana",
    lastName: "Gebril",
    phone: "01234567891",
  );

  test("should return SuccessResult when ProfileRepository returns success", () async {
    //Arrange
    when(
      mockProfileRepositoryImpl.editProfile(fakeRequest),
    ).thenAnswer((_) async => SucessResult<EditProfileEntity>(fakeEntity));

    //Act
    final result = await editProfileUseCase.call(fakeRequest);

    //Assert
    expect(result, isA<SucessResult<EditProfileEntity>>());
    final success = (result as SucessResult<EditProfileEntity>).sucessResult;
    expect(success.info?.firstName, "Rana");
    expect(success.contact?.phone, "01234567891");
    expect(success.vehicle?.vehicleType, "car");
    verify(mockProfileRepositoryImpl.editProfile(fakeRequest)).called(1);
  });

  test("should return FailedResult when ProfileRepository returns failure", () async{
    //Arrange
    when(
      mockProfileRepositoryImpl.editProfile(fakeRequest),
    ).thenAnswer((_) async => FailedResult<EditProfileEntity>("Failed edit profile"));

    //Act
    final result = await editProfileUseCase.call(fakeRequest);

    //Assert
    expect(result, isA<FailedResult<EditProfileEntity>>());
    final failure = result as FailedResult<EditProfileEntity>;
    expect(failure.errorMessage, "Failed edit profile");
    verify(mockProfileRepositoryImpl.editProfile(any)).called(1);


  },);
}