
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';

class OrderItemEntity {
    ProductEntity product;
    int price;
    int quantity;
    String id;

    OrderItemEntity({
        required this.product,
        required this.price,
        required this.quantity,
        required this.id,
    });

  
}
