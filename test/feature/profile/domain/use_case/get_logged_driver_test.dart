import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/feature/profile/domain/repository/profile_repository.dart';
import 'package:tracking_app/feature/profile/domain/use_case/get_logged_driver.dart';

import 'change_profile_use_case_test.mocks.dart';
@GenerateMocks([ProfileRepository])
void main() {
 late MockProfileRepository mockProfileRepository;
 late GetLoggedDriverUseCase getLoggedDriverUseCase;
 setUp((){
   mockProfileRepository=MockProfileRepository();
   getLoggedDriverUseCase=GetLoggedDriverUseCase(mockProfileRepository);
   provideDummy<Result<DriverEntity>>(
       FailedResult<DriverEntity>("DriverEntity Error")
   );
 });
 const successResponse=DriverEntity(
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
   identity: IdentityInfo(
       nid: "12345678912345", nidImg: "fake_image.png"),
   meta: MetaInfo(
       role: "driver", createdAt: "2025-09-28T18:52:20.452Z"),
 );
test("should  return SuccessResult when repo success", ()async{
  when(mockProfileRepository.getLoggedDriver()).thenAnswer((_)async=>
      SucessResult(successResponse));
  final result=await getLoggedDriverUseCase.getLoggedDriver();
  expect(result, isA<SucessResult>());
  expect((result as SucessResult).sucessResult, successResponse);
  verify(mockProfileRepository.getLoggedDriver()).called(1);
});
test("should  return Failed Result when repo  failed", ()async{
const error="some thing went Wrong";
when(mockProfileRepository.getLoggedDriver()).thenAnswer((_)async=>
      FailedResult(error));
final result=await getLoggedDriverUseCase.getLoggedDriver();
expect(result, isA<FailedResult>());
expect((result as FailedResult).errorMessage, error);
verify(mockProfileRepository.getLoggedDriver()).called(1);
});
}