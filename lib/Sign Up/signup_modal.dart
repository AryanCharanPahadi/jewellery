import 'dart:convert';

SignUpModal signUpModalFromJson(String str) =>
    SignUpModal.fromJson(json.decode(str));

String signUpModalToJson(SignUpModal data) => json.encode(data.toJson());

class SignUpModal {
  String name;
  String dob;
  String annDob;
  final String email; // Change to String type
  final String phone; // Change to String type
  final String password; // Change to String type
  final String createdAt; // Change to String type

  SignUpModal({
    required this.name,
    required this.dob,
    required this.annDob,
    required this.email,
    required this.phone,
    required this.password,
    required this.createdAt,
  });

  factory SignUpModal.fromJson(Map<String, dynamic> json) => SignUpModal(
        name: json["name"],
        dob: json["date_of_birth"],
        annDob: json["anniversary_date"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date_of_birth": dob,
        "anniversary_date": annDob,
        "email": email,
        "phone": phone,
        "password": password,
        "createdAt": createdAt,
      };
}
