import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/model/supplier.dart';

class AllSuppliersViewModel with ChangeNotifier {
  bool dataFetched = false;
  late Map<String, dynamic>? data;

  getFirestoreData() async {
    data = await fetchData();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (data == null) {
        debugPrint("Data is null");
        updateListener();
      } else {
        dataFetched = true;
        debugPrint("Data fetched from all suppliers : ${data.toString()}");
        timer.cancel();
        updateListener();
      }
    });
    Timer(const Duration(seconds: 5), () {
      dataFetched = true;
      updateListener();
    });
    // rateList = RateList.fromJson(data!);
  }

  updateListener() {
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchData() async {
    final docRef = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('AllSuppliers');
    final docSnapshot = await docRef.get();
    List<Supplier> allSuppliersModel = [];
    Map<String, dynamic>? data = docSnapshot.data();

    if (data == null) {
      debugPrint('No records found !');
    } else {
      data.forEach((key, value) {
        debugPrint('Key of the supplier is : $key');
        allSuppliersModel.add(Supplier.fromJson(value));

        debugPrint(
            '\n\n\n\n\n\nThis is the first suppliers in the data : ${allSuppliersModel[0].supplierName.toString()}');
      });
    }

    return data;
  }
}
