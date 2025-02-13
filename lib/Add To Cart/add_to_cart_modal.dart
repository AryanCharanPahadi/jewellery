import 'dart:convert';

AddToCartModal addToCartModalFromJson(String str) =>
    AddToCartModal.fromJson(json.decode(str));

String addToCartModalToJson(AddToCartModal data) => json.encode(data.toJson());

class AddToCartModal {
  final int userId; // Change to String type
  final int pId; // Change to String type
  final String pPrice; // Change to String type
  final String createdAt; // Change to String type

  AddToCartModal({
    required this.userId,
    required this.pId,
    required this.pPrice,
    required this.createdAt,
  });

  factory AddToCartModal.fromJson(Map<String, dynamic> json) => AddToCartModal(
    userId: json["user_id"],
    pId: json["p_id"],
    pPrice: json["p_price"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "p_id": pId,
        "p_price": pPrice,
        "createdAt": createdAt,
      };
}
