import 'package:tracking_app/feature/home/domain/entity/start_order_item_entity.dart';

class StartOrderResponseEntity {
  String id;
  String user;
  List<StartOrderItemEntity> orderItems;
  int totalPrice;
  String paymentType;
  bool isPaid;
  bool isDelivered;
  String state;
  String orderNumber;

  StartOrderResponseEntity

      ({
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
