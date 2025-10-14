import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
part 'store_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreModel {
  @JsonKey(name: JsonSerlizationConstants.name)
  String? name;

  @JsonKey(name: JsonSerlizationConstants.image)
  String? image;

  @JsonKey(name: JsonSerlizationConstants.address)
  String? address;

  @JsonKey(name: JsonSerlizationConstants.phoneNumber)
  String? phoneNumber;

  @JsonKey(name: JsonSerlizationConstants.latLong)
  String? latLong;

  StoreModel({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);

  static StoreEntity toEntity(StoreModel? model) {
    if (model == null) {
      return StoreEntity(
        name: 'Fake Store',
        image: 'https://example.com/default-store.png',
        address: '123 Fake Street, Cairo, Egypt',
        phoneNumber: '0100000000',
        latLong: '30.0444,31.2357',
      );
    }

    return StoreEntity(
      name: model.name ?? 'Fake Store',
      image: model.image ?? 'https://example.com/default-store.png',
      address: model.address ?? '123 Fake Street, Cairo, Egypt',
      phoneNumber: model.phoneNumber ?? '0100000000',
      latLong: model.latLong ?? '30.0444,31.2357',
    );
  }

  factory StoreModel.fromEntity(StoreEntity entity) {
    return StoreModel(
      name: entity.name,
      image: entity.image,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      latLong: entity.latLong,
    );
  }
}
