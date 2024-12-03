import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/utils/date_format.dart';
import 'package:printing_press/view_model/orders/customer_order_detail_view_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_circular_indicator.dart';
import '../../model/cashbook_entry.dart';
import '../../text_styles/custom_text_styles.dart';

class CustomerPaymentHistory extends StatefulWidget {
  const CustomerPaymentHistory({super.key, required this.customerOrderId});

  final int customerOrderId;

  @override
  State<CustomerPaymentHistory> createState() => _CustomerPaymentHistoryState();
}

class _CustomerPaymentHistoryState extends State<CustomerPaymentHistory> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerOrderDetailViewModel>(
        builder: (BuildContext context, CustomerOrderDetailViewModel value,
                Widget? child) =>
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: value.getCustomerPaymentHistory(widget.customerOrderId),
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
                    value.customerOrderHistoryList =
                        snapshot.data!.docs.map((e) {
                      Map<String, dynamic> data = e.data();
                      return CashbookEntry.fromJson(data);
                    }).toList();

                    if (value.customerOrderHistoryList.isEmpty) {
                      return Center(
                          child: Text('No entry found',
                              style: kDescriptionTextStyle));
                    }
                    return ListView.builder(
                        itemCount: value.customerOrderHistoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          CashbookEntry entry =
                              value.customerOrderHistoryList[index];

                          debugPrint('Order id: ${entry.cashbookEntryId}');

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
                                                    entry.paymentMethod ??
                                                        'Nil',
                                                    12,
                                                    null,
                                                    2)),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  entry.description ?? 'Nil',
                                                  12,
                                                  null,
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  entry.amount.toString(),
                                                  12,
                                                  null,
                                                  2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  formatDate(
                                                      entry.paymentDateTime),
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
                        });
                  }
                  return const Text('No data!');
                }));
  }
}
