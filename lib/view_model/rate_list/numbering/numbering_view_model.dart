
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/numbering.dart';

class NumberingViewModel with ChangeNotifier {
  late bool dataFetched;
  late List<Numbering> numberingList;

  void fetchNumberingData() async {
    dataFetched = false;
    numberingList = [];

    final collectionReference = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Numbering');

    final querySnapshot = await collectionReference.get();

    final listQueryDocumentSnapshot = querySnapshot.docs;

    if (listQueryDocumentSnapshot.length <= 1) {
      debugPrint('No records found !');
      dataFetched = true;
      updateListener();
    } else {
      for (int i = 1; i < listQueryDocumentSnapshot.length; i++) {
        var data = listQueryDocumentSnapshot[i].data();
        debugPrint('hello        ${data.toString()}');
        numberingList.add(Numbering.fromJson(data));
      }

      dataFetched = true;
      updateListener();
    }
  }

  updateListener() {
    notifyListeners();
  }
}

