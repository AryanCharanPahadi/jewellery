import 'package:flutter/material.dart';
import 'package:jewellery/Login%20Page/login_page.dart';
import 'package:jewellery/Sign%20Up/sign_up.dart';
import '../../Component/show_pop_up.dart';
import '../../Component/text_style.dart';
import '../../Shared Preferences/shared_preferences_helper.dart';

class UserDetailsCard extends StatelessWidget {
  const UserDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: SharedPreferencesHelper.getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No user details found',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          );
        }

        final userDetails = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.red.shade300, width: 1),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isSmallScreen = constraints.maxWidth <= 400;

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Personal Information", style: getTextStyle()),
                            if (isSmallScreen)
                              const SizedBox(
                                  height: 8), // Space between text and button
                            Align(
                              alignment: isSmallScreen
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (context.mounted) {
                                      PopupDialog(parentContext: context, childWidget: SignupContent())
                                          .show();
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red.shade700,
                                  side: BorderSide(color: Colors.red.shade700),
                                ),
                                child: Text(
                                  "Edit Details",
                                  style: getTextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isLargeScreen = constraints.maxWidth > 600;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserDetailRow(
                              label: "Name",
                              value: userDetails['name'],
                              isLargeScreen: isLargeScreen,
                            ),
                            UserDetailRow(
                              label: "Date of Birth",
                              value: userDetails['date_of_birth'],
                              isLargeScreen: isLargeScreen,
                            ),
                            UserDetailRow(
                              label: "Anniversary Date",
                              value: userDetails['anniversary_date'],
                              isLargeScreen: isLargeScreen,
                            ),
                            UserDetailRow(
                              label: "Phone Number",
                              value: userDetails['phone'],
                              isLargeScreen: isLargeScreen,
                            ),
                            UserDetailRow(
                              label: "Email Address",
                              value: userDetails['email'],
                              isLargeScreen: isLargeScreen,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserDetailRow extends StatelessWidget {
  final String label;
  final dynamic value;
  final bool isLargeScreen;

  const UserDetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.isLargeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isLargeScreen ? 2 : 3,
            child: Text("$label :",
                style: getTextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: isLargeScreen ? 18 : 16,
                )),
          ),
          Expanded(
            flex: isLargeScreen ? 4 : 5,
            child: Text(value ?? 'N/A',
                style: getTextStyle(
                  fontSize: isLargeScreen ? 18 : 16,
                )),
          ),
        ],
      ),
    );
  }
}
