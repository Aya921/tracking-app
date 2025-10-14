import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/core/common/models/order_model/order_product_model.dart';

import '../../entity/order_entity/order_item_entity.dart';

part 'order_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItemModel {
  @JsonKey(name: JsonSerlizationConstants.product)
  OrderProductModel? product;

  @JsonKey(name: JsonSerlizationConstants.price)
  int? price;

  @JsonKey(name: JsonSerlizationConstants.quantity)
  int? quantity;

  @JsonKey(name: JsonSerlizationConstants.id)
  String? id;

  OrderItemModel({this.product, this.price, this.quantity, this.id});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id ?? '',
      price: price ?? 0,
      quantity: quantity ?? 0,
      product: OrderProductModel.toEntity(product),
    );
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      id: entity.id,
      price: entity.price,
      quantity: entity.quantity,
      product: OrderProductModel.fromEntity(entity.product),
    );
  }
}
