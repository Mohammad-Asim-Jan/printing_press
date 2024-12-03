import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/cashbook_entry.dart';

class CustomerOrderDetailViewModel with ChangeNotifier {
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
}
