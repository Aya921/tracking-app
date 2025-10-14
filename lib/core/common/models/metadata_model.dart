import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
part 'metadata_model.g.dart';
@JsonSerializable()
class MetadataModel {
    @JsonKey(name: JsonSerlizationConstants.currentPage)
    int? currentPage;
    @JsonKey(name: JsonSerlizationConstants.totalPages)
    int? totalPages;
    @JsonKey(name: JsonSerlizationConstants.totalItems)
    int? totalItems;
    @JsonKey(name: JsonSerlizationConstants.limit)
    int? limit;

    MetadataModel({
        this.currentPage,
        this.totalPages,
        this.totalItems,
        this.limit,
    });

    factory MetadataModel.fromJson(Map<String, dynamic> json) =>
        _$MetadataModelFromJson(json);

    Map<String, dynamic> toJson() => _$MetadataModelToJson(this);
}

