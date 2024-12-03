import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/components/custom_circular_indicator.dart';
import 'package:printing_press/view_model/suppliers/supplier_details_view_model.dart';
import 'package:provider/provider.dart';
import '../../model/cashbook_entry.dart';
import '../../model/stock_order_history_to_supplier.dart';
import '../../text_styles/custom_text_styles.dart';
import '../../utils/date_format.dart';

class SupplierStocksOrdersHistoryView extends StatefulWidget {
  const SupplierStocksOrdersHistoryView({super.key, required this.supplierId});

  final int supplierId;

  @override
  State<SupplierStocksOrdersHistoryView> createState() =>
      _SupplierStocksOrdersHistoryViewState();
}

class _SupplierStocksOrdersHistoryViewState
    extends State<SupplierStocksOrdersHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SupplierDetailsViewModel>(
        builder: (BuildContext context, SupplierDetailsViewModel value,
                Widget? child) =>
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: value.getSupplierOrderHistoryData(widget.supplierId),
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
                      return Center(
                          child: Text('No entry found',
                              style: kDescriptionTextStyle));
                    }
                    return ListView.builder(
                      itemCount: value.allSupplierStockOrderHistoryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isCashbookEntry =
                            value.allSupplierStockOrderHistoryList[index]
                                is CashbookEntry;

                        late CashbookEntry cashbookEntry;
                        late StockOrderHistoryToSupplier
                            stockOrderHistoryToSupplier;

                        if (isCashbookEntry) {
                          cashbookEntry =
                              value.allSupplierStockOrderHistoryList[index];
                        } else {
                          stockOrderHistoryToSupplier =
                              value.allSupplierStockOrderHistoryList[index];
                        }

                        if (isCashbookEntry) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Icon(Icons.payment,
                                    color: Colors.green.shade500),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Table(
                                      columnWidths: {
                                        0: FractionColumnWidth(0.3),
                                        1: FractionColumnWidth(0.3),
                                        2: FractionColumnWidth(0.2),
                                        3: FractionColumnWidth(0.2),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  'Payment Method',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  'Description',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  'Amount',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  'Date',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: kTitleText(
                                                    cashbookEntry
                                                            .paymentMethod ??
                                                        'Nil',
                                                    12,
                                                    null,
                                                    2)),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  cashbookEntry.description ??
                                                      'Nil',
                                                  12,
                                                  null,
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  cashbookEntry.amount
                                                      .toString(),
                                                  12,
                                                  null,
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  formatDate(cashbookEntry
                                                      .paymentDateTime),
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
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Icon(Icons.shopping_cart_outlined,
                                    color: Colors.blueGrey.shade600),
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
                                                  'Stock',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  'Price',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  'Quantity',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  'Amount',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  'Date',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: kTitleText(
                                                    stockOrderHistoryToSupplier
                                                        .stockName
                                                        .toString(),
                                                    12,
                                                    null,
                                                    2)),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  stockOrderHistoryToSupplier
                                                      .stockUnitBuyPrice
                                                      .toString(),
                                                  12,
                                                  null,
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  stockOrderHistoryToSupplier
                                                      .stockQuantity
                                                      .toString(),
                                                  12,
                                                  null,
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  stockOrderHistoryToSupplier
                                                      .totalAmount
                                                      .toString(),
                                                  12,
                                                  null,
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  formatDate(
                                                      stockOrderHistoryToSupplier
                                                          .stockDateAdded),
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
                            ),
                          );
                        }
                      },
                    );
                  }
                  return const Text('No data!');
                }));
  }
}

//
// ListTile(
//   // trailing: SizedBox(
//   //   width: 100,
//   //   child: Row(
//   //     children: [
//   //       IconButton(
//   //         icon: const Icon(Icons.edit),
//   //         onPressed: () {},
//   //       ),
//   //       IconButton(
//   //         icon: const Icon(Icons.delete),
//   //         onPressed: () {},
//   //       ),
//   //     ],
//   //   ),
//   // ),
//   shape: Border.all(width: 2, color: kPrimeColor),
//   // titleAlignment: ListTileTitleAlignment.threeLine,
//   titleTextStyle: TextStyle(
//       color: kThirdColor,
//       fontSize: 18,
//       fontWeight: FontWeight.w500),
//   title: Text(
//       cashbookEntry.description ?? 'No description'),
//   tileColor: kSecColor,
//   subtitleTextStyle: const TextStyle(
//       color: Colors.black, fontStyle: FontStyle.italic),
//   subtitle: Text(
//     'Payment Method: ${cashbookEntry
//         .paymentMethod}\nAmount: ${cashbookEntry.amount}',
//   ),
//   leading:
//   Text(cashbookEntry.newStockOrderId.toString()),
// );
// ListTile(
//   // trailing: SizedBox(
//   //   width: 100,
//   //   child: Row(
//   //     children: [
//   //       IconButton(
//   //         icon: const Icon(Icons.edit),
//   //         onPressed: () {},
//   //       ),
//   //       IconButton(
//   //         icon: const Icon(Icons.delete),
//   //         onPressed: () {},
//   //       ),
//   //     ],
//   //   ),
//   // ),
//   shape: Border.all(width: 2, color: kPrimeColor),
//   // titleAlignment: ListTileTitleAlignment.threeLine,
//   titleTextStyle: TextStyle(
//       color: kThirdColor,
//       fontSize: 18,
//       fontWeight: FontWeight.w500),
//   title: Text(stockOrderHistoryToSupplier.stockName),
//   tileColor: kTwo,
//   subtitleTextStyle: const TextStyle(
//       color: Colors.black, fontStyle: FontStyle.italic),
//   subtitle: Text(
//     'Stock Category: ${stockOrderHistoryToSupplier
//         .stockCategory}\nTotal: ${stockOrderHistoryToSupplier
//         .totalAmount}',
//   ),
//   leading: Text(stockOrderHistoryToSupplier
//       .stockQuantity
//       .toString()),
// );
