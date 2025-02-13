import 'package:flutter/material.dart';

class CustomTextWidgets {
  static Widget alreadyHaveAccountText() {
    return const Text(
      "Already have an account?",
      style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
    );
  }

  static Widget signIn() {
    return const Text(
      "Sign In",
      style: TextStyle(color: Colors.blueAccent, fontSize: 14,fontWeight: FontWeight.bold),

    );
  }

  static Widget doNotAlreadyHaveAccountText() {
    return const Text(
      "Don't have an account?",
      style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
    );
  }

  static Widget signUp() {
    return const Text(
      "Sign Up",
      style: TextStyle(color: Colors.blueAccent, fontSize: 14,fontWeight: FontWeight.bold),
    );
  }
}
