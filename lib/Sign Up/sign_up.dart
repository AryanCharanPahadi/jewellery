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
    return LayoutBuilder(
      builder: (context, constraints) {
        ResponsivePaddingWidth responsive = ResponsivePaddingWidth(context);

        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: responsive.padding),
            child: Form(
              key: signupController.formKey,
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
                    const CustomTitleText(text: "Create Your Account"),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Name",
                      icon: Icons.person,
                      controller: signupController.nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      controller: signupController.phoneController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Email",
                      icon: Icons.email,
                      controller: signupController.emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Password",
                      icon: Icons.lock,
                      controller: signupController.passwordController,
                      isObscure: true,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Date of Birth",
                      icon: Icons.calendar_today,
                      controller: signupController.dobController,
                      readOnly: true,
                      isDateField:
                          true, // This makes it trigger the date picker on tap
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Anniversary Date",
                      icon: Icons.calendar_today,
                      controller: signupController
                          .anniversaryController, // Dynamic controller
                      readOnly:
                          true, // Makes it read-only, so the user can't type in it
                      isDateField:
                          true, // This makes it trigger the date picker on tap
                    ),
                    const SizedBox(height: 30),
                    GradientButton(
                      text: "Sign Up",
                      onPressed: () => signupController.submitForm(context),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWidgets.alreadyHaveAccountText(),
                          const SizedBox(height: 10),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Close the login page

                                PopupDialog(
                                  parentContext: context,
                                  childWidget: const LoginPage(),
                                ).show(); // Show signup popup
                              },
                              child: CustomTextWidgets.signIn()),
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
