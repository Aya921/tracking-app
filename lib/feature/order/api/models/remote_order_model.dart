import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/order/api/models/remote_order_item_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_shipping_address_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_store_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_user_model.dart';
import 'package:tracking_app/feature/order/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';
part 'remote_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteOrderModel {
  @JsonKey(name: JsonSerlizationConstants.id)
String? id;

@JsonKey(name: JsonSerlizationConstants.user)
RemoteUserModel? user;

@JsonKey(name: JsonSerlizationConstants.orderItems)
List<RemoteOrderItemModel>? orderItems;

@JsonKey(name: JsonSerlizationConstants.totalPrice)
int? totalPrice;

@JsonKey(name: JsonSerlizationConstants.shippingAddress)
RemoteShippingAddressModel? shippingAddress;

@JsonKey(name: JsonSerlizationConstants.paymentType)
String? paymentType;

@JsonKey(name: JsonSerlizationConstants.isPaid)
bool? isPaid;

@JsonKey(name: JsonSerlizationConstants.paidAt)
String? paidAt;

@JsonKey(name: JsonSerlizationConstants.isDelivered)
bool? isDelivered;

@JsonKey(name: JsonSerlizationConstants.state)
String? state;

@JsonKey(name: JsonSerlizationConstants.createdAt)
String? createdAt;

@JsonKey(name: JsonSerlizationConstants.updatedAt)
String? updatedAt;

@JsonKey(name: JsonSerlizationConstants.orderNumber)
String? orderNumber;

@JsonKey(name: JsonSerlizationConstants.v)
int? v;

@JsonKey(name: JsonSerlizationConstants.store)
RemoteStoreModel? store;


  RemoteOrderModel({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.shippingAddress,
    this.paymentType,
    this.isPaid,
    this.paidAt,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
    this.store,
  });

  factory RemoteOrderModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteOrderModelToJson(this);

  OrderEntity toEntity() {

    return OrderEntity(
      id: id ?? '',
      user: RemoteUserModel.toEntity(user),
      orderItems: orderItems?.map((order) => order.toEntity()).toList()??[],
      orderInfoEntity: OrderInfoEntity(isDelivered ?? false,  state ?? '',  
      orderNumber ?? '', createdAt ?? '', updatedAt ?? '',  v ?? -1,  totalPrice ?? 0),
      shippingAddress: RemoteShippingAddressModel.toEntity(shippingAddress),
      paymentInfoEntity: PaymentInfoEntity( paymentType ?? '',  paidAt ?? '',  isPaid ?? false,),
      store: RemoteStoreModel.toEntity(store),
      
    );
  }

  factory RemoteOrderModel.fromEntity(OrderEntity entity) {
    return RemoteOrderModel(
      id: entity.id,
      user: RemoteUserModel.fromEntity(entity.user),
      orderItems: entity.orderItems
          .map(RemoteOrderItemModel.fromEntity)
          .toList(),
      totalPrice: entity.orderInfoEntity.totalPrice,
      shippingAddress: RemoteShippingAddressModel.fromEntity(
        entity.shippingAddress,
      ),
      paymentType: entity.paymentInfoEntity.paymentType,
      isPaid: entity.paymentInfoEntity.isPaid,
      isDelivered: entity.orderInfoEntity.isDelivered,
      state: entity.orderInfoEntity.state,
      orderNumber: entity.orderInfoEntity.orderNumber,
      store: RemoteStoreModel.fromEntity(entity.store),
      createdAt: entity.orderInfoEntity.createdAt,
      updatedAt: entity.orderInfoEntity.updatedAt,
      paidAt: entity.paymentInfoEntity.paidAt,
      v: entity.orderInfoEntity.v
    );
  }
}
