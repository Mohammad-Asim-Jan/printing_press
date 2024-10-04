import 'package:flutter/material.dart';

class AddCashbookEntryView extends StatefulWidget {
  const AddCashbookEntryView({super.key});

  @override
  State<AddCashbookEntryView> createState() => _AddCashbookEntryViewState();
}

class _AddCashbookEntryViewState extends State<AddCashbookEntryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cashbook Entry'),),
      body: Center(child: Text('TODO'),),
    );
  }
}
