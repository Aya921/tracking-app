import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/api/models/remote_order_item_model.dart';
import 'package:tracking_app/feature/home/api/models/remote_product_model.dart';
import 'package:tracking_app/feature/home/domain/entity/order_item_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';

void main() {
  group("RemoteOrderItemModel", () {
    group('RemoteOrderItemModel.toEntity', () {
      test(
        'should convert to OrderItemEntity correctly when product is null',
        () {
          // Arrange
          final model = RemoteOrderItemModel(
            id: 'orderItem1',
            price: 150,
            quantity: 2,
            product: null,
          );

          // Act
          final entity = model.toEntity();

          // Assert
          expect(entity.id, model.id);
          expect(entity.price, model.price);
          expect(entity.quantity, model.quantity);

          // Product created from default (RemoteProductModel.toEntity handles null)
          expect(entity.product.id, isNotEmpty);
          expect(entity.product.title, isNotEmpty);
        },
      );

      test(
        'should convert to OrderItemEntity correctly when product has data',
        () {
          // Arrange
          final productModel = RemoteProductModel(
            id: 'p1',
            title: 'Product 1',
            slug: 'product-1',
            description: 'Test Product',
            imgCover: 'cover.png',
            images: ['img1.png', 'img2.png'],
            price: 120,
            priceAfterDiscount: 100,
            quantity: 5,
            category: 'cat1',
            occasion: 'occ1',
          );

          final model = RemoteOrderItemModel(
            id: 'orderItem1',
            price: 100,
            quantity: 3,
            product: productModel,
          );

          // Act
          final entity = model.toEntity();

          // Assert
          expect(entity.id, model.id);
          expect(entity.price, model.price);
          expect(entity.quantity, model.quantity);

          // Product mapping
          expect(entity.product.id, model.product!.id);
          expect(entity.product.title, model.product!.title);
          expect(entity.product.slug, model.product!.slug);
          expect(entity.product.description, model.product!.description);
          expect(entity.product.imgCover, model.product!.imgCover);
          expect(entity.product.images, model.product!.images);
          expect(entity.product.price, model.product!.price);
          expect(
            entity.product.priceAfterDiscount,
            model.product!.priceAfterDiscount,
          );
          expect(entity.product.quantity, model.product!.quantity);
          expect(entity.product.category, model.product!.category);
          expect(entity.product.occasion, model.product!.occasion);
        },
      );
    });

    group('RemoteOrderItemModel.fromEntity', () {
      test(
        'should convert from OrderItemEntity to RemoteOrderItemModel correctly',
        () {
          // Arrange
          final  productEntity = ProductEntity(
            id: 'p1',
            title: 'Product 1',
            slug: 'product-1',
            description: 'A test product',
            imgCover: 'cover.png',
            images: ['img1.png', 'img2.png'],
            price: 120,
            priceAfterDiscount: 100,
            quantity: 5,
            category: 'cat1',
            occasion: 'occ1',
          );

          final  entity = OrderItemEntity(
            id: 'orderItem1',
            price: 200,
            quantity: 2,
            product: productEntity,
          );

          // Act
          final model = RemoteOrderItemModel.fromEntity(entity);

          // Assert
          expect(model.id, entity.id);
          expect(model.price, entity.price);
          expect(model.quantity, entity.quantity);
          expect(model.product!.id, entity.product.id);
          expect(model.product!.title, entity.product.title);
          expect(model.product!.slug, entity.product.slug);
          expect(model.product!.description, entity.product.description);
          expect(model.product!.imgCover, entity.product.imgCover);
          expect(model.product!.images, entity.product.images);
          expect(model.product!.price, entity.product.price);
          expect(
            model.product!.priceAfterDiscount,
            entity.product.priceAfterDiscount,
          );
          expect(model.product!.quantity, entity.product.quantity);
          expect(model.product!.category, entity.product.category);
          expect(model.product!.occasion, entity.product.occasion);
        },
      );
    });
  });
}
