import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';

class CustomCircularIndicator extends StatelessWidget {
  const CustomCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: kNew4,
    ));
  }
}
