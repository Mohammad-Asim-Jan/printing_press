import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                        bool isCustomOrder = value.allCustomerOrdersList[index]
                            is CustomerCustomOrder;

                        late CustomerCustomOrder customOrder;
                        late StockOrderByCustomer stockOrder;

                        if (isCustomOrder) {
                          customOrder = value.allCustomerOrdersList[index];
                        } else {
                          stockOrder = value.allCustomerOrdersList[index];
                        }

                        return GestureDetector(
                          onTap: () {
                            print('is custom order $isCustomOrder');
                            isCustomOrder
                                ? print(
                                    'Custom order: ${customOrder.customerName}')
                                : print(
                                    'Stock order: ${stockOrder.customerName}');
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return CustomerOrderDetailView(
                                  customerCustomOrder:
                                      isCustomOrder ? customOrder : null,
                                  stockOrderByCustomer:
                                      isCustomOrder ? null : stockOrder);
                            }));
                          },
                          child: Card(
                            elevation: 1.5,
                            color: Colors.grey.withOpacity(0.2),
                            shadowColor: Colors.blue.withOpacity(0.15),
                            margin: EdgeInsets.only(bottom: 5, top: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                textBaseline: TextBaseline.alphabetic,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: [
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Order no.',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                fontFamily: 'Iowan',
                                                fontSize: 10)),
                                        SizedBox(height: 4),
                                        kTitleText(
                                            (isCustomOrder
                                                    ? customOrder
                                                        .customerOrderId
                                                    : stockOrder
                                                        .customerOrderId)
                                                .toString(),
                                            12,
                                            Colors.brown,
                                            2),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 7),
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        kTitleText(
                                            (isCustomOrder
                                                ? customOrder.businessTitle
                                                : stockOrder.businessTitle),
                                            16),
                                        SizedBox(height: 4),
                                        kTitleText(
                                            (isCustomOrder
                                                ? customOrder.customerContact
                                                : stockOrder.customerContact),
                                            12,
                                            kThirdColor.withOpacity(0.8)),
                                        SizedBox(height: 4),
                                        kTitleText(
                                            (isCustomOrder
                                                ? customOrder.customerAddress
                                                : stockOrder.customerAddress),
                                            11,
                                            kTitle2)
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
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                fontFamily: 'Iowan',
                                                fontSize: 12)),
                                        SizedBox(height: 4),
                                        kTitleText(
                                            'Rs. ${(isCustomOrder ? (customOrder.totalAmount - customOrder.paidAmount) : (stockOrder.totalAmount - stockOrder.paidAmount))}',
                                            14,
                                            kNew8.withOpacity(0.75),
                                            2)
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    children: [
                                      Text('Status',
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              fontFamily: 'Iowan',
                                              fontSize: 12)),
                                      SizedBox(height: 5),
                                      getStatusIcon(isCustomOrder
                                          ? (customOrder.orderStatus)
                                          : (stockOrder.orderStatus)),
                                    ],
                                  ),
                                  SizedBox(width: 5),
                                  // IconButton(
                                  //   icon: Icon(Icons.delete, color: kNew4),
                                  //   onPressed: () {
                                  //     /// todo:
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Text('No data!');
              });
        }),
      ],
    );
  }

  Widget getStatusIcon(String status) {
    switch (status) {
      case 'New Order':
        return Icon(Icons.fiber_new, color: Colors.blue);
      case 'In Progress':
        return Icon(Icons.autorenew, color: Colors.amber);
      case 'Pending':
        return Icon(Icons.hourglass_top, color: Colors.orange);
      case 'Cancelled':
        return Icon(Icons.cancel, color: Colors.red);
      case 'Completed':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'Handed Over':
        return Icon(Icons.inventory_2, color: Colors.purple.withOpacity(0.5));
      default:
        return Icon(Icons.help_outline, color: Colors.grey); // Unknown status
    }
  }
}
// ListView.builder(
//                   //   itemCount: value.allCustomerOrdersList.length,
//                   //   itemBuilder: (BuildContext context, int index) {
//                   //     if (value.allCustomerOrdersList[index]
//                   //     is CustomerCustomOrder) {
//                   //       CustomerCustomOrder customerCustomerOrder =
//                   //       value.allCustomerOrdersList[index];
//                   //       return ListTile(
//                   //         onTap: () {
//                   //           Navigator.of(context)
//                   //               .push(MaterialPageRoute(builder: (context) {
//                   //             return CustomerOrderDetailView(
//                   //                 customerCustomOrder: customerCustomerOrder);
//                   //           }));
//                   //         },
//                   //         shape: Border.all(width: 2, color: kPrimeColor),
//                   //         titleTextStyle: TextStyle(
//                   //             color: kThirdColor,
//                   //             fontSize: 18,
//                   //             fontWeight: FontWeight.w500),
//                   //         title: Text(customerCustomerOrder.businessTitle),
//                   //         tileColor: kSecColor,
//                   //         subtitleTextStyle: const TextStyle(
//                   //             color: Colors.black,
//                   //             fontStyle: FontStyle.italic),
//                   //         subtitle: Text(
//                   //             'Customer Name: ${customerCustomerOrder
//                   //                 .customerName}\nContact: ${customerCustomerOrder
//                   //                 .customerContact}'),
//                   //         leading: Text(customerCustomerOrder.customerOrderId
//                   //             .toString()),
//                   //         trailing: Text(
//                   //             customerCustomerOrder.totalAmount.toString()),
//                   //       );
//                   //     } else if (value.allCustomerOrdersList[index]
//                   //     is StockOrderByCustomer) {
//                   //       StockOrderByCustomer stockOrderByCustomer =
//                   //       value.allCustomerOrdersList[index];
//                   //       return ListTile(
//                   //         onTap: () {
//                   //           Navigator.of(context)
//                   //               .push(MaterialPageRoute(builder: (context) {
//                   //             return CustomerOrderDetailView(
//                   //                 stockOrderByCustomer: stockOrderByCustomer);
//                   //           }));
//                   //         },
//                   //         shape: Border.all(width: 2, color: kPrimeColor),
//                   //         // titleAlignment: ListTileTitleAlignment.threeLine,
//                   //         titleTextStyle: TextStyle(
//                   //             color: kThirdColor,
//                   //             fontSize: 18,
//                   //             fontWeight: FontWeight.w500),
//                   //         title: Text(stockOrderByCustomer.businessTitle),
//                   //         tileColor: kTwo,
//                   //         subtitleTextStyle: const TextStyle(
//                   //             color: Colors.black,
//                   //             fontStyle: FontStyle.italic),
//                   //         subtitle: Text(
//                   //             'Customer Name: ${stockOrderByCustomer
//                   //                 .customerName}\nContact: ${stockOrderByCustomer
//                   //                 .customerContact}'),
//                   //         leading: Text(stockOrderByCustomer.customerOrderId
//                   //             .toString()),
//                   //         trailing: Text(
//                   //             stockOrderByCustomer.totalAmount.toString()),
//                   //       );
//                   //     } else {
//                   //       return const Center(child: Text('Some error !'));
//                   //     }
//                   //   },
//                   // );
