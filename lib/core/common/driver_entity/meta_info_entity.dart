import 'package:equatable/equatable.dart';

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
