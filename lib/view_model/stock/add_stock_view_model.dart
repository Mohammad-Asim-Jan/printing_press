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

  // TextEditingController stockSizeWidthC = TextEditingController();
  // TextEditingController stockSizeHeightC = TextEditingController();
  TextEditingController stockColorC = TextEditingController();
  TextEditingController stockManufacturedByC = TextEditingController();

  // TextEditingController supplierIdC = TextEditingController();

  late List<String> suppliersNamesList;
  late String selectedSupplierName;
  late int selectedSupplierIndex;
  late List<int> suppliersIdList;

  late String stockName;
  late String stockCategory;
  late String stockDescription;
  late int stockUnitBuyPrice;
  late int stockUnitSellPrice;
  late int newStockQuantity;
  late String stockColor;
  late String stockManufacturedBy;
  late Timestamp timeStamp;

  getAllSuppliersName() async {
    _dataFetched = false;
    suppliersNamesList = [];
    suppliersIdList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection(uid)
        .doc('SuppliersData')
        .collection('Suppliers').orderBy('supplierId', descending: true)
        .get();

    List<QueryDocumentSnapshot> list = querySnapshot.docs;

    if (list.isNotEmpty) {
      // debugPrint('The list we have got, has length equals to ${list.length}');
      for (int i = 0; i < list.length; i++) {
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

  getDataFromTextFields() {
    stockName = stockNameC.text.trim();
    stockCategory = stockCategoryC.text.trim();
    stockDescription = stockDescriptionC.text.trim();
    stockUnitBuyPrice = int.tryParse(stockUnitBuyPriceC.text.trim())!;
    stockUnitSellPrice = int.tryParse(stockUnitSellPriceC.text.trim())!;
    stockColor = stockColorC.text.trim();
    stockManufacturedBy = stockManufacturedByC.text.trim();
    timeStamp = Timestamp.now();
  }

  addStockInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);
      if (_formKey.currentState!.validate()) {
        newStockQuantity = int.tryParse(stockQuantityC.text.trim())!;

        if (newStockQuantity == 0) {
          Utils.showMessage('Quantity must be greater than 0');
          updateListeners(false);
        } else {
          /// check if stock is already available
          await getDataFromTextFields();
          QuerySnapshot stockQuerySnapshot = await firestore
              .collection(uid)
              .doc('StockData')
              .collection('AvailableStock')
              .where('stockName', isEqualTo: stockName)
              .get();

          if (stockQuerySnapshot.docs.isNotEmpty) {
            debugPrint('\n\n\nIt means stock exists\n\n\n\n\n');

            /// check if the stock has the same values
            stockQuerySnapshot = await firestore
                .collection(uid)
                .doc('StockData')
                .collection('AvailableStock')
                .where('stockName', isEqualTo: stockName)
                .where('stockCategory', isEqualTo: stockCategory)
                .where('stockDescription', isEqualTo: stockDescription)
                .where('stockUnitBuyPrice', isEqualTo: stockUnitBuyPrice)
                .where('stockUnitSellPrice', isEqualTo: stockUnitSellPrice)
                .where('stockColor', isEqualTo: stockColor)
                .where('manufacturedBy', isEqualTo: stockManufacturedBy)
                .where('supplierId',
                    isEqualTo: suppliersIdList[selectedSupplierIndex])
                .limit(1)
                .get();
            if (stockQuerySnapshot.docs.isNotEmpty) {
              newTotalAmount = newStockQuantity * stockUnitBuyPrice;

              // debugPrint('\n\nNew Total Amount: $newTotalAmount\n\n');

              /// update the Stock
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
                'stockDateAdded': timeStamp,
                'availableStock':
                    previousAvailableStockQuantity + newStockQuantity,
                'stockQuantity': newStockQuantity + previousStockQuantity,
                'totalAmount': totalAmount,
              }).then((value) async {
                /// add an order history
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
                  'stockName': stockName,
                  'stockCategory': stockCategory,
                  'stockUnitBuyPrice': stockUnitBuyPrice,
                  'stockQuantity': newStockQuantity,
                  'totalAmount': newTotalAmount,
                  'supplierId': suppliersIdList[selectedSupplierIndex],
                  'stockDateAdded': timeStamp,
                });

                /// update the supplier total amount and remaining amount
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
              updateListeners(false);
            }
          } else {
            /// stock doesn't exist
            await setNewStockId();
            await setNewStockOrderId();

            newTotalAmount = newStockQuantity * stockUnitBuyPrice;

            supplierId = suppliersIdList[selectedSupplierIndex];

            /// Adding a new stock
            await firestore
                .collection(uid)
                .doc('StockData')
                .collection('AvailableStock')
                .doc('STOCK-$newStockId')
                .set({
              'stockId': newStockId,
              'stockName': stockName,
              'stockCategory': stockCategory,
              'stockDescription': stockDescription,
              'availableStock': newStockQuantity,
              'stockUnitBuyPrice': stockUnitBuyPrice,
              'stockUnitSellPrice': stockUnitSellPrice,
              'stockQuantity': newStockQuantity,
              'stockColor': stockColor,
              'manufacturedBy': stockManufacturedBy,
              'totalAmount': newTotalAmount,
              'supplierId': supplierId,
              'stockDateAdded': timeStamp
            }).then((value) async {
              /// Adding the history of the stock
              await firestore
                  .collection(uid)
                  .doc('StockData')
                  .collection('StockOrderHistory')
                  .doc('$newStockOrderId')
                  .set({
                'stockOrderId': newStockOrderId,
                'stockId': newStockId,
                'stockName': stockName,
                'stockCategory': stockCategory,
                'stockUnitBuyPrice': stockUnitBuyPrice,
                'stockQuantity': newStockQuantity,
                'totalAmount': newTotalAmount,
                'supplierId': supplierId,
                'stockDateAdded': timeStamp,
              }).then(
                (value) async {
                  /// update the supplier total amount
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

    if (data?['lastStockId'] == null) {
      debugPrint('Stock id found to be null --------- ${data?['lastStockId']}');
      await documentRef.set({'lastStockId': newStockId});
    } else {
      debugPrint(
          '\n\n\nStock id is found to be available. \nStock id: ${data?['lastStockId']}');
      newStockId = data?['lastStockId'] + 1;
      await documentRef.set({'lastStockId': newStockId});
    }
  }

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
