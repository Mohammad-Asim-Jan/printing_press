import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';

class CustomRadioListTile extends StatefulWidget {
  CustomRadioListTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,

  });

  final int value;
  int groupValue;
  final void Function(int? s)? onChanged;
  final String title;

  @override
  State<CustomRadioListTile> createState() => _CustomRadioListTileState();
}

class _CustomRadioListTileState extends State<CustomRadioListTile> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 120,
      child: RadioListTile<int>(
        value: widget.value,
        splashRadius: 25.0,
        groupValue: widget.groupValue,
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        activeColor: kOne,
        contentPadding: const EdgeInsets.all(0),
        onChanged: widget.onChanged,
      ),
    );
  }
}
