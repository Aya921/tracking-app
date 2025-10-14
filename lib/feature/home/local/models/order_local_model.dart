import 'package:isar/isar.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';
import 'package:tracking_app/feature/home/local/models/product_model_local.dart';
import 'package:tracking_app/feature/home/local/models/order_item_local_model.dart';
import 'package:tracking_app/feature/home/local/models/shipping_address_local_model.dart';
import 'package:tracking_app/feature/home/local/models/store_local_model.dart';
import 'package:tracking_app/feature/home/local/models/user_local_model.dart';

part 'order_local_model.g.dart';

@Collection()

class OrderLocalModel {
  String get id => orderId;
  late String orderId;
  late UserLocalModel user;
  late List<OrderItemLocalModel> orderItems;
  late int totalPrice;
  late ShippingAddressLocalModel shippingAddress;
  late String paymentType;
  late bool isPaid;
  late bool isDelivered;
  late String state;
  late String orderNumber;
  late StoreLocalModel store;
  late String paidAt;
  late String createdAt;
  late String updatedAt;
  late int v;

  static OrderLocalModel toLocalModel(OrderEntity entity) {
    return OrderLocalModel()
      ..orderId = entity.id
      ..user = UserLocalModel.fromEntity(entity.user)
      ..orderItems = entity.orderItems
          .map(OrderItemLocalModel.fromEntity)
          .toList()
      ..totalPrice = entity.orderInfoEntity.totalPrice
      ..shippingAddress = ShippingAddressLocalModel.fromEntity(
        entity.shippingAddress,
      )
      ..paymentType = entity.paymentInfoEntity.paymentType
      ..isPaid = entity.paymentInfoEntity.isPaid
      ..isDelivered = entity.orderInfoEntity.isDelivered
      ..state = entity.orderInfoEntity.state
      ..orderNumber = entity.orderInfoEntity.orderNumber
      ..createdAt = entity.orderInfoEntity.createdAt
      ..updatedAt = entity.orderInfoEntity.updatedAt
      ..v = entity.orderInfoEntity.v
      ..paidAt = entity.paymentInfoEntity.paidAt
      ..store = StoreLocalModel.fromEntity(entity.store);
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: orderId,
      user: user.toEntity(),
      orderItems: orderItems.map((local) => local.toEntity()).toList(),
      orderInfoEntity: OrderInfoEntity(
        isDelivered,
        state,
        orderNumber,
        createdAt,
        updatedAt,
        v,
        totalPrice,
      ),

      shippingAddress: shippingAddress.toEntity(),
      paymentInfoEntity: PaymentInfoEntity(paymentType, paidAt, isPaid),

      store: store.toEntity(),
    );
  }
}
