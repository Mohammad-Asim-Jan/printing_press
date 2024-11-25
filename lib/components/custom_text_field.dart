import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors/color_palette.dart';

typedef ValidatorFunction = String? Function(String?);

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData? iconData;
  final String hint;
  final TextInputType textInputType;
  final List<ValidatorFunction>? validators;
  final int? maxLength;
  final TextInputFormatter? inputFormatter;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.iconData,
    this.maxLength,
    required this.hint,
    this.textInputType = TextInputType.text,
    this.inputFormatter,
    this.validators,
  });

  String? _validate(String? value) {
    if (validators != null) {
      if (validators!.isNotEmpty) {
        for (var validator in validators!) {
          final result = validator(value);
          if (result != null) return result; // Return the error if found
        }
      }
    }
    return null; // No errors
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        maxLength: widget.maxLength,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        cursorColor: kPrimeColor,
        inputFormatters: widget.inputFormatter == null
            ? null
            : <TextInputFormatter>[
                widget.inputFormatter!,
              ],
        decoration: InputDecoration(
          labelText: widget.hint,
          prefixIcon: Icon(
            widget.iconData,
            size: 24,
          ),
          hintText: widget.hint,
          labelStyle: TextStyle(color: kPrimeColor),
          hintStyle: TextStyle(color: kNew9a),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 2,
              // color: kNew9a,
              color: kPrimeColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: kNew9a,
            ),
          ),
        ),
        validator: widget._validate,
      ),
    );
  }
}
