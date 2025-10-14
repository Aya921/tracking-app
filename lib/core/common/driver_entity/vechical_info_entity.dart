import 'package:equatable/equatable.dart';

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