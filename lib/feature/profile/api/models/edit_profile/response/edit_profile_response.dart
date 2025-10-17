import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/response/driver_model.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';

part 'edit_profile_response.g.dart';
@JsonSerializable()
class EditProfileResponse {
  @JsonKey(name: JsonSerlizationConstants.message)
  final String? message;
  @JsonKey(name: JsonSerlizationConstants.driver)
  final DriverModel1? driver;

  EditProfileResponse({
    this.message,
    this.driver,
  });

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$EditProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileResponseToJson(this);

  EditProfileEntity toEntity() {
    return EditProfileEntity(
      info: driver?.info?.toEntity(),
      contact: driver?.contact?.toEntity(),
      vehicle: driver?.vehicle?.toEntity(),
      location: driver?.location?.toEntity(),
      nid: driver?.nid?.toEntity(),
    );
  }
}
