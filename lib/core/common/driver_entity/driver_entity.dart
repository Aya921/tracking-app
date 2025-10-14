import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';


class DriverEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final ContactInfo contactInfo;
  final VehicleInfo vehicle;
  final IdentityInfo identity;
  final MetaInfo meta;

  const DriverEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.contactInfo,
    required this.vehicle,
    required this.identity,
    required this.meta,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        contactInfo,
        vehicle,
        identity,
        meta,
      ];
}


class ContactInfo extends Equatable {
  final String country;
  final String gender;
  final String email;
  final String phone;
  final String photo;

  const ContactInfo({
    required this.country,
    required this.gender,
    required this.email,
    required this.phone,
    required this.photo,
  });

  @override
  List<Object?> get props => [country, gender, email, phone, photo];
}








