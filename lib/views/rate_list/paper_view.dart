import 'package:flutter/material.dart';

class PaperView extends StatefulWidget {
  const PaperView({super.key});

  @override
  State<PaperView> createState() => _PaperViewState();
}

class _PaperViewState extends State<PaperView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Paper'),),);
  }
}
