import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';

part 'vehicle_info.g.dart';

@JsonSerializable()
class VehicleInfoModel {
  @JsonKey(name: JsonSerlizationConstants.vehicleType)
  final String? vehicleType;
  @JsonKey(name: JsonSerlizationConstants.vehicleNumber)
  final String? vehicleNumber;
  @JsonKey(
    name: JsonSerlizationConstants.vehicleLicense,
    includeToJson: false,
    includeFromJson: false,
  )
  final File? vehicleLicense;

  VehicleInfoModel({this.vehicleType, this.vehicleNumber, this.vehicleLicense});

  factory VehicleInfoModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleInfoModelToJson(this);
}
