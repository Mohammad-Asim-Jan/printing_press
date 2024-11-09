
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
}