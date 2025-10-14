import 'package:isar/isar.dart';
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';
part 'product_model_local.g.dart';

@embedded
class ProductModel {
  late String id;
  late String title;
  late String slug;
  late String description;
  late String imgCover;
  late List<String> images;
  late int price;
  late int? priceAfterDiscount;
  late int quantity;
  late String category;
  late String occasion;
  ProductModel();



   static ProductModel fromEntity(ProductEntity entity) {
    final model = ProductModel();
    model.id = entity.id;
    model.title = entity.title;
    model.slug = entity.slug;
    model.description = entity.description;
    model.imgCover = entity.imgCover;
    model.images = entity.images;
    model.price = entity.price;
    model.priceAfterDiscount = entity.priceAfterDiscount;
    model.quantity = entity.quantity;
    model.category = entity.category;
    model.occasion = entity.occasion;
    return model;
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      slug: slug,
      description: description,
      imgCover: imgCover,
      images: images,
      price: price,
      priceAfterDiscount: priceAfterDiscount,
      quantity: quantity,
      category: category,
      occasion: occasion,
    );
  }



}
