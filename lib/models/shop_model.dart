class ShopModel {
  int id;
  String image;
  String name;
  String location;
  String city;
  bool delivery;
  bool pickup;
  String whatsapp;
  String description;
  double price;
  double rate;
  DateTime createdAt;
  DateTime updatedAt;

  ShopModel({
    required this.id,
    required this.image,
    required this.name,
    required this.location,
    required this.city,
    required this.delivery,
    required this.pickup,
    required this.whatsapp,
    required this.description,
    required this.price,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        location: json["location"],
        city: json["city"],
        delivery: json["delivery"] == 1,
        pickup: json["pickup"] == 1,
        whatsapp: json["whatsapp"],
        description: json["description"],
        price: json["price"],
        rate: json["rate"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "location": location,
        "city": city,
        "delivery": delivery ? 1 : 0,
        "pickup": pickup ? 1 : 0,
        "whatsapp": whatsapp,
        "description": description,
        "price": price,
        "rate": rate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
