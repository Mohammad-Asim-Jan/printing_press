import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/model/supplier.dart';

class AllSuppliersViewModel with ChangeNotifier {
  late bool dataFetched;
  late List<Supplier> allSuppliersModel;

  void fetchAllSuppliersData() async {
    dataFetched = false;
    allSuppliersModel = [];

    final collectionReference = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('SuppliersData')
        .collection('Suppliers');

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
        allSuppliersModel.add(Supplier.fromJson(data));
      }

      // for (var queryDocSnapshot in listQueryDocumentSnapshot) {
      //   var data = queryDocSnapshot.data();
      //
      //   data.forEach((key, value) {
      //     allSuppliersModel.add(Supplier.fromJson(value));
      //   });
      // }

      dataFetched = true;
      updateListener();
    }
    // Timer.periodic(const Duration(seconds:3 ), (timer) {
    //   if (allSuppliersModel.isEmpty) {
    //     debugPrint("Data is null");
    //     updateListener();
    //   } else {
    //     dataFetched = true;
    //     timer.cancel();
    //     updateListener();
    //   }
    // });
    // Timer(const Duration(seconds: 5), () {
    //   dataFetched = true;
    //   updateListener();
    // });
    // rateList = RateList.fromJson(data!);
  }

  updateListener() {
    notifyListeners();
  }
}
