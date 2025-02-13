import 'package:flutter/material.dart';
import 'package:jewellery/Component/text_style.dart';

class TextContainer extends StatelessWidget {
  final String title;

  const TextContainer({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen or parent container
    final double screenWidth = MediaQuery.of(context).size.width;

    // Determine font size based on screen width
    double fontSize;
    if (screenWidth <= 150) {
      fontSize = 16.0;
    } else if (screenWidth <= 200) {
      fontSize = 18.0;
    } else if (screenWidth <= 250) {
      fontSize = 22.0;
    } else if (screenWidth <= 300) {
      fontSize = 24.0;
    } else {
      fontSize = 28.0; // Default size
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0, vertical: 4.0), // Adjust padding for better spacing
      color: Colors.white,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: getTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
