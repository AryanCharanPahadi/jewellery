import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle({
  FontWeight fontWeight = FontWeight.bold,  // Default font weight
  double fontSize = 18.0,                    // Default font size
  Color color = Colors.black,               // Default text color
  String? fontFamily,                        // Font family can be overridden
}) {
  return TextStyle(
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,                            // Ensure a non-null color is passed
    fontFamily: fontFamily ?? GoogleFonts.cinzel().fontFamily, // Default to Cinzel if no fontFamily provided
  );
}
