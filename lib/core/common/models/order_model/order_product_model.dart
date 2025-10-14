import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/core/constants/json_serlization_constants.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
part 'order_product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderProductModel {
  @JsonKey(name: JsonSerlizationConstants.id)
  String? id;

  @JsonKey(name: JsonSerlizationConstants.title)
  String? title;

  @JsonKey(name: JsonSerlizationConstants.slug)
  String? slug;

  @JsonKey(name: JsonSerlizationConstants.description)
  String? description;

  @JsonKey(name: JsonSerlizationConstants.imgCover)
  String? imgCover;

  @JsonKey(name: JsonSerlizationConstants.images)
  List<String>? images;

  @JsonKey(name: JsonSerlizationConstants.price)
  int? price;

  @JsonKey(name: JsonSerlizationConstants.priceAfterDiscount)
  int? priceAfterDiscount;

  @JsonKey(name: JsonSerlizationConstants.quantity)
  int? quantity;

  @JsonKey(name: JsonSerlizationConstants.category)
  String? category;

  @JsonKey(name: JsonSerlizationConstants.occasion)
  String? occasion;

  @JsonKey(name: JsonSerlizationConstants.createdAt)
  String? createdAt;

  @JsonKey(name: JsonSerlizationConstants.updatedAt)
  String? updatedAt;

  @JsonKey(name: JsonSerlizationConstants.v)
  int? v;

  @JsonKey(name: JsonSerlizationConstants.isSuperAdmin)
  bool? isSuperAdmin;

  @JsonKey(name: JsonSerlizationConstants.sold)
  int? sold;

  @JsonKey(name: JsonSerlizationConstants.rateAvg)
  int? rateAvg;

  @JsonKey(name: JsonSerlizationConstants.rateCount)
  int? rateCount;

  OrderProductModel({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.quantity,
    this.category,
    this.occasion,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isSuperAdmin,
    this.sold,
    this.rateAvg,
    this.rateCount,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);
  static ProductEntity toEntity(OrderProductModel? model) {
    if (model == null) {
      return ProductEntity(
        id: '674511e790ab40a06854034b',
        title: 'Fake Product',
        slug: 'fake-product',
        description: 'This is a fake product description',
        imgCover: '44da12d8-4017-4e97-b654-ae76b5c8af48-cover_image.png',
        images: [
          "66c36d5d-c067-46d9-b339-d81be57e0149-image_one.png",
          "f27e1903-74cf-4ed6-a42c-e43e35b6dd14-image_three.png",
          "500fe197-0e16-4b01-9a0d-031ccb032714-image_two.png",
        ],
        price: 999,
        priceAfterDiscount: 799,
        quantity: 10,
        category: '673c46fd1159920171827c85',
        occasion: '673b34c21159920171827ae0',
      );
    }

    return ProductEntity(
      id: model.id ?? '',
      title: model.title ?? '',
      slug: model.slug ?? '',
      description: model.description ?? '',
      imgCover: model.imgCover ?? '',
      images: model.images ?? [""],
      price: model.price ?? 0,
      priceAfterDiscount: model.priceAfterDiscount,
      quantity: model.quantity ?? 0,
      category: model.category ?? '',
      occasion: model.occasion ?? '',
    );
  }

  factory OrderProductModel.fromEntity(ProductEntity entity) {
    return OrderProductModel(
      id: entity.id,
      title: entity.title,
      slug: entity.slug,
      description: entity.description,
      imgCover: entity.imgCover,
      images: entity.images,
      price: entity.price,
      priceAfterDiscount: entity.priceAfterDiscount,
      quantity: entity.quantity,
      category: entity.category,
      occasion: entity.occasion,
    );
  }
}
