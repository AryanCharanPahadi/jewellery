import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jewellery/Component/show_pop_up.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../Component/text_style.dart';
import '../Login Page/login_page.dart';
import '../Shared Preferences/shared_preferences_helper.dart';

class ResponsiveFooter extends StatefulWidget {
  const ResponsiveFooter({super.key});

  @override
  State<ResponsiveFooter> createState() => _ResponsiveFooterState();
}

class _ResponsiveFooterState extends State<ResponsiveFooter> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    double columnWidth = screenWidth > 800
        ? screenWidth / 4 - 24
        : screenWidth > 400
            ? screenWidth / 2 - 24
            : screenWidth - 48;

    double textSize = screenWidth <= 200
        ? 8
        : screenWidth <= 250
            ? 10
            : screenWidth <= 300
                ? 12
                : 14;
    double iconSize = textSize + 6;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
          vertical: screenWidth <= 250 ? 12 : 18, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 28,
              runSpacing: 22,
              children: [
                _buildSection(
                    "NEED HELP",
                    [
                      {"icon": Icons.local_shipping, "text": "Track Order"},
                      {"icon": Icons.undo, "text": "Returns & Refunds"},
                      {"icon": Icons.help_outline, "text": "FAQs"},
                      {"icon": Icons.account_circle, "text": "My Account"},
                    ],
                    columnWidth,
                    textSize,
                    iconSize),
                _buildSection(
                    "Contact Us",
                    [
                      {"icon": Icons.mail, "text": "Write to Us"},
                      {"icon": Icons.phone, "text": "+91 99900 29241"},
                    ],
                    columnWidth,
                    textSize,
                    iconSize),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                  FontAwesomeIcons.instagram, Colors.purple, iconSize),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            "© 2025 DazzleDen. All rights reserved.",
            style: getTextStyle(
              fontSize: textSize,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items,
      double width, double textSize, double iconSize) {
    List<bool> hoverStates = List.generate(items.length, (index) => false);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textSize + 4,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) {
                  setState(() {
                    hoverStates[index] = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    hoverStates[index] = false;
                  });
                },
                child: GestureDetector(
                  onTap: () async {
                    print("Clicked on: ${item["text"]}");

                    if (item["text"] == "Write to Us") {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'dazzleden.website@gmail.com',
                        queryParameters: {'subject': 'Customer Inquiry'},
                      );
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        print("Could not launch email app.");
                      }
                    } else if (item["text"] == "+91 99900 29241") {
                      final Uri phoneLaunchUri = Uri(
                        scheme: 'tel',
                        path: '+919990029241',
                      );
                      if (await canLaunchUrl(phoneLaunchUri)) {
                        await launchUrl(phoneLaunchUri);
                      } else {
                        print("Could not launch phone dialer.");
                      }
                    } else if (item["text"] == "My Account") {
                      bool isLoggedIn =
                          await LoginStatusHelper().checkLoginStatus();
                      if (isLoggedIn) {
                        context.go('/user-details'); // Navigate to user profile
                      } else {
                        PopupDialog(
                                parentContext: context,
                                childWidget: LoginPage())
                            .show();
                      }
                    } else if (item["text"] == "FAQs") {
                      context.go("/faqs");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Icon(item["icon"],
                            color: Colors.brown[800], size: iconSize),
                        const SizedBox(width: 10),
                        Text(
                          item["text"],
                          style: getTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: textSize,
                            color: hoverStates[index]
                                ? Colors.red
                                : (Colors.black ?? Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, double iconSize) {
    return GestureDetector(
      onTap: () async {
        final Uri instagramUrl = Uri.parse(
            "https://www.instagram.com/dazzle_den_11/?igsh=MXRpZGJrZXVpNDZrdw%3D%3D");
        if (await canLaunchUrl(instagramUrl)) {
          await launchUrl(instagramUrl, mode: LaunchMode.externalApplication);
        } else {
          print("Could not launch Instagram.");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: iconSize),
        ),
      ),
    );
  }
}
