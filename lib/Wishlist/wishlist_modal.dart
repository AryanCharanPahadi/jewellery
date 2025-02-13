import 'dart:convert';

WishlistModal wishlistModalFromJson(String str) =>
    WishlistModal.fromJson(json.decode(str));

String wishlistModalToJson(WishlistModal data) => json.encode(data.toJson());

class WishlistModal {
  final int userId; // Change to String type
  final int pId; // Change to String type
  final String pPrice; // Change to String type
  final String createdAt; // Change to String type

  WishlistModal({
    required this.userId,
    required this.pId,
    required this.pPrice,
    required this.createdAt,
  });

  factory WishlistModal.fromJson(Map<String, dynamic> json) => WishlistModal(
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
