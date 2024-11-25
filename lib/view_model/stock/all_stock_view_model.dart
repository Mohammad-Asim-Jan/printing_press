import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/stock.dart';
import 'package:printing_press/utils/toast_message.dart';

class AllStockViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List<Stock> stockList;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStocksData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('StockData')
        .collection('AvailableStock')
        .where('stockId', isNotEqualTo: null)
        .orderBy('stockId', descending: true)
        .snapshots();
  }

  Future<bool> isSupplierAvailable(int index) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc('SuppliersData')
          .collection('Suppliers')
          .where('supplierId', isEqualTo: stockList[index].supplierId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Utils.showMessage('Error: $e');
      debugPrint("Error $e");
      return false;
    }
  }
// void fetchAllStockData() async {
//   dataFetched = false;
//   allStockList = [];
//
//   final collectionReference = FirebaseFirestore.instance
//       .collection(FirebaseAuth.instance.currentUser!.uid)
//       .doc('StockData')
//       .collection('AvailableStock');
//
//   final querySnapshot = await collectionReference.get();
//
//   final listQueryDocumentSnapshot = querySnapshot.docs;
//
//   if (listQueryDocumentSnapshot.isEmpty ||
//       listQueryDocumentSnapshot.length == 1) {
//     debugPrint('No records found !');
//     dataFetched = true;
//     updateListener();
//   } else {
//     for (int i = 1; i < listQueryDocumentSnapshot.length; i++) {
//       var data = listQueryDocumentSnapshot[i].data();
//       debugPrint(
//           'hellooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo${data.toString()}');
//       allStockList.add(Stock.fromJson(data));
//     }
//
//     // for (var queryDocSnapshot in listQueryDocumentSnapshot) {
//     //   var data = queryDocSnapshot.data();
//     //
//     //   data.forEach((key, value) {
//     //     allSuppliersModel.add(Supplier.fromJson(value));
//     //   });
//     // }
//
//     dataFetched = true;
//     updateListener();
//   }
//   // Timer.periodic(const Duration(seconds:3 ), (timer) {
//   //   if (allSuppliersModel.isEmpty) {
//   //     debugPrint("Data is null");
//   //     updateListener();
//   //   } else {
//   //     dataFetched = true;
//   //     timer.cancel();
//   //     updateListener();
//   //   }
//   // });
//   // Timer(const Duration(seconds: 5), () {
//   //   dataFetched = true;
//   //   updateListener();
//   // });
//   // rateList = RateList.fromJson(data!);
// }
//
// updateListener() {
//   notifyListeners();
// }
}
