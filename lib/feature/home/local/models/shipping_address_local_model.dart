import 'package:isar/isar.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';

part 'shipping_address_local_model.g.dart';

@embedded
class ShippingAddressLocalModel {
  late String street;
  late String city;
  late String phone;
  late String lat;
  late String long;
  

  ShippingAddressLocalModel();

  static ShippingAddressLocalModel fromEntity(ShippingAddressEntity entity) {
    final model = ShippingAddressLocalModel();
    model.street = entity.street;
    model.city = entity.city;
    model.phone = entity.phone;
    model.lat = entity.lat;
    model.long = entity.long;
    return model;
  }

  
  ShippingAddressEntity toEntity() {
    return ShippingAddressEntity(
      street: street,
      city: city,
      phone: phone,
      lat: lat,
      long: long,
    );
  }
}



