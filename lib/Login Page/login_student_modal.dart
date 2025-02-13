import 'dart:convert';

LoginModal loginModalFromJson(String str) =>
    LoginModal.fromJson(json.decode(str));

String loginModalToJson(LoginModal data) => json.encode(data.toJson());

class LoginModal {

  final String email; // Change to String type
  final String password; // Change to String type

  LoginModal({

    required this.email,
    required this.password,
  });

  factory LoginModal.fromJson(Map<String, dynamic> json) => LoginModal(

    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {

    "email": email,
    "password": password,
  };
}
