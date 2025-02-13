import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isObscure;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isDateField;
  final bool isNumberField; // New parameter for number-only input

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.validator,
    this.isObscure = false,
    this.readOnly = false,
    this.onTap,
    this.isDateField = false,
    this.isNumberField = false, // Defaults to false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator ?? (value) {
        if (isNumberField && value != null && value.isNotEmpty) {
          int? number = int.tryParse(value);
          if (number == null || number < 1 || number > 5) {
            return 'Please enter a number between 1 and 5';
          }
        }
        return null;
      },
      obscureText: isObscure,
      readOnly: readOnly,
      keyboardType: isNumberField ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumberField
          ? [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.allow(RegExp(r'^[1-5]$|^5$')),
      ]
          : [],
      onTap: () async {
        if (isDateField) {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            controller.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
          }
        } else if (onTap != null) {
          onTap!();
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}