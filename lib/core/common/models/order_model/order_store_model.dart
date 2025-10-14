import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
part 'order_store_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderStoreModel {
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

  OrderStoreModel({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory OrderStoreModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStoreModelToJson(this);

  static StoreEntity toEntity(OrderStoreModel? model) {
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

  factory OrderStoreModel.fromEntity(StoreEntity entity) {
    return OrderStoreModel(
      name: entity.name,
      image: entity.image,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      latLong: entity.latLong,
    );
  }
}
