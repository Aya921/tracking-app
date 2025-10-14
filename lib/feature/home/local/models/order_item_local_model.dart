import 'package:isar/isar.dart';
import 'package:tracking_app/feature/home/domain/entity/order_item_entity.dart';
import 'package:tracking_app/feature/home/local/models/product_model_local.dart';
//part 'order_item_local_model.g.dart';
@embedded
class OrderItemLocalModel {
  late int price;
  late int quantity;
  late String id;
  late ProductModel product;

  OrderItemLocalModel();

  static OrderItemLocalModel fromEntity(OrderItemEntity entity) {
    final model = OrderItemLocalModel();
    model.product = ProductModel.fromEntity(entity.product);
    model.price = entity.price;
    model.quantity = entity.quantity;
    model.id = entity.id;
    return model;
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      product: product.toEntity(),
      price: price,
      quantity: quantity,
      id: id,
    );
  }
}
