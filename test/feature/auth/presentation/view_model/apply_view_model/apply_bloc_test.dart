import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/apply_request.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/auth_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/location_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/personal_info.dart';
import 'package:tracking_app/feature/auth/api/models/apply/request/vehicle_info.dart';
import 'package:tracking_app/feature/auth/domain/entity/country_entity.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/feature/auth/domain/entity/time_zone.dart';
import 'package:tracking_app/feature/auth/domain/entity/vehicles_entity.dart';
import 'package:tracking_app/feature/auth/domain/use_case/apply_use_case.dart';
import 'package:tracking_app/feature/auth/domain/use_case/get_all_countries_use_case.dart';
import 'package:tracking_app/feature/auth/domain/use_case/get_all_vehicles_use_case.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_bloc.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_event.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_states.dart';

import 'apply_bloc_test.mocks.dart';
@GenerateMocks([ApplyUseCase,GetAllVehiclesUseCase,
  GetAllCountriesUseCase])
void main() {
late ApplyBloc bloc;
late MockGetAllVehiclesUseCase mockGetAllVehiclesUseCase;
late MockGetAllCountriesUseCase mockGetAllCountriesUseCase;
late MockApplyUseCase mockApplyUseCase;
setUp((){
  mockGetAllVehiclesUseCase=MockGetAllVehiclesUseCase();
  mockGetAllCountriesUseCase=MockGetAllCountriesUseCase();

mockApplyUseCase=MockApplyUseCase();
  bloc=ApplyBloc(mockGetAllCountriesUseCase,
      mockGetAllVehiclesUseCase,
      mockApplyUseCase);
  provideDummy<Result<List<VehicleEntity>>>(FailedResult("Dummy Error"));
  provideDummy<Result<List<CountryEntity>>>(FailedResult("Dummy Error"));
  provideDummy<Result<DriverEntity>>(FailedResult("Dummy Error"));

});


group("Get Vehicles", (){
    final  successResponse= [
      VehicleEntity(
        type: "Motor Cycle",
        speed: 90,
        id: "676b63c99f3884b3405c149b",
        image: "https://flower.elevateegy.com/uploads/3be99805-65e0-4f05-9e98-4ccfb0b2ca5f-Chopper.png",
        createdAt: DateTime.parse("2024-12-25T01:45:45.397Z").toString(),
        updatedAt: DateTime.parse("2024-12-25T01:45:45.397Z").toString(),
      )
    ];
    const vehiclesError="failed to load vehicles";
blocTest<ApplyBloc,ApplyStates>
  ("return SuccessResulte when GetAllVehiclesUseCase success ",
    build: (){
    when(mockGetAllVehiclesUseCase.getVehicles()).thenAnswer((_)async=>
        SucessResult(successResponse));
  return bloc;
    },act: (cubit)=>cubit.add(GetAllVehiclesEvent()),
    expect: ()=>[
const ApplyStates(
  vehiclesState: RequestState.loading
),

      ApplyStates(
          vehiclesState: RequestState.success,
        vehicle: successResponse
      ),
    ],verify:  (_)=>verify(mockGetAllVehiclesUseCase.getVehicles()).called(1));
blocTest<ApplyBloc,ApplyStates>("return FailedResult when GetAllVehiclesUseCase failed",
    build: (){
  when(mockGetAllVehiclesUseCase.getVehicles())
      .thenAnswer((_)async=>
      FailedResult(vehiclesError));
  return bloc;
},act: (cubit)=>cubit.add(GetAllVehiclesEvent()),expect: ()=>[
      const ApplyStates(
          vehiclesState: RequestState.loading
      ),
    const  ApplyStates(
          vehiclesState: RequestState.error,
          vehicleErrorMessage: vehiclesError
      ),
    ],verify: (_)=>verify(mockGetAllVehiclesUseCase.getVehicles()).called(1));
});
group("Apply ", (){
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
  final request=createRequest();
  blocTest<ApplyBloc,ApplyStates>("return SuccessResulte when ApplyUseCase success", 
      build: (){
  
when(mockApplyUseCase.apply(request)).thenAnswer
  ((_)async=>SucessResult(successResponse));
    return bloc;
      },act: (cubit)=>cubit.add(GetApplyEvent(request)),expect:()=>[
      const  ApplyStates(
          applyState: RequestState.loading
        ),
       const ApplyStates(
            applyState: RequestState.success,
          driverEntity: successResponse
        )
      ] ,verify: (_)=>verify(mockApplyUseCase.apply(request)).called(1));
  const applyError="failed to apply";
  blocTest<ApplyBloc,ApplyStates>
    ("return FailedResult when ApplyUseCase success",
      build: (){

        when(mockApplyUseCase.apply(request)).thenAnswer
          ((_)async=>FailedResult(applyError));
        return bloc;
      },act: (cubit)=>cubit.add(GetApplyEvent(request)),expect:()=>[
        const  ApplyStates(
            applyState: RequestState.loading
        ),
        const ApplyStates(
            applyState: RequestState.error,
            applyErrorMessage: applyError
        )
      ] ,verify: (_)=>verify(mockApplyUseCase.apply(request)).called(1));
});
group("Get All Countries", (){
  final  successResponse=[
    const CountryEntity(isoCode: "AF", name: "Afghanistan",
        phoneCode: "93", flag: "🇦🇫", currency: "AFN",
        latitude: "33.00000000", longitude: "65.00000000",
        timezones: [
          Timezone(zoneName: "Asia/Kabul",
              gmtOffset: 16200,
              gmtOffsetName: "UTC+04:30",
              abbreviation: "AFT",
              tzName: "Afghanistan Time")
        ])
  ];
  blocTest<ApplyBloc,ApplyStates>
    ("return SuccessResulte when GetAllCountriesUseCase success",
      build: (){

        when(mockGetAllCountriesUseCase.getCountries())
            .thenAnswer
          ((_)async=>SucessResult(successResponse));
        return bloc;
      },
      act: (cubit)=>cubit.add(GetAllCountriesEvent())
      ,expect:()=>[
        const  ApplyStates(
            countriesState: RequestState.loading
        ),
         ApplyStates(
            countriesState: RequestState.success,
            countries: successResponse
        )
      ] ,verify: (_)=>verify(mockGetAllCountriesUseCase.getCountries())
          .called(1));
  const countryError="failed to load countries";
  blocTest<ApplyBloc,ApplyStates>
    ("return FailedResult when GetAllCountriesUseCase failed",
      build: (){

        when(mockGetAllCountriesUseCase.getCountries()).thenAnswer
          ((_)async=>FailedResult(countryError));
        return bloc;
      },act: (cubit)=>cubit.add(GetAllCountriesEvent()),expect:()=>[
        const  ApplyStates(
            countriesState: RequestState.loading
        ),
        const ApplyStates(
            countriesState: RequestState.error,
            countryErrorMessage: countryError
        )
      ] ,verify: (_)=>verify(mockGetAllCountriesUseCase.getCountries())
          .called(1));
});
}