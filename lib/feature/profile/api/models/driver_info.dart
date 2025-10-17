import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import '../../domain/entity/driver_info_entity.dart';

part 'driver_info.g.dart';

@JsonSerializable()
class DriverInfo1 {
  @JsonKey(name: JsonSerlizationConstants.id)
  final String? id;
  @JsonKey(name: JsonSerlizationConstants.firstName)
  final String? firstName;
  @JsonKey(name: JsonSerlizationConstants.lastName)
  final String? lastName;
  @JsonKey(name: JsonSerlizationConstants.gender)
  final String? gender;
  @JsonKey(name: JsonSerlizationConstants.photo)
  final String? photo;
  @JsonKey(name: JsonSerlizationConstants.role)
  final String? role;


  DriverInfo1({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.photo,
    this.role,
  });

  factory DriverInfo1.fromJson(Map<String, dynamic> json) =>
      _$DriverInfo1FromJson(json);
  Map<String, dynamic> toJson() => _$DriverInfo1ToJson(this);

  DriverInfoEntity toEntity() {
    return DriverInfoEntity(
      id: id ?? "",
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      gender: gender ?? "",
      photo: photo ?? "",
      role: role ?? "",
    );
  }
}
