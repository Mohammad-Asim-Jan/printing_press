import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StockOrderHistoryViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List allStockOrderHistoryList;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStockHistoryData(int stockId) {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .where('stockId', isEqualTo: stockId)
        .snapshots();
  }

// fetchStockOrdersHistory(int stockId) async {
//   dataFetched = false;
//   allStockOrderHistoryList = [];
//
//   try {
//     final Query<Map<String, dynamic>> collectionReference = FirebaseFirestore
//         .instance
//         .collection(FirebaseAuth.instance.currentUser!.uid)
//         .doc('StockData')
//         .collection('StockOrderHistory')
//         .where('stockId', isEqualTo: stockId);
//
//     final QuerySnapshot<Map<String, dynamic>> querySnapshot =
//         await collectionReference.get();
//     debugPrint('Length of the query snapshot: ${querySnapshot.docs.length}');
//     final List<QueryDocumentSnapshot<Map<String, dynamic>>>
//         listQueryDocumentSnapshot = querySnapshot.docs;
//
//     debugPrint('Stock Id in the method: $stockId');
//     if (listQueryDocumentSnapshot.isEmpty) {
//       debugPrint('No records found !');
//       dataFetched = true;
//       updateListener();
//     } else {
//       for (int i = 0; i < listQueryDocumentSnapshot.length; i++) {
//         Map<String, dynamic> data = listQueryDocumentSnapshot[i].data();
//         debugPrint(
//             '\n\n\n\n this the supplier id in each entry : ${data['supplierId']}');
//         if (data['supplierId'] != null) {
//           /// Here there is a supplier order doc
//           allStockOrderHistoryList
//               .add(StockOrderHistoryToSupplier.fromJson(data));
//         } else {
//           /// Here there is a customer order document
//           allStockOrderHistoryList
//               .add(StockOrderHistoryByCustomer.fromJson(data));
//         }
//       }
//
//       dataFetched = true;
//       updateListener();
//     }
//   } on FirebaseException catch (e) {
//     Utils.showMessage(e.code);
//   }
// }
//
// updateListener() {
//   notifyListeners();
// }
}
