import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final BuildContext parentContext;
  final Widget childWidget;

  const PopupDialog({super.key, required this.parentContext, required this.childWidget});

  void show() {
    showDialog(
      context: parentContext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: childWidget,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Just a placeholder, not used since it's only for the show method.
  }
}
