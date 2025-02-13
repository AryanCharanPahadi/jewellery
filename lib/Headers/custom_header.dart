import 'package:flutter/material.dart';
import '../Component/header_component.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine font size based on screen width
    double fontSize = screenWidth <= 200
        ? 10
        : screenWidth <= 250
        ? 12
        : screenWidth <= 300
        ? 14
        : screenWidth > 600
        ? 18
        : 16; // Adjust font size for smaller screens

    double actionItemFontSize = screenWidth <= 200
        ? 8
        : screenWidth <= 250
        ? 10
        : screenWidth <= 300
        ? 12
        : screenWidth > 600
        ? 14
        : 12; // Adjust font size for smaller screens

    // Padding adjustments for small screens
    double horizontalPadding = screenWidth <= 200
        ? 6
        : screenWidth <= 250
        ? 8
        : screenWidth <= 300
        ? 12
        : 16;

    double itemSpacing = screenWidth <= 200
        ? 8
        : screenWidth <= 250
        ? 10
        : 16;

    return Column(
      children: [
        // Header Container
        Container(
          color: Colors.grey[100], // Soft background color
          height: 56,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side: Logo/Brand Name
                ActionItem(
                  title: "Dazzle Den", // Brand name
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.black,
                ),
                const Spacer(),
                // Right Side: Menu Items
                Row(
                  children: [
                    ActionItem(
                      title: "ABOUT US",
                      fontSize: actionItemFontSize,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.black54,
                    ),
                    SizedBox(width: itemSpacing),
                    ActionItem(
                      title: "CONTACT US",
                      fontSize: actionItemFontSize,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
