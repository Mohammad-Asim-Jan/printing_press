import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/utils/toast_message.dart';

import '../../model/stock_order_to_supplier.dart';

class StockOrderedFromSupplierViewModel with ChangeNotifier {
  late bool dataFetched;
  late List<StockOrderToSupplier> allStockOrderHistoryList;

  ///todo: change the supplierIda to supplierId
  fetchAllSuppliersOrdersHistory(int supplierId) async {
    dataFetched = false;
    allStockOrderHistoryList = [];

    try {
      final Query<Map<String, dynamic>> collectionReference = FirebaseFirestore
          .instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc('StockData')
          .collection('StockOrdered')
          .where('supplierId', isEqualTo: supplierId);

      final QuerySnapshot querySnapshot = await collectionReference.get();
      debugPrint('Length of the query snapshot: ${querySnapshot.docs.length}');
      final listQueryDocumentSnapshot = querySnapshot.docs;

      debugPrint('Supplier Id in the method: $supplierId');
      if (listQueryDocumentSnapshot.isEmpty) {
        debugPrint('No records found !');
        dataFetched = true;
        updateListener();
      } else {
        for (int i = 0; i < listQueryDocumentSnapshot.length; i++) {
          var data = listQueryDocumentSnapshot[i].data();
          debugPrint(
              'hellooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo${data.toString()}');
          allStockOrderHistoryList
              .add(StockOrderToSupplier.fromJson(data as Map<String, dynamic>));
        }
        dataFetched = true;
        updateListener();
      }
    } on FirebaseException catch (e) {
      Utils.showMessage(e.code);
    }
  }

  updateListener() {
    notifyListeners();
  }
}
