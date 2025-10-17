// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:tracking_app/feature/profile/domain/entity/driver_info_entity.dart';

// @immutable
// sealed class ProfileState  extends Equatable{}

// final class GetDriverInfo extends ProfileState {
//   final String?errormsg;
//  final bool? isLoading;
//   final DriverInfoEntity? driverInfo;

//   GetDriverInfo({this.errormsg,
//     this.isLoading = false,
//     this.driverInfo,

//   });

//   GetDriverInfo copywith({
//     String?errormsg,
//     bool? isLoading,
//     DriverInfoEntity? driverInfo,

//   }) {
//     return GetDriverInfo(errormsg: errormsg,
//         isLoading: isLoading,
//         driverInfo: driverInfo,

//     );
//   }

//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();

// }
// final class GetaDriverContactInfo extends ProfileState {
//  final String?errormsg;
//   final bool? isLoading;

//     final DriverContactInfoEntity? driverContactInfo;

//   GetaDriverContactInfo({this.errormsg,
//     this.isLoading = false,
//     this.driverContactInfo,

//   }) ;

//   GetaDriverContactInfo copywith({
//     String?errormsg,
//     bool? isLoading,

//     DriverContactInfoEntity? driverContactInfo,

//   }) {
//     return GetaDriverContactInfo(errormsg: errormsg,
//       isLoading: isLoading,
//      driverContactInfo: driverContactInfo
//       // driverContactInfo: driverContactInfo,
//       //vehicleInfo: vehicleInfo
//     );
//   }

//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();

// }
// final class GetVehicleInfo extends ProfileState {
//    final String?errormsg;
//  final bool? isLoading;
//    final VehicleInfoEntity ? vehicleInfo;

//  GetVehicleInfo({this.errormsg,
//   this.isLoading = false,
//   this.vehicleInfo
// });

// GetVehicleInfo copywith({
//   String?errormsg,
//   bool? isLoading,
//   VehicleInfoEntity? vehicleInfo,
// }) {
//   return GetVehicleInfo(errormsg: errormsg,
//     isLoading: isLoading,
//    vehicleInfo: vehicleInfo
//   );
// }

// @override
// // TODO: implement props
// List<Object?> get props => throw UnimplementedError();

// }

import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';

class ProfileState extends Equatable{
  final DriverEntity? driver;
  final bool isLoading;
  final String? errorMessage;
  final bool? loggedOut;

  const ProfileState({this.driver, this.isLoading = true,
    this.errorMessage,this.loggedOut});

  ProfileState copyWith({
    DriverEntity? driver,
    bool? isLoading,
    String? errorMessage,
    bool? loggedOut
  }) {
    return ProfileState(
      driver: driver,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      loggedOut: loggedOut
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[
    driver,isLoading,errorMessage,loggedOut
  ];
}
