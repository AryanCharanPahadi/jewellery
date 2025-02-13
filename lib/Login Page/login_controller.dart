import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Api Helper/api_helper.dart';
import '../Shared Preferences/shared_preferences_helper.dart';
import 'login_student_modal.dart';

class LoginController extends GetxController {
  // Form keys and controllers
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final loginModal = LoginModal(
      email: emailController.text,
      password: passwordController.text,
    );

    final loginResponse = await ApiService.login(loginModal, context);

    if (kDebugMode) {
      print("Login Response: $loginResponse");
    } // Debugging

    // Check if login is successful
    if (loginResponse['success'] == true) {
      if (kDebugMode) {
        print("Login Successful, saving data to SharedPreferences...");
      }

      await SharedPreferencesHelper.saveLoginStatus(true);
      await SharedPreferencesHelper.saveUserDetails(loginResponse);

      var savedUser = await SharedPreferencesHelper.getUserDetails();
      if (kDebugMode) {
        print("Saved User in SharedPreferences: $savedUser");
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });

      clearFields();
    } else {
      if (kDebugMode) {
        print(
          "Login Failed, error: ${loginResponse['message'] ?? 'Unknown error'}");
      }

      // Ensure SharedPreferences is NOT updated on failure
      return;
    }
  }

  // Clear input fields
  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
