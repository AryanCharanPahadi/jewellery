import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery/Sign%20Up/signup_modal.dart';
import '../Api Helper/api_helper.dart';
import '../Component/unique_id.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  // Controllers for form fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final anniversaryController = TextEditingController();
  final dobController = TextEditingController();

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();

    super.onClose();
  }

  void submitForm(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    String formattedDate = getFormattedDate();
    final signUpModal = SignUpModal(
      name: nameController.text,
      dob: dobController.text,
      annDob: anniversaryController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      createdAt: formattedDate,
    );
    ApiService.addUserDetail(signUpModal, context);
    Navigator.pop(context); // Close the popup

    // Clear the form fields after submission
    clearFormFields();
  }

  void clearFormFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
  }
}
