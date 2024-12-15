import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllOrdersViewModel with ChangeNotifier {
  List allCustomerOrdersList = [];

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCustomerOrders() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .orderBy('customerOrderId', descending: true)
        .snapshots();
  }

  checkStatus(
      DateTime placedOrderResumedTime, String orderStatus, int orderId) {

    Duration totalDuration = Duration(days: 3);
    DateTime currentTime = DateTime.now();

    Duration timePassed = currentTime.difference(placedOrderResumedTime);

    if (timePassed >= totalDuration * 0.3 && orderStatus == 'New Order') {
      updateOrderStatus('In Progress', orderId);
    } else if (timePassed >= totalDuration && orderStatus == 'In Progress') {
      updateOrderStatus('Completed', orderId);
    }
  }

  void updateOrderStatus(String status, int orderId) {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$orderId')
        .update({'orderStatus': status});
  }

  Widget getStatusIcon(String status) {
    switch (status) {
      case 'New Order':
        return Icon(Icons.fiber_new, color: Colors.blue);
      case 'In Progress':
        return Icon(Icons.autorenew, color: Colors.lightGreen);
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
