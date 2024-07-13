import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';

class RoundButton extends StatelessWidget {
   const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
    this.unFill = false,
  });

  final bool unFill;
  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: unFill ? Colors.transparent : kOne,
            borderRadius: BorderRadius.circular(8)),
        child: Text(
                title,
                style: TextStyle(
                  color: unFill ? kOne : kSecColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
      ),
    );
  }
}
