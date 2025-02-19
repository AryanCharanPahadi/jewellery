import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery/Sign%20Up/signup_controller.dart';
import '../Component/already_have_an_account.dart';
import '../Component/custom_container_login_signup.dart';
import '../Component/custom_text.dart';
import '../Component/custom_text_field.dart';
import '../Component/gradient_button.dart';
import '../Component/responsive_padding_component.dart';
import '../Component/show_pop_up.dart';
import '../Login Page/login_page.dart';

class SignupContent extends StatefulWidget {
  const SignupContent({super.key});

  @override
  State<SignupContent> createState() => _SignupContentState();
}

class _SignupContentState extends State<SignupContent> {
  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      builder: (controller) {
        ResponsivePaddingWidth responsive = ResponsivePaddingWidth(context);

        bool isUpdating = controller.userDetails != null;

        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: responsive.padding),
            child: Form(
              key: controller.formKey,
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
                    CustomTitleText(
                        text: isUpdating ? "Update Your Account" : "Create Your Account"),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Name",
                      icon: Icons.person,
                      controller: controller.nameController,
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      controller: controller.phoneController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Email",
                      icon: Icons.email,
                      controller: controller.emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Password",
                      icon: Icons.lock,
                      controller: controller.passwordController,
                      isObscure: true,
                      validator: (value) {
                        if (!isUpdating && (value == null || value.isEmpty)) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Date of Birth",
                      icon: Icons.calendar_today,
                      controller: controller.dobController,
                      readOnly: true,
                      isDateField: true, // Triggers the date picker on tap
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Anniversary Date",
                      icon: Icons.calendar_today,
                      controller: controller.anniversaryController,
                      readOnly: true,
                      isDateField: true,
                    ),
                    const SizedBox(height: 30),

                    // Show "Update" button if user details exist, otherwise "Sign Up"
                    GradientButton(
                      text: isUpdating ? "Update" : "Sign Up",
                      onPressed: () => isUpdating
                          ? controller.updateUserDetails(context)
                          : controller.submitForm(context),
                    ),
                    const SizedBox(height: 20),

                    if (!isUpdating) // Show login redirection only for new users
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextWidgets.alreadyHaveAccountText(),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Close signup page
                                PopupDialog(
                                  parentContext: context,
                                  childWidget: const LoginPage(),
                                ).show(); // Show login popup
                              },
                              child: CustomTextWidgets.signIn(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
