import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';
import 'package:tracking_app/feature/home/local/models/product_model_local.dart';

void main() {
  group('ProductModel Conversion Tests', () {

    final productEntity = ProductEntity(
      id: 'p1',
      title: 'Red Roses',
      slug: 'red-roses',
      description: 'A bouquet of beautiful red roses',
      imgCover: 'cover.jpg',
      images: ['img1.jpg', 'img2.jpg'],
      price: 150,
      priceAfterDiscount: 120,
      quantity: 10,
      category: 'Flowers',
      occasion: 'Valentine',
    );

    test('fromEntity() should convert ProductEntity to ProductModel correctly', () {
      // act
      final model = ProductModel.fromEntity(productEntity);

      // assert
      expect(model.id, productEntity.id);
      expect(model.title, productEntity.title);
      expect(model.slug, productEntity.slug);
      expect(model.description, productEntity.description);
      expect(model.imgCover, productEntity.imgCover);
      expect(model.images, productEntity.images);
      expect(model.price, productEntity.price);
      expect(model.priceAfterDiscount, productEntity.priceAfterDiscount);
      expect(model.quantity, productEntity.quantity);
      expect(model.category, productEntity.category);
      expect(model.occasion, productEntity.occasion);
    });

    test('toEntity() should convert ProductModel back to ProductEntity correctly', () {
      // arrange
      final model = ProductModel.fromEntity(productEntity);

      // act
      final entity = model.toEntity();

      // assert
      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.slug, model.slug);
      expect(entity.description, model.description);
      expect(entity.imgCover, model.imgCover);
      expect(entity.images, model.images);
      expect(entity.price, model.price);
      expect(entity.priceAfterDiscount, model.priceAfterDiscount);
      expect(entity.quantity, model.quantity);
      expect(entity.category, model.category);
      expect(entity.occasion, model.occasion);
    });
  });
}
