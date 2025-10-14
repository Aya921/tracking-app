class OrderItemResponseEntity {
  String product;
  int price;
  int quantity;
  String id;

  OrderItemResponseEntity({
    required this.product,
    required this.price,
    required this.quantity,
    required this.id,
  });
}
