import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/api/models/remote_driver_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_order_model.dart';
part 'remote_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteDataModel {
  final RemoteOrderModel? orderModel;
  final RemoteDriverModel? driverModel;
  final String? orderDeliveryStatus;


  RemoteDataModel({this.driverModel, this.orderModel,this.orderDeliveryStatus});

  factory RemoteDataModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDataModelToJson(this);

  RemoteDataEntity toEntity() {
    return RemoteDataEntity(
  driverEntity:     driverModel!.toEntity(),
     orderEntity:    orderModel!.toEntity(),
   orderDeliveryStatus:    orderDeliveryStatus ?? 'waiting',
    );
  }

  factory RemoteDataModel.fromEntity(RemoteDataEntity entity) {
    return RemoteDataModel(
      driverModel: RemoteDriverModel.fromEntity(entity.driverEntity),
      orderModel: RemoteOrderModel.fromEntity(entity.orderEntity),
      orderDeliveryStatus:entity.orderDeliveryStatus,
    );
  }
}
