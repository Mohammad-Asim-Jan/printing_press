import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/cashbook_entry.dart';

class CustomerOrderDetailViewModel with ChangeNotifier {
  int index = 0;
  late List<CashbookEntry> customerOrderHistoryList;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCustomerOrderData(
      int customerOrderId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$customerOrderId')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCustomerPaymentHistory(
      int customerOrderId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .where('customerOrderId', isEqualTo: customerOrderId)
        .orderBy('cashbookEntryId', descending: true)
        .snapshots();
  }

  List<Color> statusColor = [
    Colors.blue,
    Colors.lightGreen,
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.purple.withOpacity(0.5),
    Colors.grey,
  ];

  setStatusColor(String status) {
    switch (status) {
      case 'New Order':
        index = 0;
        break;
      // return Icon(Icons.fiber_new, color: Colors.blue, size: 17);
      case 'In Progress':
        index = 1;
        // return Icon(Icons.autorenew, color: Colors.yellowAccent, size: 17);
        break;
      case 'Pending':
        index = 2;
        // return Icon(Icons.hourglass_top, color: Colors.orange, size: 17);
        break;
      case 'Cancelled':
        index = 3;
        // return Icon(Icons.cancel, color: Colors.red, size: 17);
        break;
      case 'Completed':
        index = 4;
        // return Icon(Icons.check_circle, color: Colors.green, size: 17);
        break;
      case 'Handed Over':
        index = 5;
        // return Icon(Icons.inventory_2,
        //     color: Colors.purple.withOpacity(0.5), size: 17);
        break;
      default:
        index = 6;
        // return Icon(Icons.help_outline,
        //     color: Colors.grey, size: 17); // Unknown status
        break;
    }
  }
}
