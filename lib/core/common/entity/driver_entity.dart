import 'package:equatable/equatable.dart';

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

/// 🧾 معلومات التواصل والشخصية
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

/// 🚗 بيانات المركبة
class VehicleInfo extends Equatable {
  final String type;
  final String number;
  final String license;

  const VehicleInfo({
    required this.type,
    required this.number,
    required this.license,
  });

  @override
  List<Object?> get props => [type, number, license];
}

/// 🪪 بيانات الهوية
class IdentityInfo extends Equatable {
  final String nid;
  final String nidImg;

  const IdentityInfo({
    required this.nid,
    required this.nidImg,
  });

  @override
  List<Object?> get props => [nid, nidImg];
}

/// 📅 بيانات إضافية (زي الدور والتاريخ)
class MetaInfo extends Equatable {
  final String role;
  final String createdAt;

  const MetaInfo({
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [role, createdAt];
}
