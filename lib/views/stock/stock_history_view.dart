import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing_press/model/stock_order_history_by_customer.dart';
import 'package:printing_press/model/stock_order_history_to_supplier.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/stock/stock_details_view_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_circular_indicator.dart';

class StockHistoryView extends StatefulWidget {
  const StockHistoryView({
    super.key,
    required this.stockId,
  });

  final int stockId;

  @override
  State<StockHistoryView> createState() => _StockHistoryViewState();
}

class _StockHistoryViewState extends State<StockHistoryView> {

  @override
  Widget build(BuildContext context) {
    return Consumer<StockDetailsViewModel>(
        builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: value.getStockHistoryData(widget.stockId),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomCircularIndicator();
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              value.allStockOrderHistoryList = snapshot.data!.docs.map((e) {
                Map<String, dynamic> data = e.data();
                if (data['supplierId'] != null) {
                  /// Here there is a supplier order doc
                  return StockOrderHistoryToSupplier.fromJson(e.data());
                } else {
                  /// Here there is a customer order document
                  return StockOrderHistoryByCustomer.fromJson(e.data());
                }
              }).toList();

              if (value.allStockOrderHistoryList.isEmpty) {
                return const Center(
                  child: Text('No entry found!'),
                );
              }

              return ListView.builder(
                itemCount: value.allStockOrderHistoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isCustomer = value.allStockOrderHistoryList[index]
                      is StockOrderHistoryByCustomer;

                  late StockOrderHistoryByCustomer customer;
                  late StockOrderHistoryToSupplier supplier;
                  if (isCustomer) {
                    customer = value.allStockOrderHistoryList[index];
                  } else {
                    supplier = value.allStockOrderHistoryList[index];
                  }

                  return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isCustomer
                            ? Colors.green.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Icon(
                              isCustomer
                                  ? Icons.person_2_outlined
                                  : Icons.business_outlined,
                              color: isCustomer
                                  ? Colors.green.shade500
                                  : Colors.blue.shade300),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                columnWidths: {
                                  0: FractionColumnWidth(0.2),
                                  1: FractionColumnWidth(0.2),
                                  2: FractionColumnWidth(0.2),
                                  3: FractionColumnWidth(0.2),
                                  4: FractionColumnWidth(0.2),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            isCustomer
                                                ? 'Order Id'
                                                : 'Supplier Id',
                                            10,
                                            Colors.black.withOpacity(0.6),
                                            2),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            isCustomer
                                                ? 'Sell Price'
                                                : 'Buy Price',
                                            10,
                                            Colors.black.withOpacity(0.6),
                                            2),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText('Quantity', 10,
                                            Colors.black.withOpacity(0.6), 2),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText('Amount', 10,
                                            Colors.black.withOpacity(0.6), 2),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText('Date', 10,
                                            Colors.black.withOpacity(0.6), 2),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: kTitleText(
                                              isCustomer
                                                  ? customer.customerOrderId
                                                      .toString()
                                                  : supplier.supplierId
                                                      .toString(),
                                              12,
                                              null,
                                              2)),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            isCustomer
                                                ? customer.stockUnitSellPrice
                                                    .toString()
                                                : supplier.stockUnitBuyPrice
                                                    .toString(),
                                            12,
                                            null,
                                            2),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            isCustomer
                                                ? customer.stockQuantity
                                                    .toString()
                                                : supplier.stockQuantity
                                                    .toString(),
                                            12,
                                            null,
                                            2),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            isCustomer
                                                ? customer.totalAmount
                                                    .toString()
                                                : supplier.totalAmount
                                                    .toString(),
                                            12,
                                            null,
                                            2),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            isCustomer
                                                ? formatDate(
                                                customer.stockDateOrdered)
                                                : formatDate(
                                                supplier.stockDateAdded),
                                            12,
                                            null,
                                            2),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),);
                },
              );
            }
            return const Text('No data!');
          });
    });
  }

  String formatDate(DateTime datetime) {
    return DateFormat('dd MMM, yyyy').format(datetime);
  }
}
// if (value.allStockOrderHistoryList[index]
//     is StockOrderHistoryByCustomer) {
//   StockOrderHistoryByCustomer stockOrderHistoryByCustomer =
//       value.allStockOrderHistoryList[index];
//   return Column(
//     children: [
//       Container(
//           width: double.infinity,
//           height: 60,
//           decoration: BoxDecoration(
//             color: Colors.green.withOpacity(0.2),
//             // border: Border.all(
//             //   color:Colors.blueAccent.withOpacity(0.2)
//             // ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.shopping_cart_outlined,
//                   color: Colors.green.shade500),
//             ],
//           )),
//       ListTile(
//         shape: Border.all(width: 2, color: kPrimeColor),
//         titleTextStyle: TextStyle(
//             color: kThirdColor,
//             fontSize: 18,
//             fontWeight: FontWeight.w500),
//         title: const Text('Customer Order'),
//         tileColor: kSecColor,
//         subtitleTextStyle: const TextStyle(
//             color: Colors.black,
//             fontStyle: FontStyle.italic),
//         subtitle: Text(
//           'Quantity: ${stockOrderHistoryByCustomer.stockQuantity}\nAmount: ${stockOrderHistoryByCustomer.totalAmount}',
//         ),
//         leading: Text(stockOrderHistoryByCustomer
//             .customerOrderId
//             .toString()),
//         trailing: Text(stockOrderHistoryByCustomer
//             .stockOrderId
//             .toString()),
//       ),
//     ],
//   );
// } else if (value.allStockOrderHistoryList[index]
//     is StockOrderHistoryToSupplier) {
//   StockOrderHistoryToSupplier stockOrderHistoryToSupplier =
//       value.allStockOrderHistoryList[index];
//   return Container(
//       decoration: BoxDecoration(
//         color: Colors.blue.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Icon(Icons.business_outlined,
//                 color: Colors.blue.shade300),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Table(
//                 columnWidths: {
//                   0: FractionColumnWidth(0.2),
//                   1: FractionColumnWidth(0.2),
//                   2: FractionColumnWidth(0.2),
//                   3: FractionColumnWidth(0.2),
//                   4: FractionColumnWidth(0.2),
//                 },
//                 children: [
//                   TableRow(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             'Order Id',
//                             10,
//                             Colors.black.withOpacity(0.6),
//                             2),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             'Sell Price',
//                             10,
//                             Colors.black.withOpacity(0.6),
//                             2),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             'Quantity',
//                             10,
//                             Colors.black.withOpacity(0.6),
//                             2),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             'Amount',
//                             10,
//                             Colors.black.withOpacity(0.6),
//                             2),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             'Date',
//                             10,
//                             Colors.black.withOpacity(0.6),
//                             2),
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       Padding(
//                           padding: EdgeInsets.all(4.0),
//                           child: kTitleText(
//                               'sdfsdf1', 12, null, 2)),
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             'Alicxdfsdfe', 12, null, 2),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             '23dfsdf', 12, null, 2),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             '2sdfsdf3', 12, null, 2),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: kTitleText(
//                             'as.d,fmlk23', 12, null, 2),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ));
//
//   // ListTile(
//   //   shape: Border.all(width: 2, color: kPrimeColor),
//   //   // titleAlignment: ListTileTitleAlignment.threeLine,
//   //   titleTextStyle: TextStyle(
//   //       color: kThirdColor,
//   //       fontSize: 18,
//   //       fontWeight: FontWeight.w500),
//   //   title: const Text('Supplier Order'),
//   //   tileColor: kTwo,
//   //   subtitleTextStyle: const TextStyle(
//   //       color: Colors.black,
//   //       fontStyle: FontStyle.italic),
//   //   subtitle: Text(
//   //     'Quantity: ${stockOrderHistoryToSupplier.stockQuantity}\nAmount: ${stockOrderHistoryToSupplier.totalAmount}',
//   //   ),
//   //   leading: Text(stockOrderHistoryToSupplier
//   //       .stockOrderId
//   //       .toString()),
//   // ),} else {
//   return const Center(
//     child: Text('Some error !'),
//   );
// }
///
// value.dataFetched
//     ? value.allStockOrderHistoryList.isEmpty
//         ? const Center(
//             child: Text('No record found!'),
//           )
//
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
///
//   Scaffold(
//   appBar: AppBar(
//     title: const Text('Stock history'),
//   ),
//   body: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Container(
//             color: kSecColor,
//             child: Column(
//               children: [
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Available Stock'),
//                     Text('Name'),
//                     Text('Total'),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('${widget.availableStock}'),
//                     Text(widget.stockName),
//                     Text('${widget.stockQuantity}'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Consumer<StockOrderHistoryViewModel>(
//               builder: (context, value, child) {
//             return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                 stream: value.getStockHistoryData(widget.stockId),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                         snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CustomCircularIndicator();
//                   }
//
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }
//
//                   if (snapshot.hasData) {
//                     value.allStockOrderHistoryList =
//                         snapshot.data!.docs.map((e) {
//                       Map<String, dynamic> data = e.data();
//                       if (data['supplierId'] != null) {
//                         /// Here there is a supplier order doc
//                         return StockOrderHistoryToSupplier.fromJson(
//                             e.data());
//                       } else {
//                         /// Here there is a customer order document
//                         return StockOrderHistoryByCustomer.fromJson(
//                             e.data());
//                       }
//                     }).toList();
//
//                     if (value.allStockOrderHistoryList.isEmpty) {
//                       return const Center(
//                         child: Text('No entry found!'),
//                       );
//                     }
//                     return Flexible(
//                       child: ListView.builder(
//                         itemCount: value.allStockOrderHistoryList.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           if (value.allStockOrderHistoryList[index]
//                               is StockOrderHistoryByCustomer) {
//                             StockOrderHistoryByCustomer
//                                 stockOrderHistoryByCustomer =
//                                 value.allStockOrderHistoryList[index];
//                             return ListTile(
//                               shape:
//                                   Border.all(width: 2, color: kPrimeColor),
//                               titleTextStyle: TextStyle(
//                                   color: kThirdColor,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w500),
//                               title: const Text('Customer Order'),
//                               tileColor: kSecColor,
//                               subtitleTextStyle: const TextStyle(
//                                   color: Colors.black,
//                                   fontStyle: FontStyle.italic),
//                               subtitle: Text(
//                                 'Quantity: ${stockOrderHistoryByCustomer.stockQuantity}\nAmount: ${stockOrderHistoryByCustomer.totalAmount}',
//                               ),
//                               leading: Text(stockOrderHistoryByCustomer
//                                   .customerOrderId
//                                   .toString()),
//                               trailing: Text(stockOrderHistoryByCustomer
//                                   .stockOrderId
//                                   .toString()),
//                             );
//                           } else if (value.allStockOrderHistoryList[index]
//                               is StockOrderHistoryToSupplier) {
//                             StockOrderHistoryToSupplier
//                                 stockOrderHistoryToSupplier =
//                                 value.allStockOrderHistoryList[index];
//                             return ListTile(
//                               shape:
//                                   Border.all(width: 2, color: kPrimeColor),
//                               // titleAlignment: ListTileTitleAlignment.threeLine,
//                               titleTextStyle: TextStyle(
//                                   color: kThirdColor,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w500),
//                               title: const Text('Supplier Order'),
//                               tileColor: kTwo,
//                               subtitleTextStyle: const TextStyle(
//                                   color: Colors.black,
//                                   fontStyle: FontStyle.italic),
//                               subtitle: Text(
//                                 'Quantity: ${stockOrderHistoryToSupplier.stockQuantity}\nAmount: ${stockOrderHistoryToSupplier.totalAmount}',
//                               ),
//                               leading: Text(stockOrderHistoryToSupplier
//                                   .stockOrderId
//                                   .toString()),
//                             );
//                           } else {
//                             return const Center(
//                               child: Text('Some error !'),
//                             );
//                           }
//                         },
//                       ),
//                     );
//                   }
//                   return const Text('No data!');
//                 });
//
//             // value.dataFetched
//             //     ? value.allStockOrderHistoryList.isEmpty
//             //         ? const Center(
//             //             child: Text('No record found!'),
//             //           )
//             //
//             //         : Padding(
//             //             padding: const EdgeInsets.all(8.0),
//             //             child: Column(
//             //               children: [
//             //                 Container(
//             //                   color: kSecColor,
//             //                   child: Column(
//             //                     children: [
//             //                       const Row(
//             //                         mainAxisAlignment:
//             //                             MainAxisAlignment.spaceBetween,
//             //                         children: [
//             //                           Text('Available Stock'),
//             //                           Text('Name'),
//             //                           Text('Total'),
//             //                         ],
//             //                       ),
//             //                       Row(
//             //                         mainAxisAlignment:
//             //                             MainAxisAlignment.spaceBetween,
//             //                         children: [
//             //                           Text('${widget.availableStock}'),
//             //                           Text(widget.stockName),
//             //                           Text('${widget.stockQuantity}'),
//             //                         ],
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 ),
//             //                 const SizedBox(
//             //                   height: 15,
//             //                 ),
//             //                 Expanded(
//             //                   child: ListView.builder(
//             //                     itemCount: value.allStockOrderHistoryList.length,
//             //                     itemBuilder: (BuildContext context, int index) {
//             //                       if (value.allStockOrderHistoryList[index]
//             //                           is StockOrderHistoryByCustomer) {
//             //                         StockOrderHistoryByCustomer
//             //                             stockOrderHistoryByCustomer =
//             //                             value.allStockOrderHistoryList[index];
//             //                         return ListTile(
//             //                           shape:
//             //                               Border.all(width: 2, color: kPrimeColor),
//             //                           titleTextStyle: TextStyle(
//             //                               color: kThirdColor,
//             //                               fontSize: 18,
//             //                               fontWeight: FontWeight.w500),
//             //                           title: const Text('Customer Order'),
//             //                           tileColor: kSecColor,
//             //                           subtitleTextStyle: const TextStyle(
//             //                               color: Colors.black,
//             //                               fontStyle: FontStyle.italic),
//             //                           subtitle: Text(
//             //                             'Quantity: ${stockOrderHistoryByCustomer.stockQuantity}\nAmount: ${stockOrderHistoryByCustomer.totalAmount}',
//             //                           ),
//             //                           leading: Text(stockOrderHistoryByCustomer
//             //                               .customerOrderId
//             //                               .toString()),
//             //                         );
//             //                       } else if (value.allStockOrderHistoryList[index]
//             //                           is StockOrderHistoryToSupplier) {
//             //                         StockOrderHistoryToSupplier
//             //                             stockOrderHistoryToSupplier =
//             //                             value.allStockOrderHistoryList[index];
//             //                         return ListTile(
//             //                           shape:
//             //                               Border.all(width: 2, color: kPrimeColor),
//             //                           // titleAlignment: ListTileTitleAlignment.threeLine,
//             //                           titleTextStyle: TextStyle(
//             //                               color: kThirdColor,
//             //                               fontSize: 18,
//             //                               fontWeight: FontWeight.w500),
//             //                           title: const Text('Supplier Order'),
//             //                           tileColor: kTwo,
//             //                           subtitleTextStyle: const TextStyle(
//             //                               color: Colors.black,
//             //                               fontStyle: FontStyle.italic),
//             //                           subtitle: Text(
//             //                             'Quantity: ${stockOrderHistoryToSupplier.stockQuantity}\nAmount: ${stockOrderHistoryToSupplier.totalAmount}',
//             //                           ),
//             //                           leading: Text(stockOrderHistoryToSupplier
//             //                               .supplierId
//             //                               .toString()),
//             //                         );
//             //                       } else {
//             //                         return const Center(
//             //                           child: Text('Some error !'),
//             //                         );
//             //                       }
//             //                     },
//             //                   ),
//             //                 ),
//             //               ],
//             //             ),
//             //           )
//             //     : const Center(child: CircularProgressIndicator()),
//             //
//           }),
//         ],
//       )),
// )
//
//
