import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/views/rate_list/binding/add_binding_view.dart';

class BindingView extends StatefulWidget {
  const BindingView({super.key});

  @override
  State<BindingView> createState() => _BindingViewState();
}

class _BindingViewState extends State<BindingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddBindingView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar:
      AppBar(
        title: const Text('Binding'),
      ),
    );
  }
}
