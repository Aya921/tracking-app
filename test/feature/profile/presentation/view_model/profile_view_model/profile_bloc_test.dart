import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/feature/profile/domain/use_case/get_logged_driver.dart';
import 'package:tracking_app/feature/profile/domain/use_case/logout_driver.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_bloc.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/profile_view_model/profile_state.dart';

import 'profile_bloc_test.mocks.dart';
@GenerateMocks([
  GetLoggedDriverUseCase,LogoutDriverUseCase
])
void main() {

  late MockGetLoggedDriverUseCase mockGetLoggedDriverUseCase;
  late MockLogoutDriverUseCase mockLogoutDriverUseCase;
  late ProfileBloc bloc;
  setUp((){
    WidgetsFlutterBinding.ensureInitialized();
mockLogoutDriverUseCase=MockLogoutDriverUseCase();
mockGetLoggedDriverUseCase=MockGetLoggedDriverUseCase();
bloc=ProfileBloc(mockGetLoggedDriverUseCase, mockLogoutDriverUseCase);
provideDummy<Result<DriverEntity>>(
    FailedResult<DriverEntity>("DriverEntity Error")
);
provideDummy<Result<void>>(
    FailedResult<void>("log out Error")
);
  });
group("Get Log Out Driver", (){
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
  blocTest<ProfileBloc,ProfileState>
    ("emit [loading,success] when GetLoggedDriverUseCase use case success", build:
      (){
    when(mockGetLoggedDriverUseCase.getLoggedDriver()).thenAnswer((_)async=>
        SucessResult(successResponse));
    return bloc;
  },act: (cubit)=>cubit.add(GetLoggedDriverEvent()),
      expect: ()=>[
    const ProfileState(
      isLoading: true
    ),
    const ProfileState(
      driver: successResponse,
isLoading: false,
      errorMessage: null,
    )
  ],verify: (_)=>verify(
      mockGetLoggedDriverUseCase.getLoggedDriver()).called(1));
  const errorMessage="some thing went wrong";
  blocTest<ProfileBloc,ProfileState>("emit [loading,failure] when GetLoggedDriverUseCase  use case failed",
      build: (){

        when(mockGetLoggedDriverUseCase.getLoggedDriver()).thenAnswer((_)async=>
            FailedResult(errorMessage));
        return bloc;
      },act: (cubit)=>cubit.add(GetLoggedDriverEvent()),expect: ()=>[
        const ProfileState(
            isLoading: true
        ),
        const ProfileState(

          isLoading: false,
          errorMessage: errorMessage,
        )
      ],verify: (_)=>verify(mockGetLoggedDriverUseCase.getLoggedDriver()).called(1));
});
// group("Log out Driver", (){
//   blocTest("emit [loading,success] when LogoutDriverUseCase use case success", build: (){
//    when(mockLogoutDriverUseCase.logoutDriver()).
//    thenAnswer((_)async
//    =>SucessResult(null));
//     return bloc;
//   },act:(cubit)=>cubit.add(LogoutDriverEvent()),expect: ()=>[
//     const ProfileState(
//   isLoading: false
//     ),
//     const ProfileState(
//       isLoading: true,
//         loggedOut: true,errorMessage: null
//     )
//   ] ,verify: (_)=>verify(mockLogoutDriverUseCase.logoutDriver()).called(1));
// });


}