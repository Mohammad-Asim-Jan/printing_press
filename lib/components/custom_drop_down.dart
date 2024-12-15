import 'package:flutter/material.dart';

import '../colors/color_palette.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    super.key,
    required this.list,
    required this.hint,
    required this.onChanged,
    required this.value,
    required this.validator,
     this.prefixIconData,
  });

  List<String> list = [];
  String hint;
  final IconData? prefixIconData;

  /// todo: can be used as a label or something
  final void Function(String? s)? onChanged;
  String value;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SizedBox(
            height: 45,
            child: DropdownButtonFormField<String>(
                icon: Icon(Icons.expand_more_rounded, size: 15),
                validator: validator,
                dropdownColor: Colors.blueGrey.shade50,
                style: TextStyle(
                    fontSize: 12,
                    color: kNew12,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
                decoration: InputDecoration(
                    prefixIcon:
                        prefixIconData == null ? null : Icon(prefixIconData, size: 16,),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2, color: kPrimeColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kNew9a))),
                isExpanded: true,
                value: value,
                iconEnabledColor: kNew12,
                items: list.map((String val) {
                  return DropdownMenuItem<String>(
                      alignment: Alignment.centerLeft,
                      value: val,
                      child: Text(val));
                }).toList(),
                hint: Text(hint),
                onChanged: onChanged)));
  }
}
