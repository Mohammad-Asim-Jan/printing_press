import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
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

          int receivedAmount = 0;
          int depositedAmount = 0;
          bool change = false;

          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10),
            itemCount: (value.allCashbookEntries.length + 1),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(height: 80);
              }

              CashbookEntry cashbookEntry = value.allCashbookEntries[index - 1];

              bool isCashIn = cashbookEntry.paymentType == 'CASH-IN';
              String source = 'Supplier';
              String title = 'Random';

              if (cashbookEntry.supplierId != null) {
                source = 'Supplier';
                // title = await value.getSupplierName(cashbookEntry.supplierId);
              } else if (cashbookEntry.customerOrderId != null) {
                source = 'Customer';
                // title = value.;
              } else {
                source = 'Random';
              }

              bool isSameDate = false;
              String? newDate = '';

              if ((index - 1 == 0 && value.allCashbookEntries.length == 1) ||
                  (index == value.allCashbookEntries.length)) {
                newDate = value
                    .groupMessageDateAndTime(value.allCashbookEntries[index - 1]
                        .paymentDateTime.microsecondsSinceEpoch
                        .toString())
                    .toString();
                if (isCashIn) {
                  receivedAmount += cashbookEntry.amount;
                } else {
                  depositedAmount += cashbookEntry.amount;
                }
              } else if (index - 1 == 0) {
                if (isCashIn) {
                  receivedAmount += cashbookEntry.amount;
                } else {
                  depositedAmount += cashbookEntry.amount;
                }
              } else {
                final DateTime date = value.returnDateAndTimeFormat(value
                    .allCashbookEntries[index - 1]
                    .paymentDateTime
                    .microsecondsSinceEpoch
                    .toString());

                final DateTime prevDate = value.returnDateAndTimeFormat(value
                    .allCashbookEntries[index]
                    .paymentDateTime
                    .microsecondsSinceEpoch
                    .toString());

                isSameDate = date.isAtSameMomentAs(prevDate);

                if (change) {
                  receivedAmount = 0;
                  depositedAmount = 0;
                }
                if (isCashIn) {
                  receivedAmount += cashbookEntry.amount;
                } else {
                  depositedAmount += cashbookEntry.amount;
                }

                change = !isSameDate;

                newDate = isSameDate
                    ? ''
                    : value
                        .groupMessageDateAndTime(value
                            .allCashbookEntries[index - 1]
                            .paymentDateTime
                            .microsecondsSinceEpoch
                            .toString())
                        .toString();
              }
              return Column(
                children: [
                  newDate.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: kThirdColor.withOpacity(0.8)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      'Received',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blue.shade100,
                                          fontFamily: 'Urbanist'),
                                    ),
                                    kTitleText('Rs. $receivedAmount', 12,
                                        Colors.white, 1),
                                  ],
                                )),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                  newDate,
                                  style: TextStyle(
                                      color: Colors.blue.shade100,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Urbanist'),
                                ))),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      'Deposited',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blue.shade100,
                                          fontFamily: 'Urbanist'),
                                    ),
                                    kTitleText('Rs. $depositedAmount', 12,
                                        Colors.white, 1),
                                  ],
                                )),
                              ],
                            ),
                          ))
                      : SizedBox.shrink(),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isCashIn
                          ? Colors.green.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                              isCashIn
                                  ? Icons.payment
                                  : Icons.shopping_cart_outlined,
                              color: isCashIn
                                  ? Colors.green.shade500
                                  : kPrimeColor,
                              size: 20),
                        ),
                        Expanded(
                          child: Table(
                            border: TableBorder(
                                horizontalInside: BorderSide(
                                    width: 0.25,
                                    color: Colors.black.withOpacity(0.5))),
                            textBaseline: TextBaseline.alphabetic,
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.baseline,
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
                                      child: Text(
                                          source == 'Random'
                                              ? 'Source'
                                              : source,
                                          style: kDescriptionTextStyle.copyWith(
                                            fontSize: 9,
                                          ))),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Description',
                                      style: kDescriptionTextStyle.copyWith(
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Payment Method',
                                      style: kDescriptionTextStyle.copyWith(
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Amount',
                                      style: kDescriptionTextStyle.copyWith(
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Date',
                                      style: kDescriptionTextStyle.copyWith(
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  source == 'Random'
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: kTitleText(title, 10, null, 2),
                                        )
                                      : StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                          stream: source == 'Supplier'
                                              ? value.getSupplierName(
                                                  cashbookEntry.supplierId!)
                                              : value.getCustomerBusinessTitle(
                                                  cashbookEntry
                                                      .customerOrderId!),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<
                                                      DocumentSnapshot<
                                                          Map<String, dynamic>>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: kTitleText(
                                                    'Not available',
                                                    10,
                                                    null,
                                                    1),
                                              );
                                            }
                                            if (snapshot.hasError) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: kTitleText(
                                                    'error!', 10, null, 2),
                                              );
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
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    child: kTitleText(
                                                        title, 10, null, 2));
                                              }
                                            }
                                            return Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: kTitleText(
                                                    'Nil', 10, null, 2));
                                          },
                                        ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: kTitleText(
                                        cashbookEntry.description ?? 'Nil',
                                        10,
                                        null,
                                        2),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: kTitleText(
                                        cashbookEntry.paymentMethod ?? 'Nil',
                                        10,
                                        null,
                                        2),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: kTitleText(
                                        cashbookEntry.amount.toString(),
                                        10,
                                        null,
                                        2),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: kTitleText(
                                        formatDate(
                                            cashbookEntry.paymentDateTime),
                                        10,
                                        null,
                                        2),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const Text('No data!');
      },
    );
  }
}
