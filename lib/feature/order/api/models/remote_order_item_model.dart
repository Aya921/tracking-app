import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/feature/home/api/models/remote_product_model.dart';

import '../../domain/entity/order_item_entity.dart';

part 'remote_order_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteOrderItemModel {
  @JsonKey(name: JsonSerlizationConstants.product)
RemoteProductModel? product;

@JsonKey(name: JsonSerlizationConstants.price)
int? price;

@JsonKey(name: JsonSerlizationConstants.quantity)
int? quantity;

@JsonKey(name: JsonSerlizationConstants.id)
String? id;


  RemoteOrderItemModel({this.product, this.price, this.quantity, this.id});

  factory RemoteOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteOrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteOrderItemModelToJson(this);

   OrderItemEntity toEntity(
   
  ) {
    return OrderItemEntity(
      id: id ?? '',
      price: price ?? 0,
      quantity: quantity ?? 0,
      product: RemoteProductModel.toEntity(product),
    );
  }

 
  factory RemoteOrderItemModel.fromEntity(OrderItemEntity entity) {
    return RemoteOrderItemModel(
      id: entity.id,
      price: entity.price,
      quantity: entity.quantity,
      product: RemoteProductModel.fromEntity(entity.product),
    );
  }
}
