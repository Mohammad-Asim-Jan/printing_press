import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/machine.dart';

class MachineViewModel with ChangeNotifier {
  late bool dataFetched;
  late List<Machine> machineList;

  void fetchMachineData() async {
    dataFetched = false;
    machineList = [];

    final collectionReference = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Machine');

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
        machineList.add(Machine.fromJson(data));
      }

      dataFetched = true;
      updateListener();
    }
  }

  updateListener() {
    notifyListeners();
  }
}