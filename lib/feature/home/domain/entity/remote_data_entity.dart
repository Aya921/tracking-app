import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';

class RemoteDataEntity {
  final OrderEntity orderEntity;
  final DriverEntity driverEntity; // came from function get logged driver
  final String? orderDeliveryStatus;

  RemoteDataEntity(this.driverEntity, this.orderEntity, this.orderDeliveryStatus);
}
