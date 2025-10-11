import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/api/models/update_state_order_items.dart';

void main() {
  test('should correctly convert UpdateStateOrderItems to StartOrderItemEntity', () {
    // Arrange
    final model = UpdateStateOrderItems(
      product: 'product_1',
      price: 150,
      quantity: 3,
      id: 'item_123',
    );

    // Act
    final entity = model.toEntity();

    // Assert
    expect(entity.id, model.id);
    expect(entity.product, model.product);
    expect(entity.price, model.price);
    expect(entity.quantity, model.quantity);
  });
}
