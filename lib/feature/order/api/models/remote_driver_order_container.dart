import 'package:json_annotation/json_annotation.dart';
import '../../../home/api/models/remote_shipping_address_model.dart';
import '../../../home/api/models/remote_user_model.dart';
import '../../../home/domain/entity/payment_info_entity.dart';
import '../../domain/entity/order_info_entity.dart';
import 'remote_order_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_store_model.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';

part 'remote_driver_order_container.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteDriverOrderContainer {
  @JsonKey(name: "_id")
  String? driverOrderId;

  @JsonKey(name: "driver")
  String? driverId;

  @JsonKey(name: "order")
  RemoteOrderModel? orderDetails;

  @JsonKey(name: "store")
  RemoteStoreModel? store;

  @JsonKey(name: "createdAt")
  String? createdAt;

  @JsonKey(name: "updatedAt")
  String? updatedAt;

  RemoteDriverOrderContainer({
    this.driverOrderId,
    this.driverId,
    this.orderDetails,
    this.store,
    this.createdAt,
    this.updatedAt,
  });

  factory RemoteDriverOrderContainer.fromJson(Map<String, dynamic> json) =>
      _$RemoteDriverOrderContainerFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDriverOrderContainerToJson(this);

  OrderEntity toEntity() {
    final OrderEntity baseOrderEntity = orderDetails?.toEntity() ?? OrderEntity(
      id: '',
      user: RemoteUserModel.toEntity(null),
      orderItems: [],
      orderInfoEntity: OrderInfoEntity(false, '', '', '', '', -1, 0),
      shippingAddress: RemoteShippingAddressModel.toEntity(null),
      paymentInfoEntity: PaymentInfoEntity('', '', false),
      store: RemoteStoreModel.toEntity(null),
    );

    return baseOrderEntity.copyWith(
      id: driverOrderId ?? baseOrderEntity.id,
      store: RemoteStoreModel.toEntity(store),
    );
  }
}