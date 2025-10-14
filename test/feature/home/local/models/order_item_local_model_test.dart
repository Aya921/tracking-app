import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/domain/entity/order_item_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';
import 'package:tracking_app/feature/home/local/models/order_item_local_model.dart';

void main() {
  group('OrderItemLocalModel Conversion Tests', () {
    final productEntity = ProductEntity(
      id: 'p1',
      title: 'Red Rose',
      slug: 'red-rose',
      description: 'Fresh red rose bouquet',
      imgCover: 'https://example.com/rose.png',
      images: ['https://example.com/rose1.png', 'https://example.com/rose2.png'],
      price: 100,
      priceAfterDiscount: 80,
      quantity: 10,
      category: 'Flowers',
      occasion: 'Valentine',
    );

    final entity = OrderItemEntity(
      id: 'item1',
      product: productEntity,
      price: 100,
      quantity: 2,
    );

    test('fromEntity() should convert OrderItemEntity to OrderItemLocalModel correctly', () {
      // act
      final model = OrderItemLocalModel.fromEntity(entity);

      // assert
      expect(model.id, entity.id);
      expect(model.price, entity.price);
      expect(model.quantity, entity.quantity);
      expect(model.product.id, entity.product.id);

    });

    test('toEntity() should convert OrderItemLocalModel back to OrderItemEntity correctly', () {
      // arrange
      final model = OrderItemLocalModel.fromEntity(entity);

      // act
      final convertedEntity = model.toEntity();

      // assert
      expect(convertedEntity.id, model.id);
      expect(convertedEntity.price, model.price);
      expect(convertedEntity.quantity, model.quantity);
      expect(convertedEntity.product.id, model.product.id);

    });
  });
}
