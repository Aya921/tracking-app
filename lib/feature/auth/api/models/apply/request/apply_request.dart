import 'package:json_annotation/json_annotation.dart';
import 'personal_info.dart';
import 'location_info.dart';
import 'vehicle_info.dart';
import 'auth_info.dart';

part 'apply_request.g.dart';

@JsonSerializable()
class ApplyRequest {
  final PersonalInfo? personalInfo;

  final LocationInfo? locationInfo;

  final VehicleInfoModel? vehicleInfo;

  final AuthenticationInfo? authenticationInfo;

  ApplyRequest({
    this.personalInfo,
    this.locationInfo,
    this.vehicleInfo,
    this.authenticationInfo,
  });

  factory ApplyRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyRequestToJson(this);
}
