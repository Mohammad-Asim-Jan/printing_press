import 'package:flutter/material.dart';
import '../colors/color_palette.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hint;
  final TextInputType textInputType;
  final String validatorText;

  const CustomTextField({
    super.key,
     required this.controller,
    required this.iconData,
    required this.hint,
    required this.validatorText,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      cursorColor: kPrimeColor,
      decoration: InputDecoration(
        prefixIcon: Icon(
          iconData,
          size: 24,
        ),
        hintText: hint,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            width: 2,
            color: kPrimeColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kSecColor,
          ),
        ),
      ),
      validator: (text) {
        if (text == '' || text == null) {
          return validatorText;
        }
        return null;
      },
    );
  }
}
