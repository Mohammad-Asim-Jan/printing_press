import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/utils/toast_message.dart';

class PaymentViewModel with ChangeNotifier {
  late int newStockOrderId;
  late int newCashbookEntryId;
  final _formKey = GlobalKey<FormState>();

  get formKey => _formKey;
  bool _loading = false;

  get loading => _loading;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  ///todo: validating the text field to input only the digits
  TextEditingController amountC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController paymentMethodC = TextEditingController();

  //final int? supplierId; -> from where it comes
  //final int? orderId; -> from where it comes
  //final String paymentType; -> cash-in
  //final Timestamp paymentDateTime; -> auto generated
  ///   String? description; -> text field
  ///   final int amount; -> text field
  ///   final String paymentMethod; -> dropdown menu having the list of the bank accounts of the supplier + cash a default option
  addPaymentInFirestore(int supplierId) async {
    updateListener();
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        Timestamp timestamp = Timestamp.now();
        await setNewPaymentId();
        await setNewCashbookEntryId();
        await FirebaseFirestore.instance
            .collection(uid)
            .doc('StockData')
            .collection('StockOrderHistory')
            .doc('SUP-PAY-$newStockOrderId')
            .set({
          'paymentId': newStockOrderId,
          'paymentDateTime': timestamp,
          'amount': int.tryParse(amountC.text.trim()),
          'supplierId': supplierId,
          'description': descriptionC.text.trim(),
          'paymentType': 'CASH-OUT',

          ///todo: do we need to have a bank ref?
          'paymentMethod': paymentMethodC.text.trim(),
        }).then((value) async {
          Utils.showMessage('Supplier payment added !');

          /// adding the payment history to cashbook
          await FirebaseFirestore.instance
              .collection(uid)
              .doc('CashbookData')
              .collection('CashbookEntry')
              .doc('SUP-PAY-$newCashbookEntryId')
              .set({
            'paymentId': newStockOrderId,
            'cashbookEntryId': newCashbookEntryId,
            'paymentDateTime': timestamp,
            'amount': int.tryParse(amountC.text.trim()),
            'supplierId': supplierId,
            'description': descriptionC.text.trim(),
            'paymentType': 'CASH-OUT',

            ///todo: do we need to have a bank ref?
            /// this denotes either the payment is done physically or through bank acc
            'paymentMethod': paymentMethodC.text.trim(),
          }).then(
            (value) {
              Utils.showMessage('Cashbook Entry added!');
              debugPrint('\n\n\nCashbook Entry added!\n\n\n');
            },
          ).onError(
            (error, stackTrace) {
              Utils.showMessage('Cashbook entry Error:$error');
              debugPrint('\n\n\nCashbook Entry error!\n\n\n');
            },
          );
        }).onError(
          (error, stackTrace) {
            debugPrint('Error occurred : $error');
            Utils.showMessage('Error Occurred: $error');
          },
        );
      } else {
        Utils.showMessage('Current State is not valid!');
      }
    } else {
      Utils.showMessage('Current state = null');
    }
    updateListener();
  }

  setNewPaymentId() async {
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

  setNewCashbookEntryId() async {
    newCashbookEntryId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .doc('LastCashbookEntryId');

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

  updateListener() {
    _loading = !_loading;
    notifyListeners();
  }
}
