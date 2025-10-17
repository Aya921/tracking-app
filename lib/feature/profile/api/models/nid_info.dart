import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import '../../domain/entity/national_id_info_entity.dart';

part 'nid_info.g.dart';

@JsonSerializable()
class NationalIdInfo1 {
  @JsonKey(name: JsonSerlizationConstants.nid)
  final String? nId;
  @JsonKey(name: JsonSerlizationConstants.nidImg)
  final String? nIdImg;

  NationalIdInfo1({this.nId, this.nIdImg});

  factory NationalIdInfo1.fromJson(Map<String, dynamic>
  json) => _$NationalIdInfo1FromJson(json);
  Map<String, dynamic> toJson() => _$NationalIdInfo1ToJson(this);

  NationalIdInfoEntity toEntity() {
    return NationalIdInfoEntity(
      nid: nId ?? "",
      nidImg: nIdImg ?? "",
    );
  }
}
