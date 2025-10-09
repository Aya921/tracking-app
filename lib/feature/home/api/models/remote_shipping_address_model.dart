import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';

part 'remote_shipping_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteShippingAddressModel {
@JsonKey(name: JsonSerlizationConstants.street)
String? street;

@JsonKey(name: JsonSerlizationConstants.city)
String? city;

@JsonKey(name: JsonSerlizationConstants.phone)
String? phone;

@JsonKey(

    name: JsonSerlizationConstants.lat)
String? lat;

@JsonKey(name: JsonSerlizationConstants.long)
String? long;


  RemoteShippingAddressModel({
    this.street,
    this.city,
    this.phone,
    this.lat,
    this.long,
  });

  factory RemoteShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteShippingAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteShippingAddressModelToJson(this);


  static ShippingAddressEntity toEntity(
    RemoteShippingAddressModel? model,
  ) {
    if (model == null) {
      return ShippingAddressEntity(
        street: "Zagazig",
        city: "Sharkia",
        phone: "01010518802",
        lat: "30.3232786",
        long: "31.8707058",
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


  factory RemoteShippingAddressModel.fromEntity(ShippingAddressEntity entity) {
    return RemoteShippingAddressModel(
      street: entity.street,
      city: entity.city,
      phone: entity.phone,
      lat: entity.lat,
      long: entity.long,
    );
  }
}
