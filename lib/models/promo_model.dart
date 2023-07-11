import 'package:flutter_laundry_app/models/shop_model.dart';

class PromoModel {
  int id;
  String image;
  String shopId;
  double oldPrice;
  double newPrice;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  ShopModel shop;

  PromoModel({
    required this.id,
    required this.image,
    required this.shopId,
    required this.oldPrice,
    required this.newPrice,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.shop,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        id: json["id"],
        image: json["image"],
        shopId: json["shop_id"],
        // oldPrice: json["old_price"]?.toDouble(), // error
        oldPrice: double.tryParse(json["old_price"]) ?? 0.0,
        // newPrice: json["new_price"]?.toDouble(), // error
        newPrice: double.tryParse(json["new_price"]) ?? 0.0,
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
        shop: ShopModel.fromJson(json["shop"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "shop_id": shopId,
        "old_price": oldPrice,
        "new_price": newPrice,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "shop": shop.toJson(),
      };
}
