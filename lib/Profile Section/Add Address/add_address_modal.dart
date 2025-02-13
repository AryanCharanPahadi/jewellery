import 'dart:convert';

AddressModal addressModalFromJson(String str) =>
    AddressModal.fromJson(json.decode(str));

String addressModalToJson(AddressModal data) => json.encode(data.toJson());

class AddressModal {
  int? addressId;
  final String address1;
  final String address2; // Change to String type
  final String city; // Change to String type
  final String state; // Change to String type
  final String postalCode; // Change to String type
  final String country; // Change to String type
  final String createdAt; // Change to String type
  final String userId; // Change to String type

  AddressModal({
    this.addressId,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.createdAt,
    required this.userId,
  });

  factory AddressModal.fromJson(Map<String, dynamic> json) => AddressModal(
    addressId: json["address_id"],
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postal_code"],
        country: json["country"],
        createdAt: json["created_at"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "address_id": addressId,
        "address1": address1,
        "address2": address2,
        "city": city,
        "state": state,
        "postal_code": postalCode,
        "country": country,
        "created_at": createdAt,
        "user_id": userId,
      };
}
