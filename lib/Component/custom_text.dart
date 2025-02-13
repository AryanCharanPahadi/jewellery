import 'package:flutter/material.dart';

class CustomTitleText extends StatelessWidget {
  final String text;

  const CustomTitleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
