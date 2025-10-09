import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';

class RemoteDataEntity {
  final OrderEntity orderEntity;
  final UserEntity? userEntity;
  final DriverEntity driverEntity; // came from function get logged driver
  final String? orderDeliveryStatus;

  RemoteDataEntity({required this.driverEntity,this.userEntity,
      required this.orderEntity,
     required this.orderDeliveryStatus});
}
