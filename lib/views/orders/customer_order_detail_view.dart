import 'package:flutter/material.dart';
import 'package:printing_press/model/customer_custom_order.dart';
import 'package:printing_press/model/stock_order_by_customer.dart';

class CustomerOrderDetailView extends StatefulWidget {
  const CustomerOrderDetailView({
    super.key,
    this.customerCustomOrder,
    this.stockOrderByCustomer,
  });

  final CustomerCustomOrder? customerCustomOrder;
  final StockOrderByCustomer? stockOrderByCustomer;

  @override
  State<CustomerOrderDetailView> createState() =>
      _CustomerOrderDetailViewState();
}

class _CustomerOrderDetailViewState extends State<CustomerOrderDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.customerCustomOrder != null
                ? [
                    Container(
                        padding: EdgeInsets.all(6),
                        color: Colors.white60,
                        margin: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Paid Amount',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Total Amount',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            SizedBox(height: 6,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(widget.customerCustomOrder!.paidAmount
                                    .toString()),
                                Text(widget.customerCustomOrder!.totalAmount
                                    .toString()),
                              ],
                            ),
                          ],
                        )),
                    Text(
                        'Order Id: ${widget.customerCustomOrder!.customerOrderId.toString()}'),
                    Row(
                      children: [
                        const Text('Customer Name'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.customerName),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Business Title'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.businessTitle),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Contact No.'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.customerContact
                            .toString()),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Customer address'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.customerAddress),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Machine Name'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.machineName),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Book Quantity'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.bookQuantity
                            .toString()),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Pages per book'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.bookQuantity
                            .toString()),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Order Status'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.orderStatus),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Order time'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.customerCustomOrder!.orderDateTime
                            .toDate()
                            .toString()),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Order due time'),
                        const SizedBox(
                          width: 50,
                        ),
                        widget.customerCustomOrder!.orderDueDateTime == null
                            ? const Text('Not set')
                            : Text(widget.customerCustomOrder!.orderDueDateTime!
                                .toDate()
                                .toString()),
                      ],
                    ),
                  ]
                : [
              Container(
                  padding: EdgeInsets.all(6),
                  color: Colors.white60,
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Paid Amount',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            'Total Amount',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(widget.stockOrderByCustomer!.paidAmount
                              .toString()),
                          Text(widget.stockOrderByCustomer!.totalAmount
                              .toString()),
                        ],
                      ),
                    ],
                  )),
                    Text(
                        'Order Id: ${widget.stockOrderByCustomer!.customerOrderId.toString()}'),
                    Row(
                      children: [
                        const Text('Customer Name'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.stockOrderByCustomer!.customerName),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Business Title'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.stockOrderByCustomer!.businessTitle),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Contact No.'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.stockOrderByCustomer!.customerContact
                            .toString()),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Customer address'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.stockOrderByCustomer!.customerAddress),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Stock Ordered'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.stockOrderByCustomer!.stockName),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Stock Price'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.stockOrderByCustomer!.stockUnitSellPrice
                            .toString()),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Order Status'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.stockOrderByCustomer!.orderStatus),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Order time'),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(widget.stockOrderByCustomer!.orderDateTime
                            .toDate()
                            .toString()),
                      ],
                    ),
                  ]),
      ),
    );
  }
}
