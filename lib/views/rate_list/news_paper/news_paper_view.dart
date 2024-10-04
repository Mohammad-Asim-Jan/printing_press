import 'package:flutter/material.dart';

class NewsPaperView extends StatefulWidget {
  const NewsPaperView({super.key});

  @override
  State<NewsPaperView> createState() => _NewsPaperViewState();
}

class _NewsPaperViewState extends State<NewsPaperView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('News Paper'),),);
  }
}
