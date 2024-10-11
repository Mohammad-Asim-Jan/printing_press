import 'package:flutter/material.dart';
import 'package:printing_press/model/stock.dart';

class StockDetailsView extends StatefulWidget {
  const StockDetailsView({
    super.key,
    required this.stock,
  });

  final Stock stock;

  @override
  State<StockDetailsView> createState() => _StockDetailsViewState();
}

class _StockDetailsViewState extends State<StockDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Details'),
      ),
      body: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Stock Id: '),
              Text('Name: '),
              Text('Stock Quantity: '),
              Text('Description: '),
              Text('Category: '),
              Text('Buy Price:: '),
              Text('Sell Price: '),
              Text('Available Stock: '),
              Text('Total Amount: '),
              Text('Color: '),
              Text('Manufactured By : '),
              Text('Supplier Id: '),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.stock.stockId}'),
              Text(widget.stock.stockName),
              Text('${widget.stock.stockQuantity}'),
              Text(widget.stock.stockDescription),
              Text(widget.stock.stockCategory),
              Text('${widget.stock.stockUnitBuyPrice}'),
              Text('${widget.stock.stockUnitSellPrice}'),
              Text('${widget.stock.availableStock}'),
              Text('${widget.stock.totalAmount}'),
              Text(widget.stock.stockColor),
              Text(widget.stock.manufacturedBy),
              Text('${widget.stock.supplierId}'),
            ],
          ),
        ],
      ),
    );
  }
}
