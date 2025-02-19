import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery/Sign%20Up/signup_modal.dart';
import '../Api Helper/api_helper.dart';
import '../Component/unique_id.dart';
import '../Shared Preferences/shared_preferences_helper.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic>? userDetails;
  int? userId;

  // Controllers for form fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final anniversaryController = TextEditingController();
  final dobController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserDetails();
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    anniversaryController.dispose();
    dobController.dispose();
    super.onClose();
  }

  void loadUserDetails() async {
    final fetchedUserId = await SharedPreferencesHelper.getUserId();
    print("Fetched User ID: $fetchedUserId");

    final fetchedUserDetails = await SharedPreferencesHelper.getUserDetails();
    print("Fetched User Details: $fetchedUserDetails");

    userId = fetchedUserId;
    userDetails = fetchedUserDetails;

    if (userId == null) {
      print("Error: User ID is null or empty");
    }

    if (userDetails != null) {
      nameController.text = userDetails!['name'] ?? '';
      emailController.text = userDetails!['email'] ?? '';
      phoneController.text = userDetails!['phone'] ?? '';
      passwordController.text = userDetails!['password'] ?? '';
      dobController.text = userDetails!['date_of_birth'] ?? '';
      anniversaryController.text = userDetails!['anniversary_date'] ?? '';
    }

    update(); // Notify GetX to update UI
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

  void updateUserDetails(BuildContext context) async {
    final updatedUserDetails = {
      "user_id": userId,
      "name": nameController.text,
      "phone": phoneController.text,
      "password": passwordController.text,
      "email": emailController.text,
      "anniversary_date": anniversaryController.text,
      "date_of_birth": dobController.text,
    };

    bool success = await ApiService.updateUserLogin(
      id: userId!,
      name: nameController.text,
      phone: phoneController.text,
      password: passwordController.text,
      email: emailController.text,
      anniversaryDate: anniversaryController.text,
      dateOfBirth: dobController.text,
      context: context,
    );

    if (success) {
      print("✅ API Success: Updating SharedPreferences...");

      await SharedPreferencesHelper.saveUserDetails(updatedUserDetails);

      // Fetch and print immediately to check if update was successful
      final fetchedDetails = await SharedPreferencesHelper.getUserDetails();
      print("🔄 Updated User Details in SharedPreferences: $fetchedDetails");

      loadUserDetails(); // Reload UI
      Navigator.pop(context); // Close the popup
    } else {
      print("❌ API Failed: User details not updated.");
    }
  }

  void clearFormFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    dobController.clear();
    anniversaryController.clear();
  }
}
