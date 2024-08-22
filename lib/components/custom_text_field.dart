import 'package:flutter/material.dart';
import '../colors/color_palette.dart';

class CustomTextField extends StatefulWidget {
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      cursorColor: kPrimeColor,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.iconData,
          size: 24,
        ),
        hintText: widget.hint,
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
          return widget.validatorText;
        }
        return null;
      },
    );
  }
}
