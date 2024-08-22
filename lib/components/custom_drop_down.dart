import 'package:flutter/material.dart';

import '../colors/color_palette.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({
    super.key,
    required this.list,
    required this.hint,
    required this.onChanged,
    required this.value,
  });

  List<String> list = [];
  String hint;
  final void Function(String? s)? onChanged;
  String value;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 140,
      child: DropdownButtonFormField<String>(
          dropdownColor: kSecColor,
          decoration: InputDecoration(
            // prefixIcon: const Icon(
            //   Icons.design_services_outlined,
            //   size: 30,
            // ),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 2,
                color: kPrimeColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: kSecColor,
              ),
            ),
          ),
          // isExpanded: true,
          // selectedItemBuilder: (context) {
          //   if (_selectedLocation == 'A') {
          //     return [const Text('You have selected a')];
          //   }
          //   return [];
          // },
          // style: ,
          value: widget.value,
          items: widget.list.map((String val) {
            return DropdownMenuItem<String>(
              alignment: Alignment.center,
              value: val,
              child: Text(
                val,
              ),
            );
          }).toList(),
          hint: Text(widget.hint),
          onChanged: widget.onChanged
      ),
    );
  }
}
