import 'package:isar/isar.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
part 'user_local_model.g.dart';
@embedded
class UserLocalModel {
  late String id;
  late String firstName;
  late String lastName;
  late String email;
  late String gender;
  late String phone;
  late String photo;

  UserLocalModel(); 

  
  static UserLocalModel fromEntity(UserEntity entity) {
    final model = UserLocalModel();
    model.id = entity.id;
    model.firstName = entity.firstName;
    model.lastName = entity.lastName;
    model.email = entity.email;
    model.gender = entity.gender;
    model.phone = entity.phone;
    model.photo = entity.photo;
    return model;
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: gender,
      phone: phone,
      photo: photo,
    );
  }
}



