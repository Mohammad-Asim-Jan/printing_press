import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/customer_custom_order.dart';
import 'package:printing_press/model/stock_order_by_customer.dart';
import 'package:printing_press/view_model/orders/all_orders_view_model.dart';
import 'package:printing_press/views/orders/customer_order_detail_view.dart';
import 'package:provider/provider.dart';
import '../../components/custom_circular_indicator.dart';
import '../../text_styles/custom_text_styles.dart';

class AllOrdersView extends StatefulWidget {
  const AllOrdersView({super.key});

  @override
  State<AllOrdersView> createState() => _AllOrdersViewState();
}

class _AllOrdersViewState extends State<AllOrdersView> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Consumer<AllOrdersViewModel>(builder: (context, value, child) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: value.getAllCustomerOrders(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomCircularIndicator();
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                value.allCustomerOrdersList = snapshot.data!.docs.map((e) {
                  Map<String, dynamic> data = e.data();
                  if (data['bookQuantity'] != null) {
                    /// This is a customer custom order doc
                    return CustomerCustomOrder.fromJson(e.data());
                  } else {
                    /// This is a customer stock order document
                    return StockOrderByCustomer.fromJson(e.data());
                  }
                }).toList();

                if (value.allCustomerOrdersList.isEmpty) {
                  return const Center(child: Text('No order found!'));
                }

                /// todo: Searching
                /// todo: Filtering unpaid, incomplete orders
                /// todo: Set new placed order status as 'New order'
                /// todo: Order tracking
                return Expanded(
                    child: ListView.builder(
                        itemCount: value.allCustomerOrdersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool isCustomOrder =
                              value.allCustomerOrdersList[index]
                                  is CustomerCustomOrder;

                          late CustomerCustomOrder customOrder;
                          late StockOrderByCustomer stockOrder;

                          if (isCustomOrder) {
                            customOrder = value.allCustomerOrdersList[index];
                            value.checkStatus(
                                customOrder.orderResumedDateTime.toDate(),
                                customOrder.orderStatus,
                                customOrder.customerOrderId);
                          } else {
                            stockOrder = value.allCustomerOrdersList[index];
                          }

                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  debugPrint('Is custom order? $isCustomOrder');
                                  return CustomerOrderDetailView(
                                      customerOrderId: isCustomOrder
                                          ? customOrder.customerOrderId
                                          : stockOrder.customerOrderId,
                                      isCustomOrder: isCustomOrder);
                                }));
                              },
                              child: Card(
                                  // color: isCustomOrder
                                  //     ? Color(0xffD0D7D4)
                                  //     : Color(0xffdbdee4),
                                  // shadowColor: Colors.indigo.withOpacity(0.1),
                                  margin: EdgeInsets.only(bottom: 10),
                                  elevation: 1.5,
                                  shadowColor: Colors.blue.withOpacity(0.1),
                                  color: Colors.blue.withOpacity(.15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                          textBaseline: TextBaseline.alphabetic,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          children: [
                                            SizedBox(width: 5),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Order no.',
                                                      style:
                                                          kDescriptionTextStyle
                                                              .copyWith(
                                                                  fontSize: 9)),
                                                  SizedBox(height: 4),
                                                  kDescriptionText(
                                                      (isCustomOrder
                                                              ? customOrder
                                                                  .customerOrderId
                                                              : stockOrder
                                                                  .customerOrderId)
                                                          .toString(),
                                                      10),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              flex: 7,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  kTitleText(
                                                      (isCustomOrder
                                                          ? customOrder
                                                              .businessTitle
                                                          : stockOrder
                                                              .businessTitle),
                                                      12),
                                                  SizedBox(height: 4),
                                                  kTitleText(
                                                      (isCustomOrder
                                                          ? customOrder
                                                              .customerAddress
                                                          : stockOrder
                                                              .customerAddress),
                                                      10,
                                                      Colors.blueGrey.shade600),
                                                  SizedBox(height: 4),
                                                  kTitleText(
                                                      (isCustomOrder
                                                          ? customOrder
                                                              .customerContact
                                                          : stockOrder
                                                              .customerContact),
                                                      10,
                                                      Colors.blueGrey.shade600),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              flex: 6,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Balance',
                                                      style:
                                                          kDescriptionTextStyle
                                                              .copyWith(
                                                                  fontSize: 9)),
                                                  SizedBox(height: 4),
                                                  kDescriptionText(
                                                      'Rs. ${(isCustomOrder ? (customOrder.totalAmount - customOrder.paidAmount) : (stockOrder.totalAmount - stockOrder.paidAmount))}',
                                                      12),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Column(
                                              children: [
                                                Text('Status',
                                                    style: kDescriptionTextStyle
                                                        .copyWith(fontSize: 9)),
                                                SizedBox(height: 5),
                                                value.getStatusIcon(
                                                    isCustomOrder
                                                        ? (customOrder
                                                            .orderStatus)
                                                        : (stockOrder
                                                            .orderStatus)),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                          ]))));
                        }));
              }
              return const Text('No data!');
            });
      })
    ]);
  }
}
