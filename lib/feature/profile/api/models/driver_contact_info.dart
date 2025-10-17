import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import '../../domain/entity/driver_contact_info_entity.dart';

part 'driver_contact_info.g.dart';

@JsonSerializable()
class DriverContactInfo1 {
  @JsonKey(name: JsonSerlizationConstants.email)
  final String? email;
  @JsonKey(name: JsonSerlizationConstants.phone)
  final String? phone;

  DriverContactInfo1({this.email, this.phone});

  factory DriverContactInfo1.fromJson(Map<String, dynamic> json)
  => _$DriverContactInfo1FromJson(json);
  Map<String, dynamic> toJson() => _$DriverContactInfo1ToJson(this);

  DriverContactInfoEntity toEntity() {
    return DriverContactInfoEntity(
      email: email ?? "",
      phone: phone ?? "",
    );
  }
}
