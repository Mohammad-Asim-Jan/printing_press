import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';

class RoundButton extends StatefulWidget {
  const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
    this.unFill = false,
    this.loading = false,
  });

  final bool loading;
  final bool unFill;
  final String title;
  final VoidCallback onPress;

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? const CircularProgressIndicator(color: Colors.red)
        : InkWell(
            onTap: widget.onPress,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: widget.unFill ? Colors.transparent : kOne,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: widget.unFill ? kOne : kSecColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          );
  }
}
