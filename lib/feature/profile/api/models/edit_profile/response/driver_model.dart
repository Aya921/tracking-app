import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/feature/profile/api/models/driver_contact_info.dart';
import 'package:tracking_app/feature/profile/api/models/driver_info.dart';
import 'package:tracking_app/feature/profile/api/models/location_info.dart';
import 'package:tracking_app/feature/profile/api/models/nid_info.dart';
import 'package:tracking_app/feature/profile/api/models/vehicle_info.dart';
import 'package:tracking_app/feature/profile/domain/entity/driver_all_info_entity.dart';
part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel1 {
  final DriverInfo1? info;
  final DriverContactInfo1? contact;
  final VehicleInfo1? vehicle;
  final LocationInfo1? location;
  final NationalIdInfo1? nid;

  DriverModel1({
    this.info,
    this.contact,
    this.vehicle,
    this.location,
    this.nid,
  });

  factory DriverModel1.fromJson(Map<String, dynamic> json) {
    return DriverModel1(
      info: DriverInfo1.fromJson(json),
      contact: DriverContactInfo1.fromJson(json),
      vehicle: VehicleInfo1.fromJson(json),
      location: LocationInfo1.fromJson(json),
      nid: NationalIdInfo1.fromJson(json),
    );
  }

  DriverAllInfoEntity toEntity() {
    return DriverAllInfoEntity(
      info: info?.toEntity(),
      contact: contact?.toEntity(),
      vehicle: vehicle?.toEntity(),
      location: location?.toEntity(),
      nid: nid?.toEntity(),
    );
  }
}
