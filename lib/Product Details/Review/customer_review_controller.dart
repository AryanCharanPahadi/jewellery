import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api Helper/api_helper.dart';
import '../../Component/unique_id.dart';
import '../../Login Page/login_student_modal.dart';
import 'customer_review_modal.dart';

class CustomerReviewController extends GetxController {
  // Form keys and controllers

  final formKey = GlobalKey<FormState>();
  final ratingController = TextEditingController();
  final reviewController = TextEditingController();
  final headlineController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String? validateRating(String? value) {
    if (value == null || value.isEmpty) {
      return "Rating is required";
    }
    final numRating = int.tryParse(value);
    if (numRating == null || numRating < 1 || numRating > 5) {
      return "Enter a rating between 1 and 5";
    }
    return null;
  }

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  void submitForm(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    String formattedDate = getFormattedDate();
    final customerReviewModal = CustomerReviewModal(
      name: nameController.text,
      email: emailController.text,
      rating: ratingController.text,
      headline: headlineController.text,
      review: reviewController.text,
      createdAt: formattedDate,
    );
    ApiService.customerRating(customerReviewModal, context);
    Navigator.pop(context); // Close the popup

    // Clear the form fields after submission
    clearFields();
  }

  var customerRatings = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchRatings();
    super.onInit();
  }

  void fetchRatings() async {
    try {
      isLoading(true);
      var ratings = await ApiService.fetchCustomerRatings();
      customerRatings.assignAll(ratings);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Clear input fields
  void clearFields() {
    emailController.clear();
    nameController.clear();
    ratingController.clear();
    headlineController.clear();
    reviewController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    ratingController.dispose();
    headlineController.dispose();
    reviewController.dispose();
    super.onClose();
  }
}
