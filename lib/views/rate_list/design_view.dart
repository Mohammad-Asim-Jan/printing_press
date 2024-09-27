import 'package:flutter/material.dart';

class DesignView extends StatefulWidget {
  const DesignView({super.key});

  @override
  State<DesignView> createState() => _DesignViewState();
}

class _DesignViewState extends State<DesignView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Design'),),);
  }
}
