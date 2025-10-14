import 'package:isar/isar.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
part 'store_local_model.g.dart';
@embedded
class StoreLocalModel {
  late String name;
  late String image;
  late String address;
  late String phoneNumber;
  late String latLong;

  StoreLocalModel();

  
  static StoreLocalModel fromEntity(StoreEntity entity) {
    final model = StoreLocalModel();
    model.name = entity.name;
    model.image = entity.image;
    model.address = entity.address;
    model.phoneNumber = entity.phoneNumber;
    model.latLong = entity.latLong;
    return model;
  }

  StoreEntity toEntity() {
    return StoreEntity(
      name: name,
      image: image,
      address: address,
      phoneNumber: phoneNumber,
      latLong: latLong,
    );
  }
}



