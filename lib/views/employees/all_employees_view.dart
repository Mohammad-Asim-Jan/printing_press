import 'package:flutter/material.dart';

class AllEmployeesView extends StatefulWidget {
  const AllEmployeesView({super.key});

  @override
  State<AllEmployeesView> createState() => _AllEmployeesViewState();
}

class _AllEmployeesViewState extends State<AllEmployeesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Employees'),
      ),
      body: const Center(
        child: Text('TODO.....'),
      ),
    );
  }
}
