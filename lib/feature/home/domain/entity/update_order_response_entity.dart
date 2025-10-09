import 'package:tracking_app/feature/home/domain/entity/update_order_item_entity.dart';

class OrderResponseEntity {
  String id;
  String user;
  List<OrderItemResponseEntity> orderItems;
  int totalPrice;
  String paymentType;
  bool isPaid;
  bool isDelivered;
  String state;
  String orderNumber;

  OrderResponseEntity({
    required this.id,
    required this.user,
    required this.orderItems,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,

    required this.orderNumber,
  });
}
