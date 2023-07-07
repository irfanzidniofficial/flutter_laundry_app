import 'package:flutter_laundry_app/models/shop_model.dart';
import 'package:flutter_laundry_app/models/user_model.dart';

class LaundryModel {
  int id;
  String claimCode;
  String userId;
  String shopId;
  String weight;
  bool withPickup;
  bool withDelivery;
  String pickupAddress;
  String deliveryAddress;
  double total;
  String description;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel user;
  ShopModel shop;

  LaundryModel({
    required this.id,
    required this.claimCode,
    required this.userId,
    required this.shopId,
    required this.weight,
    required this.withPickup,
    required this.withDelivery,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.total,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.shop,
  });

  factory LaundryModel.fromJson(Map<String, dynamic> json) => LaundryModel(
        id: json["id"],
        claimCode: json["claim_code"],
        userId: json["user_id"],
        shopId: json["shop_id"],
        weight: json["weight"],
        withPickup: json["with_pickup"] == 1,
        withDelivery: json["with_delivery"] == 1,
        pickupAddress: json["pickup_address"],
        deliveryAddress: json["delivery_address"],
        total: json["total"],
        description: json["description"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
        user: UserModel.fromJson(json["user"]),
        shop: ShopModel.fromJson(json["shop"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "claim_code": claimCode,
        "user_id": userId,
        "shop_id": shopId,
        "weight": weight,
        "with_pickup": withPickup,
        "with_delivery": withDelivery,
        "pickup_address": pickupAddress,
        "delivery_address": deliveryAddress,
        "total": total,
        "description": description,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "shop": shop.toJson(),
      };
}
