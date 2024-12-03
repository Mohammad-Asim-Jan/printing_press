
/// todo: delete this file, it is of no use
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../../components/custom_circular_indicator.dart';
// import '../../components/custom_drop_down.dart';
// import '../../components/custom_text_field.dart';
// import '../../components/round_button.dart';
// import '../../model/stock.dart';
// import '../../text_styles/custom_text_styles.dart';
// import '../../utils/validation_functions.dart';
// import '../../view_model/orders/place_stock_order_view_model.dart';
// import '../stock/add_stock_view.dart';
//
// class StockOrderFromCustomer extends StatefulWidget {
//   const StockOrderFromCustomer({super.key});
//
//   @override
//   State<StockOrderFromCustomer> createState() => _StockOrderFromCustomerState();
// }
//
// class _StockOrderFromCustomerState extends State<StockOrderFromCustomer> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PlaceStockOrderViewModel>(builder: (context, val, child) {
//       return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: val.getAllStock(),
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           debugPrint('Stream builder refreshing');
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CustomCircularIndicator();
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (snapshot.hasData) {
//             val.allStockList.clear();
//             val.stockList = snapshot.data!.docs.map((e) {
//               val.allStockList.add(e.data()['stockName']);
//               return Stock.fromJson(e.data());
//             }).toList();
//             if (val.stockList.isEmpty) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   kTitleText('You are out of stock!'),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const AddStockView(),
//                         ),
//                       );
//                     },
//                     child: kTitleText('Add a stock'),
//                   ),
//                 ],
//               );
//             }
//             val.selectedStockModel = val.stockList[0];
//             val.selectedStockIndex = 0;
//             val.selectedStock = val.allStockList[0];
//
//             return Column(children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Form(
//                       key: val.formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomTextField(
//                             controller: val.customerNameC,
//                             iconData: Icons.person,
//                             hint: 'Customer name',
//                             validators: const [isNotEmpty],
//                           ),
//                           CustomTextField(
//                             controller: val.businessTitleC,
//                             iconData: Icons.business,
//                             hint: 'Business name',
//                             validators: const [isNotEmpty],
//                           ),
//                           CustomTextField(
//                             maxLength: 11,
//                             textInputType: TextInputType.number,
//                             controller: val.customerContactC,
//                             inputFormatter:
//                                 FilteringTextInputFormatter.digitsOnly,
//                             iconData: Icons.phone,
//                             hint: 'Contact',
//                             validators: const [isNotEmpty],
//                           ),
//                           CustomTextField(
//                             controller: val.customerAddressC,
//                             iconData: Icons.home_filled,
//                             hint: 'Address',
//                             validators: const [isNotEmpty],
//                           ),
//                           SizedBox(height: 10),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 5.0),
//                             child: Text(
//                               'Select a Stock',
//                               style: kTitle2TextStyle,
//                             ),
//                           ),
//                           CustomDropDown(
//                             prefixIconData: Icons.inventory,
//                             validator: null,
//                             list: val.allStockList,
//                             value: val.selectedStock,
//                             hint: val.selectedStock,
//                             onChanged: (newVal) {
//                               val.changeStockDropDown(newVal);
//                             },
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Stock Details',
//                             style: kTitle2TextStyle,
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Table(
//                                     border: TableBorder(
//                                         horizontalInside: BorderSide(
//                                             width: 0.5,
//                                             color:
//                                                 Colors.black.withOpacity(0.5))),
//                                     textBaseline: TextBaseline.alphabetic,
//                                     defaultVerticalAlignment:
//                                         TableCellVerticalAlignment.baseline,
//                                     columnWidths: {
//                                       0: FractionColumnWidth(0.2),
//                                       1: FractionColumnWidth(0.2),
//                                       2: FractionColumnWidth(0.2),
//                                       3: FractionColumnWidth(0.2),
//                                       4: FractionColumnWidth(0.2),
//                                     },
//                                     children: [
//                                       TableRow(
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 'Name',
//                                                 9,
//                                                 Colors.black.withOpacity(0.6),
//                                                 2),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 'Category',
//                                                 9,
//                                                 Colors.black.withOpacity(0.6),
//                                                 2),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 'Color',
//                                                 10,
//                                                 Colors.black.withOpacity(0.6),
//                                                 2),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 'Available',
//                                                 10,
//                                                 Colors.black.withOpacity(0.6),
//                                                 2),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 'Price',
//                                                 10,
//                                                 Colors.black.withOpacity(0.6),
//                                                 2),
//                                           ),
//                                         ],
//                                       ),
//                                       TableRow(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 val.selectedStockModel
//                                                     .stockName,
//                                                 12,
//                                                 null,
//                                                 2),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 val.selectedStockModel
//                                                     .stockCategory,
//                                                 12,
//                                                 null,
//                                                 2),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 val.selectedStockModel
//                                                     .stockColor,
//                                                 12,
//                                                 null,
//                                                 2),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 val.selectedStockModel
//                                                     .availableStock
//                                                     .toString(),
//                                                 12,
//                                                 null,
//                                                 2),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: kTitleText(
//                                                 val.selectedStockModel
//                                                     .stockUnitSellPrice
//                                                     .toString(),
//                                                 12,
//                                                 null,
//                                                 2),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           CustomTextField(
//                               controller: val.stockQuantityC,
//                               iconData: Icons.numbers_outlined,
//                               inputFormatter:
//                                   FilteringTextInputFormatter.digitsOnly,
//                               textInputType: TextInputType.number,
//                               hint: 'Quantity',
//                               validators: [
//                                 isNotEmpty,
//                                 isNotZero,
//                                 (value) => lessThan(
//                                     value,
//                                     val.stockList[val.selectedStockIndex]
//                                         .stockQuantity)
//                               ]),
//                           CustomTextField(
//                               controller: val.advancePaymentC,
//                               iconData: Icons.monetization_on_rounded,
//                               inputFormatter:
//                                   FilteringTextInputFormatter.digitsOnly,
//                               textInputType: TextInputType.number,
//                               hint: 'Advance payment',
//                               validators: [
//                                 isNotEmpty,
//                                 (value) => lessThan(value, val.totalAmount)
//                               ])
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: RoundButton(
//                       title: 'Place Order',
//                       loading: val.loading,
//                       onPress: () =>
//                           val.addCustomerOrderDataInFirebase(context)))
//             ]);
//           }
//           return const Text('No data!');
//         },
//       );
//     });
//   }
// }
