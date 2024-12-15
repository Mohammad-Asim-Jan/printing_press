import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import '../../components/custom_circular_indicator.dart';
import '../../view_model/orders/track_customer_order_view_model.dart';

class TrackCustomerOrderView extends StatefulWidget {
  final int customerOrderId;

  const TrackCustomerOrderView({super.key, required this.customerOrderId});

  @override
  State<TrackCustomerOrderView> createState() => _TrackCustomerOrderViewState();
}

class _TrackCustomerOrderViewState extends State<TrackCustomerOrderView> {
  final List<String> statuses = [
    'New Order',
    'In Progress',
    'Completed',
    'Handed Over'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD0D7D4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kNew9a,
        title: Text('Order Tracking',
            style: TextStyle(
                color: kNew9a,
                fontSize: 20,
                letterSpacing: 0,
                fontWeight: FontWeight.w500)),
      ),
      body: Consumer<TrackCustomerOrderViewModel>(
        builder: (context, TrackCustomerOrderViewModel value, child) =>
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
                    String orderStatus = snapshot.data!.data()!['orderStatus'];
                    int customerOrderId =
                        snapshot.data!.data()!['customerOrderId'];

                    if (orderStatus == 'Cancelled') {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('This order has been cancelled',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Urbanist',
                                )),
                            SizedBox(height: 50),
                            Icon(
                              Icons.cancel_presentation_rounded,
                              size: 50,
                              color: Colors.red,
                            ),
                            SizedBox(height: 80),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          orderStatus == 'Pending'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 150),
                                    Text('This order has been set as pending',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: kPrimeColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Urbanist',
                                        )),
                                    SizedBox(height: 50),
                                    Icon(
                                      Icons.hourglass_top,
                                      size: 30,
                                      color: kPrimeColor,
                                    ),
                                    SizedBox(height: 80),
                                  ],
                                )
                              : FixedTimeline.tileBuilder(
                                  builder: TimelineTileBuilder.connected(
                                    contentsAlign: ContentsAlign.alternating,
                                    connectionDirection:
                                        ConnectionDirection.after,
                                    itemCount: statuses.length,
                                    contentsBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 30.0, horizontal: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade300,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: index % 2 == 0
                                                    ? Alignment.centerLeft
                                                    : Alignment.centerRight,
                                                colors: [
                                                  statuses[index] == orderStatus
                                                      ? Colors
                                                          .lightGreen.shade50
                                                          .withOpacity(0.5)
                                                      : Colors.grey
                                                          .withOpacity(0.15),
                                                  Colors.green.shade300,
                                                ])),
                                        child: Text(
                                          statuses[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.bold,
                                            color: getStatusTextColor(
                                                statuses[index], orderStatus),
                                          ),
                                        ),
                                      );
                                    },
                                    indicatorBuilder: (context, index) {
                                      return DotIndicator(
                                        size: statuses[index] == orderStatus
                                            ? 30.0
                                            : 20.0,
                                        color: getStatusColor(
                                            statuses[index], orderStatus),
                                        child: statuses[index] == orderStatus
                                            ? Icon(Icons.check,
                                                color: Colors.white)
                                            : null,
                                      );
                                    },
                                    connectorBuilder: (context, index, type) {
                                      return SolidLineConnector(
                                        color: index <
                                                statuses.indexOf(orderStatus)
                                            ? Colors.green
                                            : Colors.grey.shade400,
                                        thickness: 4.0,
                                      );
                                    },
                                  ),
                                ),
                          Spacer(),
                          orderStatus == 'Completed'
                              ? GestureDetector(
                                  onTap: () {
                                    value.confirmation(
                                        context, customerOrderId, 'Hand Over');
                                  },
                                  child: Card(
                                    shadowColor: Colors.blueGrey,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.purple.shade400,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            'Hand Over\t\t\t\t\t',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ))),
                                          Icon(Icons.inventory_2,
                                              color: Colors.white70)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : orderStatus == 'Handed Over'
                                  ? SizedBox.shrink()
                                  : Row(
                                      children: [
                                        // cancel order
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              value.confirmation(context,
                                                  customerOrderId, 'Cancel');
                                            },
                                            child: Card(
                                              shadowColor: Colors.blueGrey,
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              color: Colors.red.shade400,
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Center(
                                                            child: Text(
                                                      'Cancel Order',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ))),
                                                    Icon(Icons.cancel_rounded,
                                                        color: Colors.white70)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        // Pending order
                                        orderStatus == 'Pending'
                                            ? SizedBox.shrink()
                                            : Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    value.confirmation(
                                                        context,
                                                        customerOrderId,
                                                        'Pending');
                                                  },
                                                  child: Card(
                                                    shadowColor:
                                                        Colors.blueGrey,
                                                    elevation: 10,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    color: Colors.orange,
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.0,
                                                              vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                            'Mark Pending',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ))),
                                                          Icon(
                                                              Icons
                                                                  .hourglass_top,
                                                              color: Colors
                                                                  .white70)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        // Resume order
                                        orderStatus == 'Pending'
                                            ? Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    value.confirmation(
                                                        context,
                                                        customerOrderId,
                                                        'Resume');
                                                  },
                                                  child: Card(
                                                    shadowColor:
                                                        Colors.blueGrey,
                                                    elevation: 10,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    color:
                                                        Colors.green.shade400,
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.0,
                                                              vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                            'Resume',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Urbanist',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ))),
                                                          Icon(Icons.refresh,
                                                              color: Colors
                                                                  .white70)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Text('Try again'),
                  );
                }),
      ),
    );
  }

  Color getStatusColor(String status, String orderStatus) {
    if (statuses.indexOf(status) <= statuses.indexOf(orderStatus)) {
      return Colors.green;
    }
    return Colors.grey;
  }

  Color getStatusTextColor(String status, String orderStatus) {
    if (statuses.indexOf(status) <= statuses.indexOf(orderStatus)) {
      return Colors.green.shade700;
    }
    return Colors.grey.shade600;
  }
}
