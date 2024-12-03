
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/stock.dart';
import 'package:printing_press/utils/toast_message.dart';

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
  late String uid;
  bool _loading = false;

  get loading => _loading;
  bool _inStockOrderDataFetched = false;

  get inStockOrderDataFetched => _inStockOrderDataFetched;

  // all stock
  List<String> allStockList = [];
  List<Stock> stockList = [];
  late String selectedStock;
  late int selectedStockIndex;

  late Stock selectedStockModel;
  late int stockQuantity;
  late int totalAmount;

  TextEditingController customerNameC = TextEditingController();
  TextEditingController businessTitleC = TextEditingController();
  TextEditingController customerContactC = TextEditingController();
  TextEditingController customerAddressC = TextEditingController();
  TextEditingController advancePaymentC = TextEditingController();
  TextEditingController stockQuantityC = TextEditingController();

  // new stock order id
  late int newStockOrderedHistoryId;

  // customer order id
  late int newCustomerOrderId;

  // cashbook id
  late int newCashbookEntryId;

  addCustomerOrderDataInFirebase(BuildContext context) async {
    /// todo: validation after calculating the price etc
    selectedStockModel = stockList[selectedStockIndex];
    stockQuantity = int.tryParse(stockQuantityC.text.trim()) ?? 0;
    debugPrint('Stock quantity : $stockQuantity');
    totalAmount = selectedStockModel.stockUnitSellPrice * stockQuantity;
    if (_formKey.currentState != null) {
      updateListener(true);
      if (_formKey.currentState!.validate()) {
        try {
          ///todo: add as a customer order,
          await setNewCustomerStockOrderId();
          await addCustomerStockOrder();

          ///todo: add an stock order history
          await setNewStockOrderedHistoryId();
          await addStockOrderHistoryByCustomer();

          ///todo: add in cashbook
          await setNewCashbookEntryId();
          await addCustomerPaymentInCashbook();

          ///todo: reduce the remaining stock quantity
          await updateStock();
          await getAllStock();
          updateListener(false);
        } catch (e) {
          Utils.showMessage('Error: $e');
          debugPrint('Error found!\nError: $e');
          updateListener(false);
        }
      } else {
        updateListener(false);
      }
    } else {
      updateListener(false);
    }
  }

  setNewCustomerStockOrderId() async {
    newCustomerOrderId = 1;
    final documentRef = firestore
        .collection(uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('0LastCustomerOrderId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastCustomerOrderId'] == null) {
      debugPrint(
          'Order id found to be null --------- ${data?['LastCustomerOrderId']}');
      await documentRef.set({'LastCustomerOrderId': newCustomerOrderId});
    } else {
      debugPrint(
          '\n\n\nOrder id is found to be available. \nOrder id: ${data?['LastCustomerOrderId']}');
      newCustomerOrderId = data?['LastCustomerOrderId'] + 1;
      await documentRef.set({'LastCustomerOrderId': newCustomerOrderId});
    }
  }

  addCustomerStockOrder() async {
    await firestore
        .collection(uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$newCustomerOrderId')
        .set({
      'customerName': customerNameC.text.trim(),
      'businessTitle': businessTitleC.text.trim(),
      'customerContact': int.tryParse(customerContactC.text.trim()),
      'customerOrderId': newCustomerOrderId,
      'customerAddress': customerAddressC.text.trim(),
      'orderDateTime': Timestamp.now(),
      'orderStatus': 'Pending',
      'paidAmount': int.tryParse(advancePaymentC.text.trim()),
      'totalAmount': totalAmount,
      'stockId': selectedStockModel.stockId,
      'stockName': selectedStockModel.stockName,
      'stockCategory': selectedStockModel.stockCategory,
      'stockUnitSellPrice': selectedStockModel.stockUnitSellPrice,
      'stockQuantity': stockQuantity,
    }).then(
          (value) {
        Utils.showMessage('Order added!');
        debugPrint('Customer order added');
        updateListener(false);
      },
    ).onError(
          (error, stackTrace) {
        Utils.showMessage('Error: $error');
        debugPrint('Customer order error....$error');
        updateListener(false);
      },
    );
  }

  setNewStockOrderedHistoryId() async {
    newStockOrderedHistoryId = 1;
    final documentRef = firestore
        .collection(auth.currentUser!.uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .doc('0LastStockOrderId');

    final documentSnapshot = await documentRef.get();
    var data = documentSnapshot.data();

    newStockOrderedHistoryId = data?['LastStockOrderId'] + 1;
    await documentRef.set({'LastStockOrderId': newStockOrderedHistoryId});
  }

  addStockOrderHistoryByCustomer() async {
    await firestore
        .collection(uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .doc('$newStockOrderedHistoryId')
        .set({
      'stockOrderId': newStockOrderedHistoryId,
      'stockId': selectedStockModel.stockId,
      'stockName': selectedStockModel.stockName,
      'stockCategory': selectedStockModel.stockCategory,
      'stockUnitSellPrice': selectedStockModel.stockUnitSellPrice,
      'stockQuantity': stockQuantity,
      'totalAmount': totalAmount,
      'customerOrderId': newCustomerOrderId,
      'stockDateOrdered': Timestamp.now(),
    }).then(
          (value) {
        Utils.showMessage('Order history has been added!');
        debugPrint('\n\n\nCustomer stock order history  added\n\n\n');
        updateListener(false);
      },
    ).onError(
          (error, stackTrace) {
        Utils.showMessage('Error: $error');
        debugPrint('\n\n\nCustomer stock order history error.....$error\n\n\n');

        updateListener(false);
      },
    );
  }

  setNewCashbookEntryId() async {
    newCashbookEntryId = 1;
    final documentRef = firestore
        .collection(uid)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .doc('0LastCashbookEntryId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastCashbookEntryId'] == null) {
      debugPrint(
          'Cashbook entry id found to be null --------- ${data?['LastCashbookEntryId']}');
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    } else {
      debugPrint(
          '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastCashbookEntryId']}');
      newCashbookEntryId = data?['LastCashbookEntryId'] + 1;
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    }
  }

  addCustomerPaymentInCashbook() async {
    /// adding the payment history to cashbook

    await firestore
        .collection(uid)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .doc('$newCashbookEntryId')
        .set({
      'cashbookEntryId': newCashbookEntryId,
      'paymentDateTime': Timestamp.now(),
      'amount': int.tryParse(advancePaymentC.text.trim()),
      'customerOrderId': newCustomerOrderId,
      'description': 'Advance Payment',
      'paymentType': 'CASH-IN',
    }).then(
          (value) {
        Utils.showMessage('Cashbook entry added!');
        debugPrint('\n\n\nCashbook entry added\n\n\n');
        updateListener(false);
      },
    ).onError(
          (error, stackTrace) {
        Utils.showMessage('Error: $error');
        debugPrint('\n\n\nCashbook entry error.... $error\n\n\n');

        updateListener(false);
      },
    );
  }

  updateStock() async {
    DocumentReference stockDocRef = firestore
        .collection(uid)
        .doc('StockData')
        .collection('AvailableStock')
        .doc('STOCK-${selectedStockModel.stockId}');

    DocumentSnapshot snapshot = await stockDocRef.get();
    int previousAvailableStockQuantity = await snapshot.get('availableStock');

    await stockDocRef.update({
      'availableStock': previousAvailableStockQuantity -
          (int.tryParse(stockQuantityC.text.trim()))!,
    }).then(
          (value) {
        Utils.showMessage('Stock Updated!');
        debugPrint('Stock updated successfully');

        updateListener(false);
      },
    ).onError(
          (error, stackTrace) {
        Utils.showMessage('Error: $error');
        debugPrint('Stock update failed error....$error');
        updateListener(false);
      },
    );
  }

  getAllStock() async {
    _inStockOrderDataFetched = false;
    allStockList = [];
    stockList = [];
    debugPrint('Get all stock called!');
    var querySnapshot = await firestore
        .collection(auth.currentUser!.uid)
        .doc('StockData')
        .collection('AvailableStock')
        .get();
    var docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      for (int index = 1; index < docs.length; index++) {
        stockList.add(Stock.fromJson(docs[index].data()));
        allStockList.add(docs[index].get('stockName'));
      }
      selectedStockIndex = 0;
      selectedStock = allStockList[0];
    }
    _inStockOrderDataFetched = true;
    notifyListeners();
  }

  updateListener(bool load) {
    _loading = load;
    notifyListeners();
  }

  changeStockDropDown(String? newVal) {
    if (newVal != null) {
      selectedStock = newVal;
      selectedStockIndex = allStockList.indexOf(selectedStock);
      notifyListeners();
    } else {
      notifyListeners();
    }
  }
}
