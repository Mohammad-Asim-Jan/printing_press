import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/utils/toast_message.dart';

class AddStockViewModel with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool loading = false;

  late bool _dataFetched;

  get dataFetched => _dataFetched;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  late int newStockId;
  late int newStockOrderId;
  late int supplierId;
  late int supplierPreviousTotalAmount;
  late int supplierPreviousRemainingAmount;
  late int previousStockQuantity;
  late int previousAvailableStockQuantity;
  late int previousTotalAmount;
  late int totalAmount;
  late int newTotalAmount;

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

  // TextEditingController supplierIdC = TextEditingController();

  late List<String> suppliersNamesList;
  late String selectedSupplierName;
  late int selectedSupplierIndex;
  late List<int> suppliersIdList;

  getAllSuppliersName() async {
    _dataFetched = false;
    suppliersNamesList = [];
    suppliersIdList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection(uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .get();

    List<QueryDocumentSnapshot> list = querySnapshot.docs;

    if (list.length >= 2) {
      // debugPrint('The list we have got, has length equals to ${list.length}');
      for (int i = 1; i < list.length; i++) {
        suppliersNamesList.add(list[i].get('supplierName'));
        suppliersIdList.add(list[i].get('supplierId'));
      }
      setDropdownVal();
    } else {
      _dataFetched = true;
      updateListeners(false);
    }
  }

  setDropdownVal() {
    selectedSupplierName = suppliersNamesList[0];
    selectedSupplierIndex = 0;
    _dataFetched = true;
    notifyListeners();
  }

  changeSupplierDropdown(String? newVal) {
    if (newVal != null) {
      selectedSupplierName = newVal;
      selectedSupplierIndex = suppliersNamesList.indexOf(selectedSupplierName);
      // debugPrint('Supplier index: $selectedSupplierIndex');
      // debugPrint('Supplier id: ${suppliersIdList[selectedSupplierIndex]}');
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  addStockInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);
      if (_formKey.currentState!.validate()) {
        /// todo: checking if the quantity is zero, then don't update
        if (int.tryParse(stockQuantityC.text.trim()) == 0) {
          Utils.showMessage('Quantity must be greater than 0');
          updateListeners(false);
        } else {
          /// todo: check if stock is already available
          QuerySnapshot stockQuerySnapshot = await firestore
              .collection(uid)
              .doc('StockData')
              .collection('AvailableStock')
              .where('stockName', isEqualTo: stockNameC.text.trim())
              .get();

          if (stockQuerySnapshot.docs.isNotEmpty) {
            debugPrint('\n\n\nIt means stock exists\n\n\n\n\n');

            /// todo: check if the stock has the same values
            stockQuerySnapshot = await firestore
                .collection(uid)
                .doc('StockData')
                .collection('AvailableStock')
                .where('stockName', isEqualTo: stockNameC.text.trim())
                .where('stockCategory', isEqualTo: stockCategoryC.text.trim())
                .where('stockDescription',
                    isEqualTo: stockDescriptionC.text.trim())
                .where('stockUnitBuyPrice',
                    isEqualTo:
                        int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0)
                .where('stockUnitSellPrice',
                    isEqualTo: int.tryParse(stockUnitSellPriceC.text.trim()) ??
                        int.tryParse(stockUnitBuyPriceC.text.trim()) ??
                        1)
                .where('stockColor', isEqualTo: stockColorC.text.trim())
                .where('manufacturedBy',
                    isEqualTo: stockManufacturedByC.text.trim())
                .where('supplierId',
                    isEqualTo: suppliersIdList[selectedSupplierIndex])
                .limit(1)
                .get();
            if (stockQuerySnapshot.docs.isNotEmpty) {
              newTotalAmount = (int.tryParse(stockQuantityC.text.trim()) ?? 1) *
                  (int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 1);

              // debugPrint('\n\nNew Total Amount: $newTotalAmount\n\n');

              /// todo: update the Stock
              DocumentSnapshot stockDocumentSnapshot =
                  stockQuerySnapshot.docs.first;
              newStockId = stockDocumentSnapshot.get('stockId');
              previousStockQuantity =
                  stockDocumentSnapshot.get('stockQuantity');
              previousAvailableStockQuantity =
                  stockDocumentSnapshot.get('availableStock') ?? 0;

              previousTotalAmount = stockDocumentSnapshot.get('totalAmount');
              totalAmount = previousTotalAmount + newTotalAmount;
              DocumentReference stockDocRef = firestore
                  .collection(uid)
                  .doc('StockData')
                  .collection('AvailableStock')
                  .doc('STOCK-$newStockId');

              await stockDocRef.update({
                'stockDateAdded': Timestamp.now(),
                'availableStock': previousAvailableStockQuantity +
                    (int.tryParse(stockQuantityC.text.trim()) ?? 0),
                'stockQuantity':
                    int.tryParse(stockQuantityC.text.trim()) == null
                        ? previousStockQuantity
                        : int.tryParse(stockQuantityC.text.trim())! +
                            previousStockQuantity,
                'totalAmount': totalAmount,
              }).then((value) async {
                ///todo: add an order history
                // debugPrint(
                //     '\n\n\n\n\n\n\n\n Stock data updated !!\n\n\n\n\n\n');
                Utils.showMessage('Stock data updated !!');
                await setNewStockOrderId();

                /// adding a stock order history
                await firestore
                    .collection(uid)
                    .doc('StockData')
                    .collection('StockOrderHistory')
                    .doc('$newStockOrderId')
                    .set({
                  'stockOrderId': newStockOrderId,
                  'stockId': newStockId,
                  'stockName': stockNameC.text.trim(),
                  'stockCategory': stockCategoryC.text.trim(),
                  'stockUnitBuyPrice':
                      int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0,
                  'stockQuantity':
                      int.tryParse(stockQuantityC.text.trim()) ?? 0,
                  'totalAmount': newTotalAmount,
                  'supplierId': suppliersIdList[selectedSupplierIndex],
                  'stockDateAdded': Timestamp.now(),
                });

                /// todo: update the supplier total amount and remaining amount
                supplierId = suppliersIdList[selectedSupplierIndex];

                DocumentReference supplierRef = firestore
                    .collection(uid)
                    .doc('SuppliersData')
                    .collection('Suppliers')
                    .doc('SUP-$supplierId');

                DocumentSnapshot supplierDocSnapshot = await supplierRef.get();

                supplierPreviousTotalAmount =
                    supplierDocSnapshot.get('totalAmount');
                supplierPreviousRemainingAmount =
                    supplierDocSnapshot.get('amountRemaining') ?? 0;

                supplierRef.update({
                  'totalAmount': supplierPreviousTotalAmount + newTotalAmount,
                  'amountRemaining':
                      supplierPreviousRemainingAmount + newTotalAmount
                });

                updateListeners(false);
              }).onError((error, stackTrace) {
                debugPrint(
                    '\n\n\n\n\n\n\n some thing not worked. error!!!!!!!!!!!!! ERROR : $error}');
                Utils.showMessage(error.toString());
                updateListeners(false);
              });
              updateListeners(false);
            } else {
              Utils.showMessage('Change the stock name!');
            }
          } else {
            /// todo: stock doesn't exist
            await setNewStockId();
            await setNewStockOrderId();

            newTotalAmount = (int.tryParse(stockQuantityC.text.trim()) ?? 0) *
                (int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0);

            supplierId = suppliersIdList[selectedSupplierIndex];

            /// todo: Adding a new stock
            await firestore
                .collection(uid)
                .doc('StockData')
                .collection('AvailableStock')
                .doc('STOCK-$newStockId')
                .set({
              'stockId': newStockId,
              'stockName': stockNameC.text.trim(),
              'stockCategory': stockCategoryC.text.trim(),
              'stockDescription': stockDescriptionC.text.trim(),
              'availableStock': int.tryParse(stockQuantityC.text.trim()) ?? 0,
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
              'supplierId': supplierId,
              'stockDateAdded': Timestamp.now()
            }).then((value) async {
              /// todo: Adding the history of the stock
              await firestore
                  .collection(uid)
                  .doc('StockData')
                  .collection('StockOrderHistory')
                  .doc('$newStockOrderId')
                  .set({
                'stockOrderId': newStockOrderId,
                'stockId': newStockId,
                'stockName': stockNameC.text.trim(),
                'stockCategory': stockCategoryC.text.trim(),
                'stockUnitBuyPrice':
                    int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0,
                'stockQuantity': int.tryParse(stockQuantityC.text.trim()) ?? 0,
                'totalAmount': newTotalAmount,
                'supplierId': supplierId,
                'stockDateAdded': Timestamp.now(),
              }).then(
                (value) async {
                  /// todo: update the supplier total amount
                  debugPrint(
                      '\n\n\n\n\nSupplier id while updating the total amount: $supplierId \n\n\n\n\n');
                  DocumentReference supplierRef = firestore
                      .collection(uid)
                      .doc('SuppliersData')
                      .collection('Suppliers')
                      .doc('SUP-$supplierId');

                  DocumentSnapshot supplierDocSnapshot =
                      await supplierRef.get();

                  supplierPreviousTotalAmount =
                      supplierDocSnapshot.get('totalAmount');
                  supplierPreviousRemainingAmount =
                      supplierDocSnapshot.get('amountRemaining');

                  // debugPrint(
                  //     '\n\n\n\n\nSupplier previous total amount: $supplierPreviousTotalAmount \n\n\n\n\n');
                  // debugPrint(
                  //     '\n\n\n\n\nSupplier new total amount: $newTotalAmount \n\n\n\n\n');

                  supplierRef.update({
                    'totalAmount': supplierPreviousTotalAmount + newTotalAmount,
                    'amountRemaining':
                        supplierPreviousRemainingAmount + newTotalAmount
                  });

                  Utils.showMessage('Successfully stock added');
                  Utils.showMessage('Successfully stock order Added');
                  // debugPrint('New stock added!!!!!!!!!!!!!!!!!');

                  updateListeners(false);
                },
              ).onError(
                (error, stackTrace) {
                  Utils.showMessage('Error: $error');
                  updateListeners(false);
                },
              );
            }).onError((error, stackTrace) {
              Utils.showMessage('Error: $error');
              updateListeners(false);
            });
          }
        }
      } else {
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
        .doc('0LastStockId');

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
        .doc('0LastStockOrderId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastStockOrderId'] == null) {
      // debugPrint(
      //     'Stock ordered id found to be null --------- ${data?['LastStockOrderId']}');
      await documentRef.set({'LastStockOrderId': newStockOrderId});
    } else {
      // debugPrint(
      //     '\n\n\nStock ordered id is found to be available. \nStock order id: ${data?['LastStockOrderId']}');
      newStockOrderId = data?['LastStockOrderId'] + 1;
      await documentRef.set({'LastStockOrderId': newStockOrderId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
