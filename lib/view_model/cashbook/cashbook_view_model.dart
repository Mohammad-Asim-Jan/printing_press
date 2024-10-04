import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/payment.dart';

class CashbookViewModel with ChangeNotifier {
  late bool dataFetched;
  late List<Payment> allPayments;

  fetchAllCashbookData() async {
    dataFetched = false;
    allPayments = [];

    final collectionReference = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('CashbookData')
        .collection('CashbookEntry');

    final querySnapshot = await collectionReference.get();

    final listQueryDocumentSnapshot = querySnapshot.docs;

    if (listQueryDocumentSnapshot.isEmpty ||
        listQueryDocumentSnapshot.length == 1) {
      debugPrint('No records found !');
      dataFetched = true;
      updateListener();
    } else {
      for (int i = 1; i < listQueryDocumentSnapshot.length; i++) {
        var data = listQueryDocumentSnapshot[i].data();
        debugPrint(
            'hellooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo${data.toString()}');
        allPayments.add(Payment.fromJson(data));
      }

      dataFetched = true;
      updateListener();
    }
  }

  updateListener() {
    notifyListeners();
  }
}
