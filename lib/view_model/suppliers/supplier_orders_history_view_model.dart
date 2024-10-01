import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/payment.dart';
import 'package:printing_press/utils/toast_message.dart';
import '../../model/stock_order_to_supplier.dart';

class SupplierOrdersHistoryViewModel with ChangeNotifier {
  late bool dataFetched;
  late List allStockOrderHistoryList;

  ///todo: change the supplierIda to supplierId
  fetchAllSuppliersOrdersHistory(int supplierId) async {
    dataFetched = false;
    allStockOrderHistoryList = [];

    try {
      final Query<Map<String, dynamic>> collectionReference = FirebaseFirestore
          .instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc('StockData')
          .collection('StockOrderHistory')
          .where('supplierId', isEqualTo: supplierId);

      ///todo: if the supplierId == 1, it could be either the stock order or the payment for the stock...,
      ///then see if it is a stock order, save in stock model, else vice versa.
      ///The logic is that you have to see a field that is not available in either document.
      ///For ex stockId is not available in payment, hence you say if stockId != null,
      ///then add in stock order model else add in payment model

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference.get();
      debugPrint('Length of the query snapshot: ${querySnapshot.docs.length}');
      final List<QueryDocumentSnapshot<Map<String, dynamic>>>
          listQueryDocumentSnapshot = querySnapshot.docs;

      debugPrint('Supplier Id in the method: $supplierId');
      if (listQueryDocumentSnapshot.isEmpty) {
        debugPrint('No records found !');
        dataFetched = true;
        updateListener();
      } else {
        for (int i = 0; i < listQueryDocumentSnapshot.length; i++) {
          Map<String, dynamic> data = listQueryDocumentSnapshot[i].data();
          debugPrint(
              '\n\n\n\nthis the stock id in each entry : ${data['stockId']}');
          // debugPrint(
          //     'hellooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo${data.toString()}');
          if (data['stockId'] == null ) {
            /// Here there is a payment document
            allStockOrderHistoryList.add(Payment.fromJson(data));
          } else {
            /// Here there is a stock order document
            allStockOrderHistoryList.add(StockOrderToSupplier.fromJson(data));
          }
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
