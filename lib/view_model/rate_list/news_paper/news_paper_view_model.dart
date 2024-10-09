import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../model/paper.dart';

class NewsPaperViewModel with ChangeNotifier {
  late bool dataFetched;
  late List<Paper> newsPaperList;

  void fetchNewsPaperData() async {
    dataFetched = false;
    newsPaperList = [];

    final collectionReference = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('NewsPaper');

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
        newsPaperList.add(Paper.fromJson(data));
      }

      dataFetched = true;
      updateListener();
    }
  }

  updateListener() {
    notifyListeners();
  }
}
