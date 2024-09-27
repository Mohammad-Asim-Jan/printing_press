import 'package:flutter/material.dart';

class NumberingView extends StatefulWidget {
  const NumberingView({super.key});

  @override
  State<NumberingView> createState() => _NumberingViewState();
}

class _NumberingViewState extends State<NumberingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Numbering'),),);
  }
}
