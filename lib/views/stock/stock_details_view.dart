import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/stock.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/stock/stock_details_view_model.dart';
import 'package:printing_press/views/stock/stock_history_view.dart';
import 'package:provider/provider.dart';

import '../../components/custom_circular_indicator.dart';
import '../../utils/toast_message.dart';

class StockDetailsView extends StatefulWidget {
  final bool isSupplierExist;
  final int stockId;

  const StockDetailsView({
    super.key,
    required this.stockId,
    required this.isSupplierExist,
  });

  @override
  State<StockDetailsView> createState() => _StockDetailsViewState();
}

class _StockDetailsViewState extends State<StockDetailsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kNew1a,
        appBar: AppBar(
          foregroundColor: kNew9a,
          backgroundColor: kNew1a,
          title: Text(
            'Stock Details',
            style: TextStyle(
                color: kNew9a,
                fontSize: 21,
                letterSpacing: 0,
                fontWeight: FontWeight.w500),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  if (widget.isSupplierExist) {
                    /// todo:
                  } else {
                    Utils.showMessage('Supplier is not available!');
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      widget.isSupplierExist ? Colors.white70 : kNew9,
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: widget.isSupplierExist ? kOne : kNew9a,
                ),
                child: Text(
                  'Add more',
                  style: TextStyle(fontSize: 10),
                )),
            SizedBox(width: 10)
          ],
        ),
        body: Consumer<StockDetailsViewModel>(builder: (context, value, child) {
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: value.getStockData(widget.stockId),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomCircularIndicator();
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Stock does not exist'));
              }
              if (snapshot.hasData) {
                value.stock = Stock.fromJson(snapshot.data!.data()!);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              value.stock.stockName,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 33,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Iowan',
                                  overflow: TextOverflow.ellipsis,
                                  color: kThirdColor),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              '( ${value.stock.stockColor} )',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 16,
                                  fontFamily: 'Iowan',
                                  overflow: TextOverflow.ellipsis,
                                  color: kThirdColor),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kTitleText(
                                      value.stock.stockCategory, 18, kNew6),
                                  SizedBox(height: 6),
                                  kDescription3Text(
                                      value.stock.stockDescription, null, 3),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  kTitleText('Product By', 14,
                                      Colors.black.withOpacity(0.6)),
                                  SizedBox(height: 3),
                                  kDescription3Text(
                                      value.stock.manufacturedBy, null, 2),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(color: kNew3, thickness: 1.5),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kNew8.withOpacity(0.25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.brown.withOpacity(0.3),
                                blurStyle: BlurStyle.outer,
                                blurRadius: 7,
                              )
                            ],
                            // borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    kTitleText('Available Stock', 12,
                                        Colors.black.withOpacity(0.6)),
                                    SizedBox(height: 5),
                                    kTitleText(
                                        (value.stock.availableStock == 0)
                                            ? 'Out of stock!'
                                            : '${value.stock.availableStock}',
                                        15,
                                        value.stock.availableStock < 10
                                            ? kNew8
                                            : kNew4),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    kTitleText('Total Stock', 12,
                                        Colors.black.withOpacity(0.6)),
                                    SizedBox(height: 5),
                                    kTitleText('${value.stock.stockQuantity}',
                                        15, kNew4),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                            child: kTitleText(
                                'Pricing', 16, Colors.black.withOpacity(0.6))),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: kDescription3Text(
                                      'Buying Price\nSelling Price\nTotal Amount',
                                      null,
                                      3,
                                      null,
                                      1.5)),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: kDescription3Text(
                                    'Rs. ${value.stock.stockUnitBuyPrice}\nRs. ${value.stock.stockUnitSellPrice}\nRs. ${value.stock.totalAmount}',
                                    kOne,
                                    3,
                                    null,
                                    1.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(color: kNew3, thickness: 1),
                        Center(
                            child: kTitleText('Stock History', 16,
                                Colors.black.withOpacity(0.6))),
                        SizedBox(height: 8),
                        Flexible(
                            child:
                                StockHistoryView(stockId: value.stock.stockId))
                      ]),
                );
              }
              return const Text('Stock doesn\'t exists!');
            },
          );
        }));
  }
}

// Row(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     Expanded(
//       flex: 9,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           kTitleText('Description', 18, kTitle2),
//           SizedBox(height: 4),
//           kDescription3Text(stock.stockDescription, null, 3),
//           SizedBox(height: 20),
//           kTitleText('Manufactured By', 16, kTitle2),
//           SizedBox(height: 4),
//           kDescription3Text(stock.manufacturedBy),
//         ],
//       ),
//     ),
//     SizedBox(width: 15),
//     Expanded(
//       flex: 10,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           kTitleText('Pricing', 18, kTitle2),
//           SizedBox(height: 4),
//           Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   kDescription3Text('Buying Price'),
//                   SizedBox(height: 5),
//                   kDescription3Text('Selling Price'),
//                   SizedBox(height: 5),
//                   kDescription3Text('Total Amount'),
//                 ],
//               ),
//               SizedBox(width: 30),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     kDescription3Text(
//                         stock.stockUnitBuyPrice.toString(), kOne),
//                     SizedBox(height: 5),
//                     kDescription3Text(
//                         stock.stockUnitSellPrice.toString(), kOne),
//                     SizedBox(height: 5),
//                     kTitleText(
//                         stock.totalAmount.toString(), null, kNew4),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     )
//   ],
// ),
///
// Text('Date '),
// Text(stock.stockDateAdded.toString().substring(0, 10)),
// SizedBox(
//   height: 20,
// ),
// Divider(
//   color: Colors.grey,
//   thickness: 1,
//   endIndent: 70,
//   indent: 70,
//   height: 20,
// ),
///
// Spacer(),
// Row(
//   children: [
//     SizedBox(width: 10),
//     Expanded(
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => StockHistoryView(
//                 stockId: stock.stockId,
//                 availableStock: stock.availableStock,
//                 stockName: stock.stockName,
//                 stockQuantity: stock.stockQuantity),
//           ));
//         },
//         child: Container(
//           height: 50,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: kNew7,
//                 width: 1,
//               )),
//           alignment: Alignment.center,
//           child: kTitleText('History', 14, kNew7),
//         ),
//       ),
//     ),
//     SizedBox(width: 40),
//     Expanded(
//       child: GestureDetector(
//         onTap: () {
//           if (supplierExist) {
//           } else {
//             Utils.showMessage('Supplier is not available!');
//           }
//         },
//         child: Container(
//           height: 50,
//           decoration: BoxDecoration(
//               color: supplierExist ? kNew7 : kNew9a,
//               borderRadius: BorderRadius.circular(12)),
//           alignment: Alignment.center,
//           child: kTitleText(
//               'Order More', 14, supplierExist ? kTwo : kNew9),
//         ),
//       ),
//     ),
//     SizedBox(width: 10),
//   ],
// ),
///
//Container(
//               width: double.infinity,
//               height: 40,
//               decoration: BoxDecoration(
//               color: Colors.blueAccent.withOpacity(0.1),
//               // border: Border.all(
//               //   color:Colors.blueAccent.withOpacity(0.2)
//               // ),
//               borderRadius: BorderRadius.circular(0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//               child:Text('lkasjdfkl'))
