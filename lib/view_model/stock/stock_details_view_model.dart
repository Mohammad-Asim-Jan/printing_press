import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/stock.dart';

class StockDetailsViewModel with ChangeNotifier {
  late Stock stock;
  List allStockOrderHistoryList = [];

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStockData(int stockId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('StockData')
        .collection('AvailableStock')
        .doc('STOCK-$stockId')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStockHistoryData(int stockId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .where('stockId', isEqualTo: stockId)
        .orderBy('stockOrderId', descending: true)
        .snapshots();
  }
}
