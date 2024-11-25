import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing_press/model/cashbook_entry.dart';

class CashbookEntryDetailsView extends StatefulWidget {
  const CashbookEntryDetailsView({
    super.key,
    required this.cashbookEntry,
  });

  final CashbookEntry cashbookEntry;

  @override
  State<CashbookEntryDetailsView> createState() =>
      _CashbookEntryDetailsViewState();
}

class _CashbookEntryDetailsViewState extends State<CashbookEntryDetailsView> {
  late String formattedDateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///todo: formatted date has to be used
    formattedDateTime =
        DateFormat('dd MMMM yyyy').format(widget.cashbookEntry.paymentDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Entry Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Payment Id: '),
                Text(widget.cashbookEntry.cashbookEntryId.toString()),
              ],
            ),
            Row(
              children: widget.cashbookEntry.customerOrderId == null
                  ? widget.cashbookEntry.supplierId == null
                      ? [
                          const Text('RANDOM ENTRY'),
                        ]
                      : [
                          const Text('Supplier Id: '),
                          Text(widget.cashbookEntry.supplierId.toString()),
                        ]
                  : [
                      const Text('Order Id: '),
                      Text(widget.cashbookEntry.customerOrderId.toString()),
                    ],
            ),
            Row(
              children: [
                const Text('Payment time: '),
                Text(formattedDateTime),
              ],
            ),
            Row(
              children: [
                const Text('Paid Amount: '),
                Text(widget.cashbookEntry.amount.toString()),
              ],
            ),
            Row(
              children: [
                const Text('Payment type: '),
                Text(widget.cashbookEntry.paymentType.toString()),
              ],
            ),
            Row(
              children: [
                const Text('Payment Method: '),
                Text(widget.cashbookEntry.paymentMethod.toString()),
              ],
            ),
            Row(
              children: [
                const Text('Description: '),
                Text(widget.cashbookEntry.description.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
