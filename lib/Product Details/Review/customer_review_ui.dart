import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Component/custom_container_login_signup.dart';
import '../../Component/custom_text.dart';
import '../../Component/custom_text_field.dart';
import '../../Component/gradient_button.dart';
import '../../Component/responsive_padding_component.dart';
import 'customer_review_controller.dart';

class CustomerReviewUi extends StatefulWidget {
  const CustomerReviewUi({super.key});

  @override
  State<CustomerReviewUi> createState() => _CustomerReviewUiState();
}

class _CustomerReviewUiState extends State<CustomerReviewUi> {
  final CustomerReviewController customerReviewController =
      Get.put(CustomerReviewController());

  @override
  Widget build(BuildContext context) {
    ResponsivePaddingWidth responsive = ResponsivePaddingWidth(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: responsive.padding),
        child: Form(
          key: customerReviewController.formKey,
          child: CustomContainer(
            width: responsive.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
                ),
                const CustomTitleText(text: "Share your thoughts"),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Rate 1 to 5",
                  icon: Icons.email,
                  controller: customerReviewController.ratingController,
                  isNumberField: true,
                  validator: customerReviewController.validateRating,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Add a headline",
                  icon: Icons.email,
                  controller: customerReviewController.headlineController,
                  validator: customerReviewController.validateField,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Write a review",
                  icon: Icons.lock,
                  controller: customerReviewController.reviewController,
                  validator: customerReviewController.validateField,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Your name",
                  icon: Icons.email,
                  controller: customerReviewController.nameController,
                  validator: customerReviewController.validateField,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Your email address",
                  icon: Icons.email,
                  controller: customerReviewController.emailController,
                  validator: customerReviewController.validateEmail,
                ),
                const SizedBox(height: 30),
                GradientButton(
                  text: "Submit",
                  onPressed: () => customerReviewController.submitForm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
