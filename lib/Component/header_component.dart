// build_action_item.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionItem extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final String? fontFamily;

  const ActionItem({
    super.key,
    required this.title,
    required this.fontSize,
    required this.fontWeight,
    this.textColor = Colors.black,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
        fontFamily: fontFamily ??
            GoogleFonts.cinzel()
                .fontFamily, // A more elegant and welcoming font // Static default font family
      ),
    );
  }
}
