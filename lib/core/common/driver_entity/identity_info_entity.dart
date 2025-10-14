import 'package:equatable/equatable.dart';

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
