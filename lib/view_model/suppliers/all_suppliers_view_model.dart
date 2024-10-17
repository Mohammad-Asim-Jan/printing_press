import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/supplier.dart';

class AllSuppliersViewModel with ChangeNotifier {
  List<Supplier> allSuppliersModel = [];

  Stream<QuerySnapshot<Map<String, dynamic>>> getSuppliersData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .snapshots();
  }
}
