import 'package:flutter/material.dart';

class ProfitView extends StatefulWidget {
  const ProfitView({super.key});

  @override
  State<ProfitView> createState() => _ProfitViewState();
}

class _ProfitViewState extends State<ProfitView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit'),
      ),
    );
  }
}
