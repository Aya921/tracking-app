import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/core/common/models/driver_model.dart';
import 'package:tracking_app/core/common/models/order_model/order_model.dart';
part 'remote_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteDataModel {
  final OrderModel? orderModel;
  final DriverModel? driverModel;
  final String? orderDeliveryStatus;

  RemoteDataModel({
    this.driverModel,
    this.orderModel,
    this.orderDeliveryStatus,
  });

  factory RemoteDataModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDataModelToJson(this);

  RemoteDataEntity toEntity() {
    return RemoteDataEntity(
      driverModel!.toEntity(),
      orderModel!.toEntity(),
      orderDeliveryStatus ?? 'waiting',
    );
  }

  factory RemoteDataModel.fromEntity(RemoteDataEntity entity) {
    return RemoteDataModel(
      driverModel: DriverModel.fromEntity(entity.driverEntity),
      orderModel: OrderModel.fromEntity(entity.orderEntity),
      orderDeliveryStatus: entity.orderDeliveryStatus,
    );
  }
}