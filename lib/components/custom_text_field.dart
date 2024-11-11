import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/utils/email_validation.dart';
import '../colors/color_palette.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hint;
  final TextInputType textInputType;
  final String validatorText;
  final int? maxLength;
  final TextInputFormatter? inputFormatter;
  final bool? emailValidation;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.iconData,
    this.maxLength,
    required this.hint,
    required this.validatorText,
    this.emailValidation,
    this.textInputType = TextInputType.text,
    this.inputFormatter,
    });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
          } else if(widget.emailValidation == true ? !EmailValidation.isEmailValid(text): false){
            return 'Invalid Email';
          }
          return null;
        },
      ),
    );
  }
}
