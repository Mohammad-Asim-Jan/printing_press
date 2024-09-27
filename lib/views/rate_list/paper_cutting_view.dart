import 'package:flutter/material.dart';

class PaperCuttingView extends StatefulWidget {
  const PaperCuttingView({super.key});

  @override
  State<PaperCuttingView> createState() => _PaperCuttingViewState();
}

class _PaperCuttingViewState extends State<PaperCuttingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paper Cutting'),
      ),
    );
  }
}
