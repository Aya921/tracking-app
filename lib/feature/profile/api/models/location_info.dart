import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import '../../domain/entity/location_info_entity.dart';

part 'location_info.g.dart';

@JsonSerializable()
class LocationInfo1 {
  @JsonKey(name: JsonSerlizationConstants.country)
  final String? country;
  @JsonKey(name: JsonSerlizationConstants.createdAt)
  final String? createdAt;
  LocationInfo1({this.country, this.createdAt});

  factory LocationInfo1.fromJson(Map<String, dynamic> json) =>
      _$LocationInfo1FromJson(json);
  Map<String, dynamic> toJson() => _$LocationInfo1ToJson(this);

  LocationInfoEntity toEntity() {
    return LocationInfoEntity(
      country: country ?? "",
      createdAt: createdAt ?? "",
    );
  }
}
