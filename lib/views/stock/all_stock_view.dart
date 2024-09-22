import 'package:flutter/material.dart';
import 'package:printing_press/views/stock/add_stock_view.dart';

import '../../colors/color_palette.dart';

class AllStockView extends StatefulWidget {
  const AllStockView({super.key});

  @override
  State<AllStockView> createState() => _AllStockViewState();
}

class _AllStockViewState extends State<AllStockView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddStockView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('All Stock'),
      ),
      body: const Center(child: Text('No stock Found')),
    );
  }
}
