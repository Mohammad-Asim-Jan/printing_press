import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/components/custom_circular_indicator.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/model/cashbook_entry.dart';
import 'package:printing_press/view_model/suppliers/supplier_orders_history_view_model.dart';
import 'package:printing_press/views/payment/payment_view.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import '../../model/stock_order_history_to_supplier.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock ordered history!'),
      ),
      body: Column(
        children: [
          Container(
            color: kSecColor,
            child: Column(
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
              ],
            ),
          ),
          Consumer<SupplierOrdersHistoryViewModel>(
            builder: (context, value, child) {
              return Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: value.geSupplierOrderHistoryData(widget.supplierId),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CustomCircularIndicator();
                      }
                
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                
                      if (snapshot.hasData) {
                        value.allSupplierStockOrderHistoryList =
                            snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data = e.data();
                
                          if (data['stockId'] == null) {
                            /// Here there is a payment document
                            return CashbookEntry.fromJson(data);
                          } else {
                            /// Here there is a stock order document
                            return StockOrderHistoryToSupplier.fromJson(data);
                          }
                        }).toList();
                
                        if (value.allSupplierStockOrderHistoryList.isEmpty) {
                          return const Center(
                            child: Text('No entry found!'),
                          );
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    value.allSupplierStockOrderHistoryList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (value
                                          .allSupplierStockOrderHistoryList[index]
                                      is CashbookEntry) {
                                    CashbookEntry cashbookEntry = value
                                        .allSupplierStockOrderHistoryList[index];

                                    /// todo: change the list tile to custom design
                                    /// todo: add more details as well after clicking on it
                                    return ListTile(
                                      // trailing: SizedBox(
                                      //   width: 100,
                                      //   child: Row(
                                      //     children: [
                                      //       IconButton(
                                      //         icon: const Icon(Icons.edit),
                                      //         onPressed: () {},
                                      //       ),
                                      //       IconButton(
                                      //         icon: const Icon(Icons.delete),
                                      //         onPressed: () {},
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      shape: Border.all(
                                          width: 2, color: kPrimeColor),
                                      // titleAlignment: ListTileTitleAlignment.threeLine,
                                      titleTextStyle: TextStyle(
                                          color: kThirdColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      title: Text(cashbookEntry.description ??
                                          'No description'),
                                      tileColor: kSecColor,
                                      subtitleTextStyle: const TextStyle(
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic),
                                      subtitle: Text(
                                        'Payment Method: ${cashbookEntry.paymentMethod}\nAmount: ${cashbookEntry.amount}',
                                      ),
                                      leading: Text(cashbookEntry.newStockOrderId
                                          .toString()),
                                    );
                                  } else if (value
                                          .allSupplierStockOrderHistoryList[index]
                                      is StockOrderHistoryToSupplier) {
                                    StockOrderHistoryToSupplier
                                        stockOrderHistoryToSupplier =
                                        value.allSupplierStockOrderHistoryList[
                                            index];

                                    /// todo: change the list tile to custom design
                                    /// todo: add more details as well after clicking on it
                                    return ListTile(
                                      // trailing: SizedBox(
                                      //   width: 100,
                                      //   child: Row(
                                      //     children: [
                                      //       IconButton(
                                      //         icon: const Icon(Icons.edit),
                                      //         onPressed: () {},
                                      //       ),
                                      //       IconButton(
                                      //         icon: const Icon(Icons.delete),
                                      //         onPressed: () {},
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      shape: Border.all(
                                          width: 2, color: kPrimeColor),
                                      // titleAlignment: ListTileTitleAlignment.threeLine,
                                      titleTextStyle: TextStyle(
                                          color: kThirdColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      title: Text(
                                          stockOrderHistoryToSupplier.stockName),
                                      tileColor: kTwo,
                                      subtitleTextStyle: const TextStyle(
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic),
                                      subtitle: Text(
                                        'Stock Category: ${stockOrderHistoryToSupplier.stockCategory}\nTotal: ${stockOrderHistoryToSupplier.totalAmount}',
                                      ),
                                      leading: Text(stockOrderHistoryToSupplier
                                          .stockQuantity
                                          .toString()),
                                    );
                                  } else {
                                    return const Center(
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PaymentView(
                                        supplierId: widget.supplierId),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                
                      return const Text('No data!');
                    }),
              );

              // value.dataFetched
              //     ? value.allStockOrderHistoryList.isEmpty
              //         ? const Center(
              //             child: Text('No record found!'),
              //           )
              //         ///todo: change listview.builder to streams builder, add a button to add the payment transaction
              //         : Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Column(
              //               children: [
              //                 const SizedBox(
              //                   height: 15,
              //                 ),
              //                 Expanded(
              //                   child: ListView.builder(
              //                     itemCount: value.allStockOrderHistoryList.length,
              //                     itemBuilder: (BuildContext context, int index) {
              //                       if (value.allStockOrderHistoryList[index]
              //                           is CashbookEntry) {
              //                         CashbookEntry cashbookEntry =
              //                             value.allStockOrderHistoryList[index];
              //
              //                         /// todo: change the list tile to custom design
              //                         /// todo: add more details as well after clicking on it
              //                         return ListTile(
              //                           // trailing: SizedBox(
              //                           //   width: 100,
              //                           //   child: Row(
              //                           //     children: [
              //                           //       IconButton(
              //                           //         icon: const Icon(Icons.edit),
              //                           //         onPressed: () {},
              //                           //       ),
              //                           //       IconButton(
              //                           //         icon: const Icon(Icons.delete),
              //                           //         onPressed: () {},
              //                           //       ),
              //                           //     ],
              //                           //   ),
              //                           // ),
              //                           shape:
              //                               Border.all(width: 2, color: kPrimeColor),
              //                           // titleAlignment: ListTileTitleAlignment.threeLine,
              //                           titleTextStyle: TextStyle(
              //                               color: kThirdColor,
              //                               fontSize: 18,
              //                               fontWeight: FontWeight.w500),
              //                           title: Text(cashbookEntry.description ??
              //                               'No description'),
              //                           tileColor: kSecColor,
              //                           subtitleTextStyle: const TextStyle(
              //                               color: Colors.black,
              //                               fontStyle: FontStyle.italic),
              //                           subtitle: Text(
              //                             'Payment Method: ${cashbookEntry.paymentMethod}\nAmount: ${cashbookEntry.amount}',
              //                           ),
              //                           leading: Text(
              //                               cashbookEntry.newStockOrderId.toString()),
              //                         );
              //                       } else if (value.allStockOrderHistoryList[index]
              //                           is StockOrderHistoryToSupplier) {
              //                         StockOrderHistoryToSupplier
              //                             stockOrderHistoryToSupplier =
              //                             value.allStockOrderHistoryList[index];
              //
              //                         /// todo: change the list tile to custom design
              //                         /// todo: add more details as well after clicking on it
              //                         return ListTile(
              //                           // trailing: SizedBox(
              //                           //   width: 100,
              //                           //   child: Row(
              //                           //     children: [
              //                           //       IconButton(
              //                           //         icon: const Icon(Icons.edit),
              //                           //         onPressed: () {},
              //                           //       ),
              //                           //       IconButton(
              //                           //         icon: const Icon(Icons.delete),
              //                           //         onPressed: () {},
              //                           //       ),
              //                           //     ],
              //                           //   ),
              //                           // ),
              //                           shape:
              //                               Border.all(width: 2, color: kPrimeColor),
              //                           // titleAlignment: ListTileTitleAlignment.threeLine,
              //                           titleTextStyle: TextStyle(
              //                               color: kThirdColor,
              //                               fontSize: 18,
              //                               fontWeight: FontWeight.w500),
              //                           title: Text(
              //                               stockOrderHistoryToSupplier.stockName),
              //                           tileColor: kTwo,
              //                           subtitleTextStyle: const TextStyle(
              //                               color: Colors.black,
              //                               fontStyle: FontStyle.italic),
              //                           subtitle: Text(
              //                             'Stock Category: ${stockOrderHistoryToSupplier.stockCategory}\nTotal: ${stockOrderHistoryToSupplier.totalAmount}',
              //                           ),
              //                           leading: Text(stockOrderHistoryToSupplier
              //                               .stockQuantity
              //                               .toString()),
              //                         );
              //                       } else {
              //                         return const Center(
              //                           child: Text('Some error !'),
              //                         );
              //                       }
              //                     },
              //                   ),
              //                 ),
              //                 const SizedBox(
              //                   height: 15,
              //                 ),
              //                 RoundButton(
              //                     title: 'Payment',
              //                     onPress: () {
              //                       /// this button is disappear if the supplier has no orders
              //                       ///todo: this will add the payment in the stock order history + it will add in the cashbook as well
              //                       ///todo: reduce the amount from the supplier total amount, add it into the paid amount, calculate the remaining amount
              //                       ///todo: this payment has to be shown in the stock order history view as well, but in red color or any color other than the stock order history tile colors
              //                       Navigator.of(context).push(MaterialPageRoute(
              //                         builder: (context) =>
              //                             PaymentView(supplierId: widget.supplierId),
              //                       ));
              //                     }),
              //               ],
              //             ),
              //           )
              //     : const Center(child: CircularProgressIndicator()),
              //
            },
          ),
        ],
      ),
    );
  }
}
