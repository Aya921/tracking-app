import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import '../../../../../../../core/common/driver_entity/driver_entity.dart';

part 'apply_response.g.dart';

@JsonSerializable()
class ApplyResponse {
  @JsonKey(name: JsonSerlizationConstants.message)
  final String? message;
  @JsonKey(name: JsonSerlizationConstants.driver)
  final Driver? driver;
  @JsonKey(name: JsonSerlizationConstants.token)
  final String? token;

  ApplyResponse({this.message, this.driver, this.token});

  factory ApplyResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyResponseToJson(this);
}

@JsonSerializable()
class Driver {
  @JsonKey(name: JsonSerlizationConstants.country)
  final String? country;
  @JsonKey(name: JsonSerlizationConstants.firstName)
  final String? firstName;
  @JsonKey(name: JsonSerlizationConstants.lastName)
  final String? lastName;
  @JsonKey(name: JsonSerlizationConstants.vehicleType)
  final String? vehicleType;
  @JsonKey(name: JsonSerlizationConstants.vehicleNumber)
  final String? vehicleNumber;
  @JsonKey(name: JsonSerlizationConstants.vehicleLicense)
  final String? vehicleLicense;
  @JsonKey(name: JsonSerlizationConstants.nid)
  final String? nId;
  @JsonKey(name: JsonSerlizationConstants.nidImg)
  final String? nIdImg;
  @JsonKey(name: JsonSerlizationConstants.email)
  final String? email;
  @JsonKey(name: JsonSerlizationConstants.gender)
  final String? gender;
  @JsonKey(name: JsonSerlizationConstants.phone)
  final String? phone;
  @JsonKey(name: JsonSerlizationConstants.photo)
  final String? photo;
  @JsonKey(name: JsonSerlizationConstants.role)
  final String? role;
  @JsonKey(name: JsonSerlizationConstants.id)
  final String? id;
  @JsonKey(name: JsonSerlizationConstants.createdAt)
  final String? createdAt;

  Driver({
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nId,
    this.nIdImg,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.id,
    this.createdAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) =>
      _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);

 DriverEntity toEntity() {
  return DriverEntity(
    id: id ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    contactInfo: ContactInfo(
      country: country ?? '',
      gender: gender ?? '',
      email: email ?? '',
      phone: phone ?? '',
      photo: photo ?? '',
    ),
    vehicle: VehicleInfo(
      type: vehicleType ?? '',
      number: vehicleNumber ?? '',
      license: vehicleLicense ?? '',
    ),
    identity: IdentityInfo(
      nid: nId ?? '',
      nidImg: nIdImg ?? '',
    ),
    meta: MetaInfo(
      role: role ?? '',
      createdAt: createdAt ?? '',
    ),
  );
}

}
