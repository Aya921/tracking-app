import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/order/api/models/remote_order_item_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_shipping_address_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_user_model.dart';

part 'remote_order_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteOrderInfoModel {
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

  RemoteOrderInfoModel({
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
  });

  factory RemoteOrderInfoModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteOrderInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteOrderInfoModelToJson(this);
}
