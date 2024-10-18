import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/stock_order_history_by_customer.dart';
import 'package:printing_press/model/stock_order_history_to_supplier.dart';
import 'package:printing_press/view_model/stock/stock_history_view_model.dart';
import 'package:provider/provider.dart';

class StockHistoryView extends StatefulWidget {
  const StockHistoryView({
    super.key,
    required this.stockId,
    required this.availableStock,
    required this.stockName,
    required this.stockQuantity,
  });

  final int stockId;
  final int availableStock;
  final String stockName;
  final int stockQuantity;

  @override
  State<StockHistoryView> createState() => _StockHistoryViewState();
}

class _StockHistoryViewState extends State<StockHistoryView> {
  late StockOrderHistoryViewModel stockOrderHistoryViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stockOrderHistoryViewModel =
        Provider.of<StockOrderHistoryViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock history'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: kSecColor,
                child: Column(children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Available Stock'),
                    Text('Name'),
                    Text('Total'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.availableStock}'),
                    Text(widget.stockName),
                    Text('${widget.stockQuantity}'),
                  ],
                ),
              ],),),
              Consumer<StockOrderHistoryViewModel>(
                  builder: (context, value, child) {
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: value.getStockHistoryData(widget.stockId),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.hasData) {
                        value.allStockOrderHistoryList =
                            snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data = e.data();
                          if (data['supplierId'] != null) {
                            /// Here there is a supplier order doc
                            return StockOrderHistoryToSupplier.fromJson(
                                e.data());
                          } else {
                            /// Here there is a customer order document
                            return StockOrderHistoryByCustomer.fromJson(
                                e.data());
                          }
                        }).toList();

                        if (value.allStockOrderHistoryList.isEmpty) {
                          return const Center(
                            child: Text('No entry found!'),
                          );
                        }
                        return Flexible(
                          child: ListView.builder(
                            itemCount: value.allStockOrderHistoryList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (value.allStockOrderHistoryList[index]
                                  is StockOrderHistoryByCustomer) {
                                StockOrderHistoryByCustomer
                                    stockOrderHistoryByCustomer =
                                    value.allStockOrderHistoryList[index];
                                return ListTile(
                                  shape: Border.all(width: 2, color: kPrimeColor),
                                  titleTextStyle: TextStyle(
                                      color: kThirdColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  title: const Text('Customer Order'),
                                  tileColor: kSecColor,
                                  subtitleTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic),
                                  subtitle: Text(
                                    'Quantity: ${stockOrderHistoryByCustomer.stockQuantity}\nAmount: ${stockOrderHistoryByCustomer.totalAmount}',
                                  ),
                                  leading: Text(stockOrderHistoryByCustomer
                                      .customerOrderId
                                      .toString()),
                                );
                              } else if (value.allStockOrderHistoryList[index]
                                  is StockOrderHistoryToSupplier) {
                                StockOrderHistoryToSupplier
                                    stockOrderHistoryToSupplier =
                                    value.allStockOrderHistoryList[index];
                                return ListTile(
                                  shape: Border.all(width: 2, color: kPrimeColor),
                                  // titleAlignment: ListTileTitleAlignment.threeLine,
                                  titleTextStyle: TextStyle(
                                      color: kThirdColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  title: const Text('Supplier Order'),
                                  tileColor: kTwo,
                                  subtitleTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic),
                                  subtitle: Text(
                                    'Quantity: ${stockOrderHistoryToSupplier.stockQuantity}\nAmount: ${stockOrderHistoryToSupplier.totalAmount}',
                                  ),
                                  leading: Text(stockOrderHistoryToSupplier
                                      .stockOrderId
                                      .toString()),
                                );
                              } else {
                                return const Center(
                                  child: Text('Some error !'),
                                );
                              }
                            },
                          ),
                        );
                      }

                      return const Text('No data!');
                    });

                // value.dataFetched
                //     ? value.allStockOrderHistoryList.isEmpty
                //         ? const Center(
                //             child: Text('No record found!'),
                //           )
                //
                //         ///todo: change listview.builder to streams builder, add a button to add the payment transaction
                //         : Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Column(
                //               children: [
                //                 Container(
                //                   color: kSecColor,
                //                   child: Column(
                //                     children: [
                //                       const Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         children: [
                //                           Text('Available Stock'),
                //                           Text('Name'),
                //                           Text('Total'),
                //                         ],
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         children: [
                //                           Text('${widget.availableStock}'),
                //                           Text(widget.stockName),
                //                           Text('${widget.stockQuantity}'),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 const SizedBox(
                //                   height: 15,
                //                 ),
                //                 Expanded(
                //                   child: ListView.builder(
                //                     itemCount: value.allStockOrderHistoryList.length,
                //                     itemBuilder: (BuildContext context, int index) {
                //                       if (value.allStockOrderHistoryList[index]
                //                           is StockOrderHistoryByCustomer) {
                //                         StockOrderHistoryByCustomer
                //                             stockOrderHistoryByCustomer =
                //                             value.allStockOrderHistoryList[index];
                //                         return ListTile(
                //                           shape:
                //                               Border.all(width: 2, color: kPrimeColor),
                //                           titleTextStyle: TextStyle(
                //                               color: kThirdColor,
                //                               fontSize: 18,
                //                               fontWeight: FontWeight.w500),
                //                           title: const Text('Customer Order'),
                //                           tileColor: kSecColor,
                //                           subtitleTextStyle: const TextStyle(
                //                               color: Colors.black,
                //                               fontStyle: FontStyle.italic),
                //                           subtitle: Text(
                //                             'Quantity: ${stockOrderHistoryByCustomer.stockQuantity}\nAmount: ${stockOrderHistoryByCustomer.totalAmount}',
                //                           ),
                //                           leading: Text(stockOrderHistoryByCustomer
                //                               .customerOrderId
                //                               .toString()),
                //                         );
                //                       } else if (value.allStockOrderHistoryList[index]
                //                           is StockOrderHistoryToSupplier) {
                //                         StockOrderHistoryToSupplier
                //                             stockOrderHistoryToSupplier =
                //                             value.allStockOrderHistoryList[index];
                //                         return ListTile(
                //                           shape:
                //                               Border.all(width: 2, color: kPrimeColor),
                //                           // titleAlignment: ListTileTitleAlignment.threeLine,
                //                           titleTextStyle: TextStyle(
                //                               color: kThirdColor,
                //                               fontSize: 18,
                //                               fontWeight: FontWeight.w500),
                //                           title: const Text('Supplier Order'),
                //                           tileColor: kTwo,
                //                           subtitleTextStyle: const TextStyle(
                //                               color: Colors.black,
                //                               fontStyle: FontStyle.italic),
                //                           subtitle: Text(
                //                             'Quantity: ${stockOrderHistoryToSupplier.stockQuantity}\nAmount: ${stockOrderHistoryToSupplier.totalAmount}',
                //                           ),
                //                           leading: Text(stockOrderHistoryToSupplier
                //                               .supplierId
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
                //               ],
                //             ),
                //           )
                //     : const Center(child: CircularProgressIndicator()),
                //
              }),
            ],
          )),
    );
  }
}
