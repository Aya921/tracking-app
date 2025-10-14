import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/auth/domain/entity/country_entity.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/feature/auth/domain/entity/vehicles_entity.dart';
import 'package:tracking_app/feature/auth/domain/use_case/apply_use_case.dart';
import 'package:tracking_app/feature/auth/domain/use_case/get_all_countries_use_case.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_event.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/apply_view_model/apply_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_case/get_all_vehicles_use_case.dart';
@injectable
class ApplyBloc extends Bloc<ApplyEvent,ApplyStates>{
  final GetAllCountriesUseCase _getAllCountriesUseCase;
  final GetAllVehiclesUseCase _allVehiclesUseCase;
  final ApplyUseCase _applyUseCase;
  ApplyBloc(
      this._getAllCountriesUseCase,this._allVehiclesUseCase,this._applyUseCase
      ):super(const ApplyStates()){
    on<GetAllCountriesEvent>((event,emit) async {
      emit(state.copyWith(
        countriesState: RequestState.loading,
      ));
      final result=await _getAllCountriesUseCase.getCountries();
      switch(result){

        case SucessResult<List<CountryEntity>>():
       emit(state.copyWith(
         countriesState: RequestState.success,
         countries: result.sucessResult
       ));
        case FailedResult<List<CountryEntity>>():
          emit(state.copyWith(
              countriesState: RequestState.error,
              countryErrorMessage: result.errorMessage
          ));
      }

    });
    on<GetAllVehiclesEvent>((event,emit)async{
      emit(state.copyWith(
          vehiclesState: RequestState.loading,
      ));

      final result=await _allVehiclesUseCase.getVehicles();
      switch(result){
        case SucessResult<List<VehicleEntity>>():

          emit(state.copyWith(
              vehiclesState: RequestState.success,
              vehicle: result.sucessResult
          ));

        case FailedResult<List<VehicleEntity>>():
          emit(state.copyWith(
              vehiclesState: RequestState.error,
              vehicleErrorMessage: result.errorMessage
          ));
      }
    });
    on<GetApplyEvent>((event,emit)async{
      emit(state.copyWith(
        applyState: RequestState.loading,
      ));
      final result=await _applyUseCase.
      apply(event.request);
    switch(result){

      case SucessResult<DriverEntity>():
     emit(state.copyWith(
       driverEntity: result.sucessResult,
       applyState: RequestState.success
     ));
      case FailedResult<DriverEntity>():
        emit(state.copyWith(
            applyErrorMessage: result.errorMessage,
            applyState: RequestState.error
        ));
    }
    });
  }


}