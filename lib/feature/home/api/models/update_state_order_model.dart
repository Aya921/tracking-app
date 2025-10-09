import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/home/api/models/update_state_order_items.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_response_entity.dart';

part 'update_state_order_model.g.dart';

@JsonSerializable()
class UpdateStateOrderModel {
  @JsonKey(name: JsonSerlizationConstants.id)
  final String id;

  @JsonKey(name: JsonSerlizationConstants.user)
  final String user;

  @JsonKey(name: JsonSerlizationConstants.orderItems)
  final List<UpdateStateOrderItems> orderItems;

  @JsonKey(name: JsonSerlizationConstants.totalPrice)
  final int totalPrice;

  @JsonKey(name: JsonSerlizationConstants.paymentType)
  final String paymentType;

  @JsonKey(name: JsonSerlizationConstants.isPaid)
  final bool isPaid;

  @JsonKey(name: JsonSerlizationConstants.isDelivered)
  final bool isDelivered;

  @JsonKey(name: JsonSerlizationConstants.state)
  final String state;

  @JsonKey(name: JsonSerlizationConstants.createdAt)
  final DateTime createdAt;

  @JsonKey(name: JsonSerlizationConstants.updatedAt)
  final DateTime updatedAt;

  @JsonKey(name: JsonSerlizationConstants.orderNumber)
  final String orderNumber;

  @JsonKey(name: JsonSerlizationConstants.v)
  final int v;

  UpdateStateOrderModel({
    required this.id,
    required this.user,
    required this.orderItems,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.orderNumber,
    required this.v,
  });

  factory UpdateStateOrderModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateStateOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateStateOrderModelToJson(this);

  OrderResponseEntity toEntity() {
    return OrderResponseEntity(
      id: id,
      user: user,
      orderItems: orderItems.map((model) => model.toEntity()).toList(),
      totalPrice: totalPrice,
      paymentType: paymentType,
      isPaid: isPaid,
      isDelivered: isDelivered,
      state: state,
      orderNumber: orderNumber,
    );
  }
}
