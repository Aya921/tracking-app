import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import '../../domain/entity/vehicle_info_entity.dart';

part 'vehicle_info.g.dart';

@JsonSerializable()
class VehicleInfo1 {
  @JsonKey(name: JsonSerlizationConstants.vehicleType)
  final String? vehicleType;
  @JsonKey(name: JsonSerlizationConstants.vehicleNumber)
  final String? vehicleNumber;
  @JsonKey(name: JsonSerlizationConstants.vehicleLicense)
  final String? vehicleLicense;

  VehicleInfo1({this.vehicleType, this.vehicleNumber, this.vehicleLicense});

  factory VehicleInfo1.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfo1FromJson(json);
  Map<String, dynamic> toJson() => _$VehicleInfo1ToJson(this);

  VehicleInfoEntity toEntity() {
    return VehicleInfoEntity(
      vehicleType: vehicleType ?? "",
      vehicleNumber: vehicleNumber ?? "",
      vehicleLicense: vehicleLicense ?? "",
    );
  }
}
