import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/utils/toast_message.dart';

class AddStockViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newStockId;
  late int newStockOrderId;
  late int supplierId;
  late int supplierPreviousTotalAmount;
  late int previousStockQuantity;
  late int previousAvailableStockQuantity;
  late int previousTotalAmount;
  late int totalAmount;
  late int newTotalAmount;

  get formKey => _formKey;

  TextEditingController stockNameC = TextEditingController();
  TextEditingController stockCategoryC = TextEditingController();
  TextEditingController stockDescriptionC = TextEditingController();
  TextEditingController stockUnitBuyPriceC = TextEditingController();
  TextEditingController stockUnitSellPriceC = TextEditingController();
  TextEditingController stockQuantityC = TextEditingController();
  TextEditingController stockSizeWidthC = TextEditingController();
  TextEditingController stockSizeHeightC = TextEditingController();
  TextEditingController stockColorC = TextEditingController();
  TextEditingController stockManufacturedByC = TextEditingController();
  TextEditingController supplierIdC = TextEditingController();

  addStockInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);
      {
        if (_formKey.currentState!.validate()) {
          ///todo: check if the quantity is null or zero, then don't update
          /// check if stock is already available
          await setNewStockOrderId();
          QuerySnapshot stockQuerySnapshot = await fireStore
              .collection(uid)
              .doc('StockData')
              .collection('AvailableStock')

              /// todo: create a method which will find the supplier id by using supplier name
              /// todo: store the supplierId instead of supplier name
              .where('stockName', isEqualTo: stockNameC.text.trim())
              .where('stockCategory', isEqualTo: stockCategoryC.text.trim())
              .where('stockDescription',
                  isEqualTo: stockDescriptionC.text.trim())
              .where('stockUnitBuyPrice',
                  isEqualTo: int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0)
              .where('stockUnitSellPrice',
                  isEqualTo: int.tryParse(stockUnitSellPriceC.text.trim()) ??
                      int.tryParse(stockUnitBuyPriceC.text.trim()) ??
                      1)
              .where('stockColor', isEqualTo: stockColorC.text.trim())
              .where('manufacturedBy',
                  isEqualTo: stockManufacturedByC.text.trim())
              .where('supplierId',
                  isEqualTo: int.tryParse(supplierIdC.text.trim()))
              .limit(1)
              .get();

          if (stockQuerySnapshot.docs.isNotEmpty) {
            debugPrint('\n\n\n\n\n\n\n\n\n\nIt means stock exists.'
                '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');

            newTotalAmount = (int.tryParse(stockQuantityC.text.trim()) ?? 0) *
                (int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0);

            debugPrint('\n\nNew Total Amount: $newTotalAmount\n\n');

            /// update the Stock
            DocumentSnapshot stockDocumentSnapshot =
                stockQuerySnapshot.docs.first;
            newStockId = stockDocumentSnapshot.get('stockId');
            previousStockQuantity = stockDocumentSnapshot.get('stockQuantity');
            previousAvailableStockQuantity =
                stockDocumentSnapshot.get('availableStock') ?? 0;

            previousTotalAmount = stockDocumentSnapshot.get('totalAmount');
            totalAmount = previousTotalAmount + newTotalAmount;
            // try {
            DocumentReference stockDocRef = fireStore
                .collection(uid)
                .doc('StockData')
                .collection('AvailableStock')

                /// todo: create a method which will find the supplier id by using supplier name
                .doc('STOCK-$newStockId');

            await stockDocRef.update({
              'stockDateAdded': Timestamp.now(),
              'availableStock': previousAvailableStockQuantity +
                  (int.tryParse(stockQuantityC.text.trim()) ?? 0),
              'stockQuantity': int.tryParse(stockQuantityC.text.trim()) == null
                  ? previousStockQuantity
                  : int.tryParse(stockQuantityC.text.trim())! +
                      previousStockQuantity,
              'totalAmount': totalAmount,
            }).then((value) async {
              ///todo: add an order history
              debugPrint('\n\n\n\n\n\n\n\n Stock data updated !!\n\n\n\n\n\n');
              Utils.showMessage('Stock data updated !!');

              /// adding a stock order
              await fireStore
                  .collection(uid)
                  .doc('StockData')
                  .collection('StockOrderHistory')
                  .doc('SUP-ORDER-$newStockOrderId')
                  .set({
                'stockOrderId': newStockOrderId,
                'stockId': newStockId,
                'stockName': stockNameC.text.trim(),
                'stockCategory': stockCategoryC.text.trim(),
                'stockUnitBuyPrice':
                    int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0,
                'stockQuantity': int.tryParse(stockQuantityC.text.trim()) ?? 0,
                'totalAmount': newTotalAmount,
                'supplierId': int.tryParse(supplierIdC.text.trim()),
                'stockDateAdded': Timestamp.now(),
              });

              /// update the supplier total amount etc
              supplierId = int.tryParse(supplierIdC.text.trim())!;

              DocumentReference supplierRef = fireStore
                  .collection(uid)
                  .doc('SuppliersData')
                  .collection('Suppliers')

                  /// todo: create a method which will find the supplier id by using supplier name
                  .doc('SUP-$supplierId');

              DocumentSnapshot supplierDocSnapshot = await supplierRef.get();

              supplierPreviousTotalAmount =
                  supplierDocSnapshot.get('totalAmount');
              supplierRef.update({
                'totalAmount': supplierPreviousTotalAmount + newTotalAmount,
              });

              updateListeners(false);
            }).onError((error, stackTrace) {
              debugPrint(
                  '\n\n\n\n\n\n\n some thing not worked. error!!!!!!!!!!!!! ERROR : $error}');
              Utils.showMessage(error.toString());
              updateListeners(false);
            });
            // } catch (e, s) {
            //   debugPrint(
            //       '\n\n\n\n\n\n\n some thing not worked. errorrrrrr 222222222222!!!!!!!!!!!!!');
            // }
            updateListeners(false);
          } else {
            /// stock doesn't exist
            await setNewStockId();

            newTotalAmount = (int.tryParse(stockQuantityC.text.trim()) ?? 0) *
                (int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0);

            /// Adding a new stock
            await fireStore
                .collection(uid)
                .doc('StockData')
                .collection('AvailableStock')
                .doc('STOCK-$newStockId')
                .set({
              'stockId': newStockId,
              'availableStock': int.tryParse(stockQuantityC.text.trim()) ?? 0,
              'stockName': stockNameC.text.trim(),
              'stockCategory': stockCategoryC.text.trim(),
              'stockDescription': stockDescriptionC.text.trim(),
              'stockUnitBuyPrice':
                  int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0,
              'stockUnitSellPrice':
                  int.tryParse(stockUnitSellPriceC.text.trim()) ??
                      int.tryParse(stockUnitBuyPriceC.text.trim()) ??
                      1,
              'stockQuantity': int.tryParse(stockQuantityC.text.trim()) ?? 0,
              'stockColor': stockColorC.text.trim(),
              'manufacturedBy': stockManufacturedByC.text.trim(),
              'totalAmount': newTotalAmount,
              'supplierId': int.tryParse(supplierIdC.text.trim()) ?? 0,
              'stockDateAdded': Timestamp.now()
            }).then((value) async {
              /// Adding the history of the stock
              await fireStore
                  .collection(uid)
                  .doc('StockData')
                  .collection('StockOrderHistory')
                  .doc('SUP-ORDER-$newStockOrderId')
                  .set({
                'stockOrderId': newStockOrderId,
                'stockId': newStockId,
                'stockName': stockNameC.text.trim(),
                'stockCategory': stockCategoryC.text.trim(),
                'stockUnitBuyPrice':
                    int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0,
                'stockQuantity': int.tryParse(stockQuantityC.text.trim()) ?? 0,
                'totalAmount': newTotalAmount,
                'supplierId': int.tryParse(supplierIdC.text.trim()),
                'stockDateAdded': Timestamp.now(),
              });

              /// update the supplier total amount
              supplierId = int.tryParse(supplierIdC.text.trim())!;

              debugPrint(
                  '\n\n\n\n\nSupplier id while updating the total amount: $supplierId \n\n\n\n\n');
              DocumentReference supplierRef = fireStore
                  .collection(uid)
                  .doc('SuppliersData')
                  .collection('Suppliers')

                  /// todo: create a method which will find the supplier id by using supplier name
                  .doc('SUP-$supplierId');

              DocumentSnapshot supplierDocSnapshot = await supplierRef.get();

              supplierPreviousTotalAmount =
                  supplierDocSnapshot.get('totalAmount');

              debugPrint(
                  '\n\n\n\n\nSupplier previous total amount: $supplierPreviousTotalAmount \n\n\n\n\n');
              debugPrint(
                  '\n\n\n\n\nSupplier new total amount: $newTotalAmount \n\n\n\n\n');

              supplierRef.update({
                'totalAmount': supplierPreviousTotalAmount + newTotalAmount,
              });

              Utils.showMessage('Successfully stock added');
              Utils.showMessage('Successfully stock order Added');
              debugPrint('New stock added!!!!!!!!!!!!!!!!!');

              updateListeners(false);
            }).onError((error, stackTrace) {
              Utils.showMessage(error.toString());
              updateListeners(false);
            });
          }
        }
        updateListeners(false);
      }
    } else {
      updateListeners(false);
    }
  }

  /// when you want to add data of supplier or any bank account, you need to set the supplier id and bank id
  setNewStockId() async {
    newStockId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('StockData')
        .collection('AvailableStock')
        .doc('LastStockId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['stockId'] == null) {
      debugPrint('Stock id found to be null --------- ${data?['stockId']}');
      await documentRef.set({'stockId': newStockId});
    } else {
      debugPrint(
          '\n\n\nStock id is found to be available. \nStock id: ${data?['stockId']}');
      newStockId = data?['stockId'] + 1;
      await documentRef.set({'stockId': newStockId});
    }
  }

  ///todo:
  setNewStockOrderId() async {
    newStockOrderId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .doc('LastStockOrderId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastStockOrderId'] == null) {
      debugPrint(
          'Stock ordered id found to be null --------- ${data?['LastStockOrderId']}');
      await documentRef.set({'LastStockOrderId': newStockOrderId});
    } else {
      debugPrint(
          '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastStockOrderId']}');
      newStockOrderId = data?['LastStockOrderId'] + 1;
      await documentRef.set({'LastStockOrderId': newStockOrderId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
