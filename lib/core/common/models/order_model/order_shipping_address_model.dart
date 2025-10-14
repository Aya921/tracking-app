import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';

part 'order_shipping_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderShippingAddressModel {
  @JsonKey(name: JsonSerlizationConstants.street)
  String? street;

  @JsonKey(name: JsonSerlizationConstants.city)
  String? city;

  @JsonKey(name: JsonSerlizationConstants.phone)
  String? phone;

  @JsonKey(name: JsonSerlizationConstants.lat)
  String? lat;

  @JsonKey(name: JsonSerlizationConstants.long)
  String? long;

  OrderShippingAddressModel({
    this.street,
    this.city,
    this.phone,
    this.lat,
    this.long,
  });

  factory OrderShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$OrderShippingAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderShippingAddressModelToJson(this);

  static ShippingAddressEntity toEntity(OrderShippingAddressModel? model) {
    if (model == null) {
      return ShippingAddressEntity(
        street: "Zagazig",
        city: "Sharkia",
        phone: "01010518802",
        lat: "31.7195459",
        long: "31.7195459",
      );
    }

    return ShippingAddressEntity(
      street: model.street ?? "",
      city: model.city ?? "",
      phone: model.phone ?? "",
      lat: model.lat ?? "",
      long: model.long ?? "",
    );
  }

  factory OrderShippingAddressModel.fromEntity(ShippingAddressEntity entity) {
    return OrderShippingAddressModel(
      street: entity.street,
      city: entity.city,
      phone: entity.phone,
      lat: entity.lat,
      long: entity.long,
    );
  }
}
