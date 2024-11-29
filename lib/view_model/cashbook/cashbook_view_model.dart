import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/cashbook_entry.dart';

class CashbookViewModel with ChangeNotifier {
  late List<CashbookEntry> allCashbookEntries;

  Stream<QuerySnapshot<Map<String, dynamic>>> getCashbookData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .orderBy('cashbookEntryId', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSupplierName(
      int supplierId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .doc('SUP-$supplierId')
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCustomerBusinessTitle(
      int customerOrderId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$customerOrderId')
        .snapshots();
  }
}
