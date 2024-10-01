import 'package:flutter/material.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/view_model/suppliers/supplier_orders_history_view_model.dart';
import 'package:printing_press/views/payment/payment_view.dart';
import 'package:provider/provider.dart';

import '../../colors/color_palette.dart';
import '../../model/payment.dart';
import '../../model/stock_order_to_supplier.dart';

class SupplierOrdersHistoryView extends StatefulWidget {
  const SupplierOrdersHistoryView({
    super.key,
    required this.supplierId,
    required this.totalAmount,
    required this.remainingAmount,
    required this.paidAmount,
  });

  final int supplierId;
  final int totalAmount;
  final int remainingAmount;
  final int paidAmount;

  @override
  State<SupplierOrdersHistoryView> createState() =>
      _SupplierOrdersHistoryViewState();
}

class _SupplierOrdersHistoryViewState extends State<SupplierOrdersHistoryView> {
  late SupplierOrdersHistoryViewModel stockOrderedFromSupplierViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint('Supplier Id: ${widget.supplierId}');

    stockOrderedFromSupplierViewModel =
        Provider.of<SupplierOrdersHistoryViewModel>(context, listen: false);
    stockOrderedFromSupplierViewModel
        .fetchAllSuppliersOrdersHistory(widget.supplierId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock ordered history!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<SupplierOrdersHistoryViewModel>(
          builder: (context, value, child) => value.dataFetched
              ? value.allStockOrderHistoryList.isEmpty
                  ? const Center(
                      child: Text('No record found!'),
                    )

                  ///todo: change listview.builder to streams builder, add a button to add the payment transaction
                  : Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total'),
                            Text('Paid'),
                            Text('Remaining'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${widget.totalAmount}'),
                            Text('${widget.paidAmount}'),
                            Text('${widget.remainingAmount}'),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: value.allStockOrderHistoryList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (value.allStockOrderHistoryList[index]
                                  is Payment) {
                                /// todo: change the list tile to custom design
                                return ListTile(
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                  shape:
                                      Border.all(width: 2, color: kPrimeColor),
                                  // titleAlignment: ListTileTitleAlignment.threeLine,
                                  titleTextStyle: TextStyle(
                                      color: kThirdColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  title: Text(value
                                      .allStockOrderHistoryList[index]
                                      .description),
                                  tileColor: kSecColor,
                                  subtitleTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic),
                                  subtitle: Text(
                                    'Payment Method: ${value.allStockOrderHistoryList[index].paymentMethod}\nAmount: ${value.allStockOrderHistoryList[index].amount}',
                                  ),
                                  leading: Text(value
                                      .allStockOrderHistoryList[index].paymentId
                                      .toString()),
                                );
                              } else if (value.allStockOrderHistoryList[index]
                                  is StockOrderToSupplier) {
                                /// todo: change the list tile to custom design
                                return ListTile(
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                  shape:
                                      Border.all(width: 2, color: kPrimeColor),
                                  // titleAlignment: ListTileTitleAlignment.threeLine,
                                  titleTextStyle: TextStyle(
                                      color: kThirdColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  title: Text(value
                                      .allStockOrderHistoryList[index]
                                      .stockName),
                                  tileColor: kTwo,
                                  subtitleTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic),
                                  subtitle: Text(
                                    'Stock Category: ${value.allStockOrderHistoryList[index].stockCategory}\nTotal: ${value.allStockOrderHistoryList[index].totalAmount}',
                                  ),
                                  leading: Text(value
                                      .allStockOrderHistoryList[index]
                                      .stockQuantity
                                      .toString()),
                                );
                              } else {
                                return Center(
                                  child: Text('Some error !'),
                                );
                              }
                            },
                          ),
                        ),
                        RoundButton(
                            title: 'Payment',
                            onPress: () {
                              /// this button is disappear if the supplier has no orders
                              ///todo: this will add the payment in the stock order history + it will add in the cashbook as well
                              ///todo: reduce the amount from the supplier total amount, add it into the paid amount, calculate the remaining amount
                              ///todo: this payment has to be shown in the stock order history view as well, but in red color or any color other than the stock order history tile colors
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PaymentView(supplierId: widget.supplierId),
                              ));
                            }),
                      ],
                    )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
