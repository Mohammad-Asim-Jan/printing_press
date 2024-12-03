import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/customer_custom_order.dart';
import 'package:printing_press/model/stock_order_by_customer.dart';
import 'package:printing_press/view_model/orders/customer_order_detail_view_model.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD0D7D4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kNew9a,
        title: Text('Order Details',
            style: TextStyle(
                color: kNew9a,
                fontSize: 21,
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
                              widget.isCustomOrder
                                  ? customOrderModel.businessTitle
                                  : stockOrderByCustomer.businessTitle,
                              28,
                              kThirdColor),
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
                          Center(
                              child: kTitleText('Payment History', 14,
                                  Colors.black.withOpacity(0.6))),
                          SizedBox(height: 8),
                          Flexible(
                            child: CustomerPaymentHistory(
                                customerOrderId: widget.isCustomOrder
                                    ? customOrderModel.customerOrderId
                                    : stockOrderByCustomer.customerOrderId),
                          ),
                          Row(
                            children: [
                              Spacer(),
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

  ///
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Color(0xffD0D7D4),
//     appBar: AppBar(title: const Text('Order details'), backgroundColor: Colors.transparent, foregroundColor: kNew9a,),
//     body: Padding(
//       padding: const EdgeInsets.all(8),
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: widget.customerCustomOrder != null
//               ? [
//                   Container(
//                       padding: EdgeInsets.all(6),
//                       color: Colors.white60,
//                       margin: EdgeInsets.all(5),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(
//                                 'Paid Amount',
//                                 style: Theme.of(context).textTheme.labelLarge,
//                               ),
//                               Text(
//                                 'Total Amount',
//                                 style: Theme.of(context).textTheme.labelLarge,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(widget.customerCustomOrder!.paidAmount
//                                   .toString()),
//                               Text(widget.customerCustomOrder!.totalAmount
//                                   .toString()),
//                             ],
//                           ),
//                         ],
//                       )),
//                   Text(
//                       'Order Id: ${widget.customerCustomOrder!.customerOrderId.toString()}'),
//                   Row(
//                     children: [
//                       const Text('Customer Name'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.customerName),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Business Title'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.businessTitle),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Contact No.'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.customerContact
//                           .toString()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Customer address'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.customerAddress),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Machine Name'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.machineName),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Book Quantity'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.bookQuantity
//                           .toString()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Pages per book'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.bookQuantity
//                           .toString()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Order Status'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.orderStatus),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Order time'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.customerCustomOrder!.orderDateTime
//                           .toDate()
//                           .toString()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Order due time'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       widget.customerCustomOrder!.orderDueDateTime == null
//                           ? const Text('Not set')
//                           : Text(widget.customerCustomOrder!.orderDueDateTime!
//                               .toDate()
//                               .toString()),
//                     ],
//                   ),
//                 ]
//               : [
//                   Container(
//                       padding: const EdgeInsets.all(6),
//                       color: Colors.white60,
//                       margin: EdgeInsets.all(5),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(
//                                 'Paid Amount',
//                                 style: Theme.of(context).textTheme.labelLarge,
//                               ),
//                               Text(
//                                 'Total Amount',
//                                 style: Theme.of(context).textTheme.labelLarge,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(widget.stockOrderByCustomer!.paidAmount
//                                   .toString()),
//                               Text(widget.stockOrderByCustomer!.totalAmount
//                                   .toString()),
//                             ],
//                           ),
//                         ],
//                       )),
//                   Text(
//                       'Order Id: ${widget.stockOrderByCustomer!.customerOrderId.toString()}'),
//                   Row(
//                     children: [
//                       const Text('Customer Name'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.stockOrderByCustomer!.customerName),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Business Title'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.stockOrderByCustomer!.businessTitle),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Contact No.'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.stockOrderByCustomer!.customerContact
//                           .toString()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Customer address'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.stockOrderByCustomer!.customerAddress),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Stock Ordered'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.stockOrderByCustomer!.stockName),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Stock Price'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.stockOrderByCustomer!.stockUnitSellPrice
//                           .toString()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Order Status'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.stockOrderByCustomer!.orderStatus),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text('Order time'),
//                       const SizedBox(
//                         width: 50,
//                       ),
//                       Text(widget.stockOrderByCustomer!.orderDateTime
//                           .toDate()
//                           .toString()),
//                     ],
//                   ),
//                 ]
//       ),
//     ),
//   );
// }
}
