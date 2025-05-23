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
    return InkWell(
      onTap: widget.loading ? null : widget.onPress,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.unFill ? Colors.transparent : kNew7,
            borderRadius: BorderRadius.circular(8),
            border: widget.unFill ? Border.all(width: 2, color: kNew7) : null),
        child: widget.loading
            ? CircularProgressIndicator(

                color: widget.unFill ? kOne : kTwo,
                backgroundColor: widget.unFill ? kTwo : kOne,
              )
            : Text(
                widget.title,
                style: TextStyle(
                  color: widget.unFill ? kNew7 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}
