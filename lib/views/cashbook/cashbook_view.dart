import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/components/custom_circular_indicator.dart';
import 'package:printing_press/model/cashbook_entry.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/utils/date_format.dart';
import 'package:printing_press/view_model/cashbook/cashbook_view_model.dart';
import 'package:provider/provider.dart';

class CashbookView extends StatefulWidget {
  const CashbookView({super.key});

  @override
  State<CashbookView> createState() => _CashbookViewState();
}

class _CashbookViewState extends State<CashbookView> {
  late CashbookViewModel value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = Provider.of<CashbookViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: value.getCashbookData(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          value.allCashbookEntries = snapshot.data!.docs
              .map((e) => CashbookEntry.fromJson(e.data()))
              .toList();

          if (value.allCashbookEntries.isEmpty) {
            return const Center(child: Text('No entry found!'));
          }

          return ListView.builder(
            itemCount: value.allCashbookEntries.length,
            itemBuilder: (BuildContext context, int index) {
              CashbookEntry cashbookEntry = value.allCashbookEntries[index];

              bool isCashIn = cashbookEntry.paymentType == 'CASH-IN';
              String source = 'Supplier';
              String title = 'Random';

              if (cashbookEntry.supplierId != null) {
                source = 'Supplier';
                // title = await value.getSupplierName(cashbookEntry.supplierId);
                /// todo: get the name of the supplier and customer business title as well
              } else if (cashbookEntry.customerOrderId != null) {
                source = 'Customer';
                // title = value.;
              } else {
                source = 'Random';
              }
              debugPrint('Source ----- $source');
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isCashIn
                      ? Colors.green.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Icon(
                        isCashIn ? Icons.payment : Icons.shopping_cart_outlined,
                        color: isCashIn
                            ? Colors.green.shade500
                            : Colors.blueGrey.shade600),
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
                                      source == 'Random' ? 'Source' : source,
                                      10,
                                      Colors.black.withOpacity(0.6),
                                      2),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: kTitleText('Description', 9,
                                      Colors.black.withOpacity(0.6), 2),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: kTitleText('Payment Method', 10,
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
                                source == 'Random'
                                    ? kTitleText(title, 12, null, 2)
                                    : StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                        stream: source == 'Supplier'
                                            ? value.getSupplierName(
                                                cashbookEntry.supplierId!)
                                            : value.getCustomerBusinessTitle(
                                                cashbookEntry.customerOrderId!),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(child: Text('...'));
                                          }
                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text('error!'));
                                          }

                                          if (snapshot.hasData) {
                                            if (snapshot.data!.exists) {
                                              if (source == 'Supplier') {
                                                title = snapshot.data
                                                    ?.get('supplierName');
                                              } else {
                                                title = snapshot.data
                                                    ?.get('businessTitle');
                                              }
                                              return Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      title, 12, null, 2));
                                            }
                                          }
                                          return Text('...');
                                        },
                                      ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: kTitleText(
                                      cashbookEntry.description ?? 'Nil',
                                      12,
                                      null,
                                      2),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: kTitleText(
                                      cashbookEntry.paymentMethod ?? 'Nil',
                                      12,
                                      null,
                                      2),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: kTitleText(
                                      cashbookEntry.amount.toString(),
                                      12,
                                      null,
                                      2),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: kTitleText(
                                      formatDate(cashbookEntry.paymentDateTime),
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
            },
          );
        }
        return const Text('No data!');
      },
    );
  }
}
