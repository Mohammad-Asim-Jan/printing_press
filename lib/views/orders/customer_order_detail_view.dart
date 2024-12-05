import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/customer_custom_order.dart';
import 'package:printing_press/model/stock_order_by_customer.dart';
import 'package:printing_press/view_model/orders/customer_order_detail_view_model.dart';
import 'package:printing_press/views/orders/track_customer_order.dart';
import 'package:printing_press/views/payment/payment_from_customer_view.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import '../../components/custom_circular_indicator.dart';
import '../../text_styles/custom_text_styles.dart';
import '../../utils/toast_message.dart';
import 'customer_payment_history.dart';

class CustomerOrderDetailView extends StatefulWidget {
  const CustomerOrderDetailView({
    super.key,
    required this.customerOrderId,
    required this.isCustomOrder,
  });

  final int customerOrderId;
  final bool isCustomOrder;

  @override
  State<CustomerOrderDetailView> createState() =>
      _CustomerOrderDetailViewState();
}

class _CustomerOrderDetailViewState extends State<CustomerOrderDetailView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint('Is Custom Order: ${widget.isCustomOrder}');
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD0D7D4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kNew9a,
        title: Text('Order Details',
            style: TextStyle(
                color: kNew9a,
                fontSize: 20,
                letterSpacing: 0,
                fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<CustomerOrderDetailViewModel>(
          builder: (BuildContext context, CustomerOrderDetailViewModel value,
                  Widget? child) =>
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: value.getCustomerOrderData(widget.customerOrderId),
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
                      return Center(
                          child: Text(
                        'Data is unavailable',
                      ));
                    }
                    if (snapshot.hasData) {
                      late CustomerCustomOrder customOrderModel;
                      late StockOrderByCustomer stockOrderByCustomer;
                      if (widget.isCustomOrder) {
                        customOrderModel = CustomerCustomOrder.fromJson(
                            snapshot.data!.data()!);
                      } else {
                        stockOrderByCustomer = StockOrderByCustomer.fromJson(
                            snapshot.data!.data()!);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kTitleText(
                              "Order No. ${widget.isCustomOrder ? customOrderModel.customerOrderId : stockOrderByCustomer.customerOrderId}",
                              10,
                              kThirdColor,
                              2),
                          Row(
                            children: [
                              kTitleText(
                                  widget.isCustomOrder
                                      ? customOrderModel.businessTitle
                                      : stockOrderByCustomer.businessTitle,
                                  24,
                                  kThirdColor,
                                  2),
                            ],
                          ),
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
                                          widget.isCustomOrder
                                              ? customOrderModel.customerName
                                              : stockOrderByCustomer
                                                  .customerName,
                                          16,
                                          kNew6),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      kDescription3Text(
                                          widget.isCustomOrder
                                              ? customOrderModel.customerAddress
                                              : stockOrderByCustomer
                                                  .customerAddress,
                                          null,
                                          2,
                                          12),
                                    ],
                                  )),
                              SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  widget.isCustomOrder
                                      ? customOrderModel.customerContact
                                      : stockOrderByCustomer.customerContact,
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
                                            (widget.isCustomOrder
                                                    ? customOrderModel
                                                        .paidAmount
                                                    : stockOrderByCustomer
                                                        .paidAmount)
                                                .toString(),
                                            13,
                                            kOne, // kNew4
                                            2),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: kTitleText(
                                              (widget.isCustomOrder
                                                      ? customOrderModel
                                                              .totalAmount -
                                                          customOrderModel
                                                              .paidAmount
                                                      : stockOrderByCustomer
                                                              .totalAmount -
                                                          stockOrderByCustomer
                                                              .paidAmount)
                                                  .toString(),
                                              13,
                                              kNew8, // kNew4
                                              2)),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            (widget.isCustomOrder
                                                    ? customOrderModel
                                                        .totalAmount
                                                    : stockOrderByCustomer
                                                        .totalAmount)
                                                .toString(),
                                            13,
                                            kNew9a, // kNew4
                                            2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          widget.isCustomOrder
                              ? SizedBox.shrink()
                              : kTitleText('Stock Details', 14,
                                  Colors.black.withOpacity(0.6)),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                    border: TableBorder(
                                        horizontalInside: BorderSide(
                                            width: 0.5,
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    textBaseline: TextBaseline.alphabetic,
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.baseline,
                                    columnWidths: {
                                      0: FractionColumnWidth(0.22),
                                      1: FractionColumnWidth(0.2),
                                      2: FractionColumnWidth(0.2),
                                      3: FractionColumnWidth(0.18),
                                      4: FractionColumnWidth(0.2),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: kTitleText(
                                                  widget.isCustomOrder
                                                      ? 'Machine'
                                                      : 'Name',
                                                  10,
                                                  Colors.black.withOpacity(0.6),
                                                  2)),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: kTitleText(
                                                widget.isCustomOrder
                                                    ? 'Copy Variant'
                                                    : 'Category',
                                                10,
                                                Colors.black.withOpacity(0.6),
                                                2),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: kTitleText(
                                                widget.isCustomOrder
                                                    ? 'Size'
                                                    : 'Color',
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
                                                widget.isCustomOrder
                                                    ? 'Pages/book'
                                                    : 'Price',
                                                10,
                                                Colors.black.withOpacity(0.6),
                                                2),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: kTitleText(
                                                widget.isCustomOrder
                                                    ? customOrderModel
                                                        .machineName
                                                    : stockOrderByCustomer
                                                        .stockName,
                                                10,
                                                null,
                                                2),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: kTitleText(
                                                widget.isCustomOrder
                                                    ? customOrderModel
                                                            .copyVariant ??
                                                        'None'
                                                    : stockOrderByCustomer
                                                        .stockCategory,
                                                10,
                                                null,
                                                2),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: kTitleText(
                                                widget.isCustomOrder
                                                    ? customOrderModel.paperSize
                                                    : stockOrderByCustomer
                                                            .stockColor ??
                                                        'Nil',
                                                10,
                                                null,
                                                2),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: kTitleText(
                                                widget.isCustomOrder
                                                    ? customOrderModel
                                                        .bookQuantity
                                                        .toString()
                                                    : stockOrderByCustomer
                                                        .stockQuantity
                                                        .toString(),
                                                12,
                                                kNew4,
                                                2),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: kTitleText(
                                                widget.isCustomOrder
                                                    ? customOrderModel
                                                        .pagesPerBook
                                                        .toString()
                                                    : stockOrderByCustomer
                                                        .stockUnitSellPrice
                                                        .toString(),
                                                12,
                                                kNew8,
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
                          widget.isCustomOrder
                              ? Expanded(
                                  flex: 5,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        kTitleText('Color', 14,
                                            Colors.black.withOpacity(0.6)),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Expanded(
                                                child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: kTitleText(
                                                          'Front Print Type',
                                                          10,
                                                          Colors.black
                                                              .withOpacity(0.6),
                                                          2)),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: kTitleText(
                                                        '${customOrderModel.frontPrintType} Color',
                                                        10,
                                                        null,
                                                        2),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            Expanded(
                                                child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: kTitleText(
                                                          'Backside Print Type',
                                                          10,
                                                          Colors.black
                                                              .withOpacity(0.6),
                                                          2)),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: kTitleText(
                                                        (customOrderModel
                                                                    .backPrintType ==
                                                                -1)
                                                            ? 'No backside'
                                                            : '${customOrderModel.backPrintType} Color',
                                                        10,
                                                        null,
                                                        2),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        kTitleText('Expenses', 14,
                                            Colors.black.withOpacity(0.6)),
                                        SizedBox(height: 8),
                                        Table(
                                          border: TableBorder.all(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            width: 0.5,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          textBaseline: TextBaseline.alphabetic,
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment
                                                  .baseline,
                                          columnWidths: {
                                            0: FractionColumnWidth(0.25),
                                            1: FractionColumnWidth(0.25),
                                            2: FractionColumnWidth(0.25),
                                            3: FractionColumnWidth(0.25),
                                          },
                                          children: [
                                            TableRow(
                                              decoration: BoxDecoration(
                                                  color: Colors.blueGrey
                                                      .withOpacity(0.4)),
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    child: kTitleText(
                                                        'Name',
                                                        10,
                                                        Colors.black
                                                            .withOpacity(0.6),
                                                        2)),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Expenses',
                                                      10,
                                                      Colors.black
                                                          .withOpacity(0.6),
                                                      2),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    child: kTitleText(
                                                        'Name',
                                                        10,
                                                        Colors.black
                                                            .withOpacity(0.6),
                                                        2)),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Expenses',
                                                      10,
                                                      Colors.black
                                                          .withOpacity(0.6),
                                                      2),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Design', 10, null, 2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      customOrderModel
                                                                  .designRate ==
                                                              null
                                                          ? 'None'
                                                          : customOrderModel
                                                              .designRate
                                                              .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Paper', 10, null, 2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      customOrderModel
                                                          .paperExpenses
                                                          .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Printing', 10, null, 2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      customOrderModel
                                                          .printingExpense
                                                          .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Plates', 10, null, 2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      customOrderModel
                                                          .plateExpense
                                                          .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Binding', 10, null, 2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      customOrderModel
                                                                  .bindingExpenses ==
                                                              null
                                                          ? 'None'
                                                          : customOrderModel
                                                              .bindingExpenses
                                                              .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Cutting', 10, null, 2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      customOrderModel
                                                                  .paperCuttingExpenses ==
                                                              null
                                                          ? 'None'
                                                          : customOrderModel
                                                              .paperCuttingExpenses
                                                              .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Numbering', 10, null, 2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      customOrderModel
                                                                  .numberingExpenses ==
                                                              null
                                                          ? 'None'
                                                          : customOrderModel
                                                              .numberingExpenses
                                                              .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Other Expenses',
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      customOrderModel
                                                                  .otherExpenses ==
                                                              null
                                                          ? 'None'
                                                          : customOrderModel
                                                              .otherExpenses
                                                              .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      'Copy Variant',
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      (customOrderModel
                                                                  .carbonExpenses ??
                                                              customOrderModel
                                                                  .carbonLessExpenses ??
                                                              customOrderModel
                                                                  .newsPaperExpenses ??
                                                              'None')
                                                          .toString(),
                                                      10,
                                                      null,
                                                      2),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      '', 10, null, 2),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: kTitleText(
                                                      '', 10, null, 2),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                              : SizedBox.shrink(),
                          SizedBox(height: 8),
                          kTitleText('Payment History', 14,
                              Colors.black.withOpacity(0.6)),
                          SizedBox(height: 8),
                          Expanded(
                            flex: 3,
                            child: CustomerPaymentHistory(
                                customerOrderId: widget.isCustomOrder
                                    ? customOrderModel.customerOrderId
                                    : stockOrderByCustomer.customerOrderId),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TrackCustomerOrder(
                                                    currentStatus:
                                                        'Completed')));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: kPrimeColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 1),
                                    backgroundColor: Color(0xffD0D7D4),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: kPrimeColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12),
                                      child: Text('Track Order',
                                          style: TextStyle(fontSize: 14)))),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: getStatusIcon(widget.isCustomOrder
                                      ? customOrderModel.orderStatus
                                      : stockOrderByCustomer.orderStatus),
                                ),
                                kTitleText(
                                    widget.isCustomOrder
                                        ? customOrderModel.orderStatus
                                        : stockOrderByCustomer.orderStatus,
                                    16,
                                    statusColor[index])
                              ]),
                              ElevatedButton(
                                  onPressed: () {
                                    if ((widget.isCustomOrder
                                            ? customOrderModel.totalAmount -
                                                customOrderModel.paidAmount
                                            : stockOrderByCustomer.totalAmount -
                                                stockOrderByCustomer
                                                    .paidAmount) >
                                        0) {
                                      /// todo: payment from customer that has to be added in the whole history of the customer order
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentFromCustomerView(
                                                  customerOrderId:
                                                      widget
                                                              .isCustomOrder
                                                          ? customOrderModel
                                                              .customerOrderId
                                                          : stockOrderByCustomer
                                                              .customerOrderId,
                                                  remainingAmount: widget
                                                          .isCustomOrder
                                                      ? (customOrderModel
                                                              .totalAmount -
                                                          customOrderModel
                                                              .paidAmount)
                                                      : (stockOrderByCustomer
                                                              .totalAmount -
                                                          stockOrderByCustomer
                                                              .paidAmount))));
                                    } else {
                                      Utils.showMessage('Nothing to pay!');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: (widget.isCustomOrder
                                                ? customOrderModel.totalAmount -
                                                    customOrderModel.paidAmount
                                                : stockOrderByCustomer
                                                        .totalAmount -
                                                    stockOrderByCustomer
                                                        .paidAmount) >
                                            0
                                        ? kTwo
                                        : kNew9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: (widget.isCustomOrder
                                                ? customOrderModel.totalAmount -
                                                    customOrderModel.paidAmount
                                                : stockOrderByCustomer
                                                        .totalAmount -
                                                    stockOrderByCustomer
                                                        .paidAmount) >
                                            0
                                        ? kNew7
                                        : kNew9a,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12),
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

  List<Color> statusColor = [
    Colors.blue,
    Colors.amber,
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.purple.withOpacity(0.5),
    Colors.grey,
  ];

  Widget getStatusIcon(String status) {
    switch (status) {
      case 'New Order':
        index = 0;
        return Icon(Icons.fiber_new, color: Colors.blue);
      case 'In Progress':
        index = 1;
        return Icon(Icons.autorenew, color: Colors.amber);
      case 'Pending':
        index = 2;
        return Icon(Icons.hourglass_top, color: Colors.orange);
      case 'Cancelled':
        index = 3;
        return Icon(Icons.cancel, color: Colors.red);
      case 'Completed':
        index = 4;
        return Icon(Icons.check_circle, color: Colors.green);
      case 'Handed Over':
        index = 5;
        return Icon(Icons.inventory_2, color: Colors.purple.withOpacity(0.5));
      default:
        index = 6;
        return Icon(Icons.help_outline, color: Colors.grey); // Unknown status
    }
  }
}
