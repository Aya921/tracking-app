import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';

part 'remote_driver_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteDriverModel {
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

  RemoteDriverModel({
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

  factory RemoteDriverModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteDriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDriverModelToJson(this);

  
  DriverEntity toEntity() {
    return DriverEntity(
      id: id ?? "",
      country: country ?? "",
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      vehicleType: vehicleType ?? "",
      vehicleNumber: vehicleNumber ?? "",
      vehicleLicense: vehicleLicense ?? "",
      nid: nId ?? "",
      nidImg: nIdImg ?? "",
      email: email ?? "",
      gender: gender ?? "",
      phone: phone ?? "",
      photo: photo ?? "",
      role: role ?? "",
      createdAt: createdAt ?? "",
    );
  }


  factory RemoteDriverModel.fromEntity(DriverEntity entity) {
    return RemoteDriverModel(
      id: entity.id,
      country: entity.country,
      firstName: entity.firstName,
      lastName: entity.lastName,
      vehicleType: entity.vehicleType,
      vehicleNumber: entity.vehicleNumber,
      vehicleLicense: entity.vehicleLicense,
      nId: entity.nid,
      nIdImg: entity.nidImg,
      email: entity.email,
      gender: entity.gender,
      phone: entity.phone,
      photo: entity.photo,
      role: entity.role,
      createdAt: entity.createdAt,
    );
  }
}
