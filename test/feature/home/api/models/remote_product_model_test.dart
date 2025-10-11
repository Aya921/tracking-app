import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/api/models/remote_product_model.dart';
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';

void main() {
  group('test RemoteProductModel.toEntity function', () {
    test('should return fake ProductEntity when model is null', () {
      // act
      final result = RemoteProductModel.toEntity(null);

      // assert
      expect(result, isA<ProductEntity>());
      expect(result.id, '674511e790ab40a06854034b');
      expect(result.title, 'Fake Product');
      expect(result.slug, 'fake-product');
      expect(result.description, contains('fake product description'));
      expect(result.images.length, 3);
      expect(result.price, 999);
      expect(result.priceAfterDiscount, 799);
      expect(result.quantity, 10);
    });

    test('should map fields correctly when model is not null', () {
      // arrange
      final model = RemoteProductModel(
        id: 'p1',
        title: 'Test Product',
        slug: 'test-product',
        description: 'A test product description',
        imgCover: 'cover.png',
        images: ['img1.png', 'img2.png'],
        price: 120,
        priceAfterDiscount: 100,
        quantity: 5,
        category: 'cat1',
        occasion: 'occ1',
      );

      // act
      final result = RemoteProductModel.toEntity(model);

      // assert
      expect(result, isA<ProductEntity>());
      expect(result.id, model.id);
      expect(result.title, model.title);
      expect(result.slug, model.slug);
      expect(result.description, model.description);
      expect(result.imgCover, model.imgCover);
      expect(result.images, model.images);
      expect(result.price, model.price);
      expect(result.priceAfterDiscount, model.priceAfterDiscount);
      expect(result.quantity, model.quantity);
      expect(result.category, model.category);
      expect(result.occasion, model.occasion);
    });
  });

  group('test RemoteProductModel.fromEntity function', () {
    test('should map all fields correctly when entity has full data', () {
      // arrange
      final entity =  ProductEntity(
        id: 'p1',
        title: 'Test Product',
        slug: 'test-product',
        description: 'A test description',
        imgCover: 'cover.png',
        images: ['img1.png', 'img2.png'],
        price: 120,
        priceAfterDiscount: 100,
        quantity: 5,
        category: 'cat1',
        occasion: 'occ1',
      );

      // act
      final model = RemoteProductModel.fromEntity(entity);

      // assert
      expect(model, isA<RemoteProductModel>());
      expect(model.id, entity.id);
      expect(model.title, entity.title);
      expect(model.slug, entity.slug);
      expect(model.description, entity.description);
      expect(model.imgCover, entity.imgCover);
      expect(model.images, entity.images);
      expect(model.price, entity.price);
      expect(model.priceAfterDiscount, entity.priceAfterDiscount);
      expect(model.quantity, entity.quantity);
      expect(model.category, entity.category);
      expect(model.occasion, entity.occasion);
    });
  });
}
