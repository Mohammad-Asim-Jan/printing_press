import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/utils/toast_message.dart';
import '../../model/stock.dart';

class StockDetailsViewModel with ChangeNotifier {
  late Stock stock;
  List allStockOrderHistoryList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final quantityC = TextEditingController();
  String supplierName = 'SupplierName';

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStockData(int stockId) {
    return firestore
        .collection(uid)
        .doc('StockData')
        .collection('AvailableStock')
        .doc('STOCK-$stockId')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStockHistoryData(int stockId) {
    return firestore
        .collection(uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .where('stockId', isEqualTo: stockId)
        .orderBy('stockOrderId', descending: true)
        .snapshots();
  }

  getSupplierName(int supplierId) async {
    var docRef = await firestore
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .doc('SUP-$supplierId')
        .get();
    supplierName = docRef.get('supplierName');
  }

  void addMoreStock(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: kTwo,
          insetPadding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add More Stock",
                    style: Theme.of(context)
                        .appBarTheme
                        .titleTextStyle
                        ?.copyWith(color: kOne),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: quantityC,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration:
                        const InputDecoration(labelText: 'Stock Quantity'),
                    validator: (value) {
                      if (value == '' || value == null) {
                        return 'Provide Stock Quantity';
                      } else if (int.tryParse(value)! <= 0) {
                        return 'Field can not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            addStockToFirebase();
                          },
                          child: const Text("Add"),
                        ),
                      ])
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  addStockToFirebase() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Timestamp timestamp = Timestamp.now();
      int newStockQuantity = int.tryParse(quantityC.text.trim())!;
      int newTotalAmount = newStockQuantity * stock.stockUnitBuyPrice;
      int totalAmount = stock.totalAmount! + newTotalAmount;

      DocumentReference stockDocRef = firestore
          .collection(uid)
          .doc('StockData')
          .collection('AvailableStock')
          .doc('STOCK-${stock.stockId}');

      /// update the Stock
      await stockDocRef.update({
        'stockQuantity': newStockQuantity + stock.stockQuantity,
        'availableStock': stock.availableStock + newStockQuantity,
        'totalAmount': totalAmount,
        'stockDateAdded': timestamp,
      }).then((value) async {
        Utils.showMessage('Stock data updated!');

        /// adding a stock order history
        int newStockOrderId = await setNewStockOrderId();

        await firestore
            .collection(uid)
            .doc('StockData')
            .collection('StockOrderHistory')
            .doc('$newStockOrderId')
            .set({
          'stockOrderId': newStockOrderId,
          'stockId': stock.stockId,
          'stockName': stock.stockName,
          'stockCategory': stock.stockCategory,
          'stockUnitBuyPrice': stock.stockUnitBuyPrice,
          'stockQuantity': newStockQuantity,
          'totalAmount': newTotalAmount,
          'supplierId': stock.supplierId,
          'stockDateAdded': timestamp,
        });

        /// update the supplier total amount and remaining amount
        DocumentReference supplierRef = firestore
            .collection(uid)
            .doc('SuppliersData')
            .collection('Suppliers')
            .doc('SUP-${stock.supplierId}');

        DocumentSnapshot supplierDocSnapshot = await supplierRef.get();

        int supplierPreviousTotalAmount =
            supplierDocSnapshot.get('totalAmount');
        int supplierPreviousRemainingAmount =
            supplierDocSnapshot.get('amountRemaining') ?? 0;

        supplierRef.update({
          'totalAmount': supplierPreviousTotalAmount + newTotalAmount,
          'amountRemaining': supplierPreviousRemainingAmount + newTotalAmount
        });
      }).onError((error, stackTrace) {
        Utils.showMessage(error.toString());
      });
    }
  }

  Future<int> setNewStockOrderId() async {
    int newStockOrderId = 1;
    final documentRef = firestore
        .collection(uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .doc('0LastStockOrderId');
    final documentSnapshot = await documentRef.get();
    var data = documentSnapshot.data();
    if (data?['LastStockOrderId'] == null) {
      await documentRef.set({'LastStockOrderId': newStockOrderId});
    } else {
      newStockOrderId = data?['LastStockOrderId'] + 1;
      await documentRef.set({'LastStockOrderId': newStockOrderId});
    }
    return newStockOrderId;
  }
}
