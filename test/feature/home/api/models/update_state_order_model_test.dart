import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/api/models/update_state_order_items.dart';
import 'package:tracking_app/feature/home/api/models/update_state_order_model.dart';


void main() {
  test('should correctly convert UpdateStateOrderModel to StartOrderResponseEntity', () {
    // Arrange
    final model = UpdateStateOrderModel(
      id: 'order_123',
      user: 'user_1',
      orderItems: [
        UpdateStateOrderItems(
          product: 'product_1',
          price: 150,
          quantity: 2,
          id: 'item_1',
        ),
      ],
      totalPrice: 300,
      paymentType: 'cash',
      isPaid: true,
      isDelivered: false,
      state: 'processing',
      createdAt: DateTime.parse('2025-10-11T12:00:00Z'),
      updatedAt: DateTime.parse('2025-10-11T12:10:00Z'),
      orderNumber: 'ORD001',
      v: 1,
    );

    // Act
    final entity = model.toEntity();

    // Assert
    expect(entity.id, model.id);
    expect(entity.user, model.user);
    expect(entity.orderItems.first.id, model.orderItems.first.id);
    expect(entity.totalPrice, model.totalPrice);
    expect(entity.paymentType, model.paymentType);
    expect(entity.isPaid, model.isPaid);
    expect(entity.isDelivered, model.isDelivered);
    expect(entity.state, model.state);
    expect(entity.orderNumber, model.orderNumber);
  });
}
