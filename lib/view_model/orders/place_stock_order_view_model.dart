import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/stock.dart';

class PlaceStockOrderViewModel with ChangeNotifier {
  ///todo:
  // todo Add the amount in cash book
  // todo Add the order in all orders
  // todo Decrement from allProduct or stock if selected a product
  // todo Order date and time plus order completion time


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late bool _inStockOrderDataFetched;

  get inStockOrderDataFetched => _inStockOrderDataFetched;

  // all stock
  List<String> allStockList = [];
  List<Stock> stockList = [];
  late String selectedStock;
  late int selectedStockIndex;

  /// use it
  TextEditingController customerNameC = TextEditingController();

  /// use it
  TextEditingController businessTitleC = TextEditingController();

  /// use it
  TextEditingController customerContactC = TextEditingController();

  /// use it
  TextEditingController customerAddressC = TextEditingController();

  /// use it
  TextEditingController advancePaymentC = TextEditingController();

  TextEditingController stockQuantityC = TextEditingController();

  // new stock order id
  late int newStockOrderedId;

  // stock id
  late int stockId;

  getAllStock() async {
    allStockList = [];
    _inStockOrderDataFetched = false;
    debugPrint('Get all stock called!');
    allStockList.add('None');
    stockList.add(Stock(
        stockId: 0,
        stockName: 'None',
        stockQuantity: 0,
        stockDescription: 'None',
        stockCategory: 'None',
        stockUnitBuyPrice: 0,
        stockUnitSellPrice: 0,
        availableStock: 0,
        stockColor: 'None',
        manufacturedBy: 'None',
        supplierId: 0,
        stockDateAdded: Timestamp.now()));
    selectedStockIndex = 0;
    selectedStock = allStockList[0];
    var querySnapshot = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('StockData')
        .collection('AvailableStock')
        .get();
    var docs = querySnapshot.docs;
    if (docs.length >= 2) {
      for (int index = 1; index < docs.length; index++) {
        stockList.add(Stock.fromJson(docs[index].data()));
        allStockList.add(docs[index].get('stockName'));
      }
    }
    _inStockOrderDataFetched = true;
    updateListener();
  }

  updateListener() {
    notifyListeners();
  }

  changeStockDropDown(String? newVal) {
    if (newVal != null) {
      selectedStock = newVal;
      selectedStockIndex = allStockList.indexOf(selectedStock);
      updateListener();

      if (newVal == 'None') {
        debugPrint("No stock selected");
      } else {
        debugPrint('Stock Rate: ');
      }
    } else {
      notifyListeners();
    }
  }

  // addCustomerStockOrder() async {
  //   if (_formKey.currentState != null) {
  //     if (_formKey.currentState!.validate()) {
  //       {
  //         setNewStockOrderedId();
  //         stockId = int.tryParse(stockIdC.text.trim()) ?? 1;
  //
  //         ///todo: get the details of the stock using the stock id or stock name
  //
  //         /// Adding the history of the stock
  //         await firestore
  //             .collection(auth.currentUser!.uid)
  //             .doc('StockData')
  //             .collection('StockOrdered')
  //             .doc('CUS-ORDER-$newStockOrderedId')
  //             .set({
  //           'stockOrderId': newStockOrderedId,
  //           'stockId': stockId,
  //           'stockName': stockNameC.text.trim(),
  //           'stockCategory': stockCategoryC.text.trim(),
  //           'stockUnitBuyPrice':
  //               int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0,
  //           'stockQuantity': int.tryParse(stockQuantityC.text.trim()) ?? 0,
  //           'totalAmount': newTotalAmount,
  //           'customerOrderId': int.tryParse(supplierIdC.text.trim()),
  //           'stockDateAdded': Timestamp.now(),
  //         });
  //
  //         /// update the supplier total amount
  //         supplierId = int.tryParse(supplierIdC.text.trim())!;
  //
  //         debugPrint(
  //             '\n\n\n\n\nSupplier id while updating the total amount: $supplierId \n\n\n\n\n');
  //         DocumentReference supplierRef = fireStore
  //             .collection(uid)
  //             .doc('SuppliersData')
  //             .collection('Suppliers')
  //
  //             /// todo: create a method which will find the supplier id by using supplier name
  //             .doc('SUP-$supplierId');
  //
  //         DocumentSnapshot supplierDocSnapshot = await supplierRef.get();
  //
  //         supplierPreviousTotalAmount = supplierDocSnapshot.get('totalAmount');
  //
  //         debugPrint(
  //             '\n\n\n\n\nSupplier previous total amount: $supplierPreviousTotalAmount \n\n\n\n\n');
  //         debugPrint(
  //             '\n\n\n\n\nSupplier new total amount: $newTotalAmount \n\n\n\n\n');
  //
  //         supplierRef.update({
  //           'totalAmount': supplierPreviousTotalAmount + newTotalAmount,
  //         });
  //
  //         Utils.showMessage('Successfully user stock order Added');
  //         debugPrint('New stock added!!!!!!!!!!!!!!!!!');
  //
  //         updateListener();
  //       }
  //     } else {
  //       updateListener();
  //     }
  //   } else {
  //     updateListener();
  //   }
  // }

  setNewStockOrderedId() async {
    newStockOrderedId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(auth.currentUser!.uid)
        .doc('StockData')
        .collection('StockOrdered')
        .doc('LastStockOrderedId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastStockOrderedId'] == null) {
      debugPrint(
          'Stock ordered id found to be null --------- ${data?['LastStockOrderedId']}');
      await documentRef.set({'LastStockOrderedId': newStockOrderedId});
    } else {
      debugPrint(
          '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastStockOrderedId']}');
      newStockOrderedId = data?['LastStockOrderedId'] + 1;
      await documentRef.set({'LastStockOrderedId': newStockOrderedId});
    }
  }
}
