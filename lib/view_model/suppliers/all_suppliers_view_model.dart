import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/model/supplier.dart';

class AllSuppliersViewModel with ChangeNotifier {
  late bool dataFetched;
  late List<Supplier> allSuppliersModel;

  getDataFromFirestore() async {
    dataFetched = false;
    allSuppliersModel = [];
    await fetchData();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (allSuppliersModel.isEmpty) {
        debugPrint("Data is null");
        updateListener();
      } else {
        dataFetched = true;
        timer.cancel();
        updateListener();
      }
    });
    Timer(const Duration(seconds: 1), () {
      dataFetched = true;
      updateListener();
    });
    // rateList = RateList.fromJson(data!);
  }

  updateListener() {
    notifyListeners();
  }

  fetchData() async {

    final collectionReference = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('AllSuppliers')
        .collection('AllSuppliers');

    final querySnapshot = await collectionReference.get();

    final listQueryDocumentSnapshot = querySnapshot.docs;

    if(listQueryDocumentSnapshot.isEmpty) {
      debugPrint('No records found !');
    } else {
      for(var queryDocSnapshot in listQueryDocumentSnapshot) {
        var data = queryDocSnapshot.data();
        data.forEach((key, value) {
          allSuppliersModel.add(Supplier.fromJson(value));
        });
      }
    }
  }
}


