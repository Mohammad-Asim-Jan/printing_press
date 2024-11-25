import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/customer_custom_order.dart';
import 'package:printing_press/model/stock_order_by_customer.dart';
import 'package:printing_press/view_model/orders/all_orders_view_model.dart';
import 'package:printing_press/views/orders/customer_order_detail_view.dart';
import 'package:provider/provider.dart';

import '../../components/custom_circular_indicator.dart';

class AllOrdersView extends StatefulWidget {
  const AllOrdersView({super.key});

  @override
  State<AllOrdersView> createState() => _AllOrdersViewState();
}

class _AllOrdersViewState extends State<AllOrdersView> {
  late AllOrdersViewModel allOrdersViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allOrdersViewModel =
        Provider.of<AllOrdersViewModel>(context, listen: false);
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
                    return const Center(
                      child: Text('No order found!'),
                    );
                  }
                  return Flexible(
                    child: ListView.builder(
                      itemCount: value.allCustomerOrdersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (value.allCustomerOrdersList[index]
                            is CustomerCustomOrder) {
                          CustomerCustomOrder customerCustomerOrder =
                              value.allCustomerOrdersList[index];
                          return ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return CustomerOrderDetailView(
                                    customerCustomOrder: customerCustomerOrder);
                              }));
                            },
                            shape: Border.all(width: 2, color: kPrimeColor),
                            titleTextStyle: TextStyle(
                                color: kThirdColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            title: Text(customerCustomerOrder.businessTitle),
                            tileColor: kSecColor,
                            subtitleTextStyle: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                            subtitle: Text(
                                'Customer Name: ${customerCustomerOrder.customerName}\nContact: ${customerCustomerOrder.customerContact}'),
                            leading: Text(customerCustomerOrder.customerOrderId
                                .toString()),
                            trailing: Text(
                                customerCustomerOrder.totalAmount.toString()),
                          );
                        } else if (value.allCustomerOrdersList[index]
                            is StockOrderByCustomer) {
                          StockOrderByCustomer stockOrderByCustomer =
                              value.allCustomerOrdersList[index];
                          return ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return CustomerOrderDetailView(
                                    stockOrderByCustomer: stockOrderByCustomer);
                              }));
                            },
                            shape: Border.all(width: 2, color: kPrimeColor),
                            // titleAlignment: ListTileTitleAlignment.threeLine,
                            titleTextStyle: TextStyle(
                                color: kThirdColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            title: Text(stockOrderByCustomer.businessTitle),
                            tileColor: kTwo,
                            subtitleTextStyle: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                            subtitle: Text(
                                'Customer Name: ${stockOrderByCustomer.customerName}\nContact: ${stockOrderByCustomer.customerContact}'),
                            leading: Text(stockOrderByCustomer.customerOrderId
                                .toString()),
                            trailing: Text(
                                stockOrderByCustomer.totalAmount.toString()),
                          );
                        } else {
                          return const Center(child: Text('Some error !'));
                        }
                      },
                    ),
                  );
                }
                return const Text('No data!');
              });

          // value.dataFetched
          //     ? value.allStockOrderHistoryList.isEmpty
          //         ? const Center(
          //             child: Text('No record found!'),
          //           )
          //
          //         ///todo: change listview.builder to streams builder, add a button to add the payment transaction
          //         : Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Column(
          //               children: [
          //                 Container(
          //                   color: kSecColor,
          //                   child: Column(
          //                     children: [
          //                       const Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Text('Available Stock'),
          //                           Text('Name'),
          //                           Text('Total'),
          //                         ],
          //                       ),
          //                       Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Text('${widget.availableStock}'),
          //                           Text(widget.stockName),
          //                           Text('${widget.stockQuantity}'),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 const SizedBox(
          //                   height: 15,
          //                 ),
          //                 Expanded(
          //                   child: ListView.builder(
          //                     itemCount: value.allStockOrderHistoryList.length,
          //                     itemBuilder: (BuildContext context, int index) {
          //                       if (value.allStockOrderHistoryList[index]
          //                           is StockOrderHistoryByCustomer) {
          //                         StockOrderHistoryByCustomer
          //                             stockOrderHistoryByCustomer =
          //                             value.allStockOrderHistoryList[index];
          //                         return ListTile(
          //                           shape:
          //                               Border.all(width: 2, color: kPrimeColor),
          //                           titleTextStyle: TextStyle(
          //                               color: kThirdColor,
          //                               fontSize: 18,
          //                               fontWeight: FontWeight.w500),
          //                           title: const Text('Customer Order'),
          //                           tileColor: kSecColor,
          //                           subtitleTextStyle: const TextStyle(
          //                               color: Colors.black,
          //                               fontStyle: FontStyle.italic),
          //                           subtitle: Text(
          //                             'Quantity: ${stockOrderHistoryByCustomer.stockQuantity}\nAmount: ${stockOrderHistoryByCustomer.totalAmount}',
          //                           ),
          //                           leading: Text(stockOrderHistoryByCustomer
          //                               .customerOrderId
          //                               .toString()),
          //                         );
          //                       } else if (value.allStockOrderHistoryList[index]
          //                           is StockOrderHistoryToSupplier) {
          //                         StockOrderHistoryToSupplier
          //                             stockOrderHistoryToSupplier =
          //                             value.allStockOrderHistoryList[index];
          //                         return ListTile(
          //                           shape:
          //                               Border.all(width: 2, color: kPrimeColor),
          //                           // titleAlignment: ListTileTitleAlignment.threeLine,
          //                           titleTextStyle: TextStyle(
          //                               color: kThirdColor,
          //                               fontSize: 18,
          //                               fontWeight: FontWeight.w500),
          //                           title: const Text('Supplier Order'),
          //                           tileColor: kTwo,
          //                           subtitleTextStyle: const TextStyle(
          //                               color: Colors.black,
          //                               fontStyle: FontStyle.italic),
          //                           subtitle: Text(
          //                             'Quantity: ${stockOrderHistoryToSupplier.stockQuantity}\nAmount: ${stockOrderHistoryToSupplier.totalAmount}',
          //                           ),
          //                           leading: Text(stockOrderHistoryToSupplier
          //                               .supplierId
          //                               .toString()),
          //                         );
          //                       } else {
          //                         return const Center(
          //                           child: Text('Some error !'),
          //                         );
          //                       }
          //                     },
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           )
          //     : const Center(child: CircularProgressIndicator()),
          //
        }),
      ],
    );
  }
}

// Searching
// Filtering unpaid, incomplete orders

// Go to that specific order on click
// Receipt or invoice

// One or multiple orders

// Order number
// Customer name
// Product or services
// Total amount
// Amount paid
// remaining amount
