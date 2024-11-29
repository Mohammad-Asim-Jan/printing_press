import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/components/custom_circular_indicator.dart';
import 'package:printing_press/model/supplier.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/utils/toast_message.dart';
import 'package:printing_press/view_model/suppliers/supplier_details_view_model.dart';
import 'package:printing_press/views/payment/payment_to_supplier_view.dart';
import 'package:printing_press/views/suppliers/supplier_bank_accounts_view.dart';
import 'package:printing_press/views/suppliers/supplier_stocks_orders_history_view.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';

class SupplierDetailsView extends StatefulWidget {
  const SupplierDetailsView({
    super.key,
    required this.supplierId,
  });

  final int supplierId;

  @override
  State<SupplierDetailsView> createState() => _SupplierDetailsViewState();
}

class _SupplierDetailsViewState extends State<SupplierDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcad6d2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kNew9a,
        title: Text('Supplier Details',
            style: TextStyle(
                color: kNew9a,
                fontSize: 21,
                letterSpacing: 0,
                fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<SupplierDetailsViewModel>(
          builder: (BuildContext context, SupplierDetailsViewModel value,
                  Widget? child) =>
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: value.getSupplierData(widget.supplierId),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>?>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CustomCircularIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text('Data is unavailable'));
                    }
                    if (snapshot.hasData) {
                      Supplier supplier =
                          Supplier.fromJson(snapshot.data!.data()!);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kTitleText(supplier.supplierName, 28, kThirdColor),
                          Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      kTitleText(
                                          supplier.supplierPhoneNo, 16, kNew6),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      kDescription3Text(
                                          supplier.supplierAddress,
                                          null,
                                          2,
                                          12),
                                    ],
                                  )),
                              SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  supplier.supplierEmail,
                                  maxLines: 2,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      fontSize: 14,
                                      fontFamily: 'Iowan',
                                      overflow: TextOverflow.ellipsis,
                                      color: kThirdColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(color: kNew3, thickness: 2),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 7,
                                )
                              ],
                              // borderRadius: BorderRadius.circular(10),
                            ),
                            child: Table(
                              textBaseline: TextBaseline.alphabetic,
                              columnWidths: {
                                0: FractionColumnWidth(0.33),
                                1: FractionColumnWidth(0.33),
                                2: FractionColumnWidth(0.34),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText('Paid Amount', 10,
                                            Colors.black.withOpacity(0.6), 1),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            'Remaining Amount',
                                            10,
                                            Colors.black.withOpacity(0.6),
                                            1),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText('Total Amount', 10,
                                            Colors.black.withOpacity(0.6), 1),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            supplier.totalPaidAmount.toString(),
                                            13,
                                            kOne, // kNew4
                                            2),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: kTitleText(
                                              supplier.amountRemaining
                                                  .toString(),
                                              13,
                                              kNew8, // kNew4
                                              2)),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            supplier.totalAmount.toString(),
                                            13,
                                            kTitle2, // kNew4
                                            2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                              child: kTitleText('Stock and Payment History', 14,
                                  Colors.black.withOpacity(0.6))),
                          SizedBox(height: 8),
                          Flexible(
                            flex: 5,
                            child: SupplierStocksOrdersHistoryView(
                                supplierId: widget.supplierId),
                          ),
                          SizedBox(height: 10),
                          Center(
                              child: kTitleText('Bank Accounts', 14,
                                  Colors.black.withOpacity(0.6))),
                          SizedBox(height: 8),
                          Flexible(
                              flex: 3,
                              child: SupplierBankAccountsView(
                                supplierId: widget.supplierId,
                              )),
                          Row(
                            children: [
                              Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    if (supplier.amountRemaining > 0) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentToSupplierView(
                                                  supplierId: widget.supplierId)));
                                    } else {
                                      Utils.showMessage('Nothing to pay!');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                    supplier.amountRemaining > 0
                                        ? kTwo
                                        : kNew9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    backgroundColor:
                                    supplier.amountRemaining > 0
                                        ? kNew7
                                        : kNew9a,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Payment',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ))
                            ],
                          )
                        ],
                      );
                    }
                    return Center(
                      child: Text('Try again'),
                    );
                  }),
        ),
      ),
    );
  }
}
// Consumer<SupplierDetailsViewModel>(
//                         builder: (BuildContext context,
//                                 SupplierDetailsViewModel value, Widget? child) =>
//                             Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: RoundButton(
//                             title: 'Payment',
//                             onPress: () {
//                               /// todo: this button is disappear if the supplier has no orders
//                               ///todo: this will add the payment in the stock order history + it will add in the cashbook as well
//                               ///todo: reduce the amount from the supplier total amount, add it into the paid amount, calculate the remaining amount
//                               ///todo: this payment has to be shown in the stock order history view as well, but in red color or any color other than the stock order history tile colors
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => PaymentView(
//                                       supplierId: widget.supplier.supplierId),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
///

// Container(
//   color: kSecColor,
//   child: Column(
//     children: [
//       const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text('Total'),
//           Text('Paid'),
//           Text('Remaining'),
//         ],
//       ),
//       // Row(
//       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //   children: [
//       //     Text('${widget.totalAmount}'),
//       //     Text('${widget.paidAmount}'),
//       //     Text('${widget.remainingAmount}'),
//       //   ],
//       // ),
//     ],
//   ),
// ),
