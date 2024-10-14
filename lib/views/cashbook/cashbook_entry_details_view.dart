import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing_press/model/payment.dart';

class CashbookEntryDetailsView extends StatefulWidget {
  const CashbookEntryDetailsView({
    super.key,
    required this.payment,
  });

  final Payment payment;

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

    formattedDateTime = DateFormat('dd MMMM yyyy, hh:mm a')
        .format(widget.payment.paymentDateTime.toDate());
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
                Text(widget.payment.paymentId.toString()),
              ],
            ),
            Row(
              children: widget.payment.customerOrderId == null
                  ? widget.payment.supplierId == null
                      ? [
                          const Text('RANDOM ENTRY'),
                        ]
                      : [
                          const Text('Supplier Id: '),
                          Text(widget.payment.supplierId.toString()),
                        ]
                  : [
                      const Text('Order Id: '),
                      Text(widget.payment.customerOrderId.toString()),
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
                Text(widget.payment.amount.toString()),
              ],
            ),
            Row(
              children: [
                const Text('Payment type: '),
                Text(widget.payment.paymentType.toString()),
              ],
            ),
            Row(
              children: [
                const Text('Payment Method: '),
                Text(widget.payment.paymentMethod.toString()),
              ],
            ),
            Row(
              children: [
                const Text('Description: '),
                Text(widget.payment.description.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
