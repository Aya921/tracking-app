import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  @JsonKey(name: JsonSerlizationConstants.id)
  String? id;

  @JsonKey(name: JsonSerlizationConstants.firstName)
  String? firstName;

  @JsonKey(name: JsonSerlizationConstants.lastName)
  String? lastName;

  @JsonKey(name: JsonSerlizationConstants.email)
  String? email;

  @JsonKey(name: JsonSerlizationConstants.gender)
  String? gender;

  @JsonKey(name: JsonSerlizationConstants.phone)
  String? phone;

  @JsonKey(name: JsonSerlizationConstants.photo)
  String? photo;

  @JsonKey(name: JsonSerlizationConstants.passwordChangedAt)
  String? passwordChangedAt;

  @JsonKey(name: JsonSerlizationConstants.passwordResetCode)
  String? passwordResetCode;

  @JsonKey(name: JsonSerlizationConstants.passwordResetExpires)
  String? passwordResetExpires;

  @JsonKey(name: JsonSerlizationConstants.resetCodeVerified)
  bool? resetCodeVerified;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.passwordChangedAt,
    this.passwordResetCode,
    this.passwordResetExpires,
    this.resetCodeVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static UserEntity toEntity(UserModel? model) {
    if (model == null) {
      return UserEntity(
        id: 'fake-user-id',
        firstName: 'Fake',
        lastName: 'User',
        email: 'fake@email.com',
        gender: 'unknown',
        phone: '0000000000',
        photo: 'https://flower.elevateegy.com/uploads/default-profile.png',
      );
    }

    return UserEntity(
      id: model.id ?? 'fake-user-id',
      firstName: model.firstName ?? 'Fake',
      lastName: model.lastName ?? 'User',
      email: model.email ?? 'fake@email.com',
      gender: model.gender ?? 'unknown',
      phone: model.phone ?? '0000000000',
      photo: model.photo ?? 'https://example.com/default-profile.png',
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      gender: entity.gender,
      phone: entity.phone,
      photo: entity.photo,
    );
  }
}
