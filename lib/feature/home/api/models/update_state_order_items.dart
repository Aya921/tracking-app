import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_item_entity.dart';

part 'update_state_order_items.g.dart';

@JsonSerializable()
class UpdateStateOrderItems {
  @JsonKey(name: JsonSerlizationConstants.product)
  final String product;

  @JsonKey(name: JsonSerlizationConstants.price)
  final int price;

  @JsonKey(name: JsonSerlizationConstants.quantity)
  final int quantity;

  @JsonKey(name: JsonSerlizationConstants.id)
  final String id;

  UpdateStateOrderItems({
    required this.product,
    required this.price,
    required this.quantity,
    required this.id,
  });

  factory UpdateStateOrderItems.fromJson(Map<String, dynamic> json) =>
      _$UpdateStateOrderItemsFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateStateOrderItemsToJson(this);

  OrderItemResponseEntity toEntity() {
    return OrderItemResponseEntity(
      product: product,
      price: price,
      quantity: quantity,
      id: id,
    );
  }
}
