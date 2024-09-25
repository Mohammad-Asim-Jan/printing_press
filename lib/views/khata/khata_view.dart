import 'package:flutter/material.dart';

class KhataView extends StatefulWidget {
  const KhataView({super.key});

  @override
  State<KhataView> createState() => _KhataViewState();
}

class _KhataViewState extends State<KhataView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khata'),
      ),
    );
  }
}
