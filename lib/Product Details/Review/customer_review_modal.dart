import 'dart:convert';

CustomerReviewModal customerReviewModalFromJson(String str) =>
    CustomerReviewModal.fromJson(json.decode(str));

String customerReviewModalToJson(CustomerReviewModal data) =>
    json.encode(data.toJson());

class CustomerReviewModal {
  final String email; // Change to String type
  final String name; // Change to String type
  final String rating; // Change to String type
  final String headline; // Change to String type
  final String review; // Change to String type
  final String createdAt; // Change to String type

  CustomerReviewModal({
    required this.email,
    required this.name,
    required this.rating,
    required this.headline,
    required this.review,
    required this.createdAt,
  });

  factory CustomerReviewModal.fromJson(Map<String, dynamic> json) =>
      CustomerReviewModal(
        email: json["email"],
        name: json["name"],
        rating: json["rating"],
        headline: json["headline"],
        review: json["review"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "rating": rating,
        "headline": headline,
        "review": review,
        "createdAt": createdAt,
      };
}
