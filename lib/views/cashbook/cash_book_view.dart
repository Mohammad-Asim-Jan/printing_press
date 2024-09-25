import 'package:flutter/material.dart';

class CashBookView extends StatefulWidget {
  const CashBookView({super.key});

  @override
  State<CashBookView> createState() => _CashBookViewState();
}

class _CashBookViewState extends State<CashBookView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: const Text('Cashbook'),),
    );
  }
}
