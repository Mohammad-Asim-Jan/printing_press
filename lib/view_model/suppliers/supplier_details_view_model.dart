import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/bank_account.dart';

class SupplierDetailsViewModel with ChangeNotifier {
  late List allSupplierStockOrderHistoryList;
  late List<BankAccount> supplierBankAccounts;

  Stream<QuerySnapshot<Map<String, dynamic>>> geSupplierOrderHistoryData(
      int supplierId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .where('supplierId', isEqualTo: supplierId)
        .orderBy('stockOrderId', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSupplierData(
      int supplierId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .doc('SUP-$supplierId')
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSupplierBankAccounts(
      int supplierId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('SuppliersData')
        .collection('BankAccounts')
        .doc('SUP-BANK-$supplierId')
        .snapshots();
  }
}
