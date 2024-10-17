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

  late int supplierPreviousRemainingAmount;

  late int supplierPreviousAmountPaid;

  getSupplierPreviousRemainingAmount(int? supplierId) async {
    DocumentReference supplierRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .doc('SUP-$supplierId');

    DocumentSnapshot supplierDocSnapshot = await supplierRef.get();

    supplierPreviousRemainingAmount =
        supplierDocSnapshot.get('amountRemaining');

    amountC.text = supplierPreviousRemainingAmount.toString();
  }

  //final int? supplierId; -> from where it comes
  //final int? orderId; -> from where it comes
  //final String paymentType; -> cash-in
  //final Timestamp paymentDateTime; -> auto generated
  ///   String? description; -> text field
  ///   final int amount; -> text field
  ///   final String paymentMethod; -> dropdown menu having the list of the bank accounts of the supplier + cash a default option
  addPaymentInFirestore(int? supplierId, int orderId) async {
    if (_formKey.currentState != null) {
      debugPrint('Form key is not null\n');
      updateListener(true);
      if (_formKey.currentState!.validate()) {
        debugPrint('Form key is valid\n');
        Timestamp timestamp = Timestamp.now();
        await setNewStockOrderHistoryId();

        await setNewCashbookEntryId();
        await FirebaseFirestore.instance
            .collection(uid)
            .doc('StockData')
            .collection('StockOrderHistory')
            .doc('$newStockOrderId')
            .set({
          'stockOrderId': newStockOrderId,
          'cashbookEntryId': newCashbookEntryId,
          'supplierId': supplierId,
          'amount': int.tryParse(amountC.text.trim()),
          'description': descriptionC.text.trim(),
          'paymentType': 'CASH-OUT',

          ///todo: do we need to have a bank ref?
          ///for supplier, there has to be a payment method dropdown
          'paymentMethod': paymentMethodC.text.trim(),
          'paymentDateTime': timestamp,
        }).then((value) async {
          Utils.showMessage('Supplier payment added !');

          /// adding the payment history to cashbook
          await FirebaseFirestore.instance
              .collection(uid)
              .doc('CashbookData')
              .collection('CashbookEntry')
              .doc('$newCashbookEntryId')
              .set({
            'stockOrderId': newStockOrderId,
            'cashbookEntryId': newCashbookEntryId,
            'supplierId': supplierId,
            'amount': int.tryParse(amountC.text.trim()),
            'description': descriptionC.text.trim(),
            'paymentType': 'CASH-OUT',

            ///todo: do we need to have a bank ref?
            ///for supplier, there has to be a payment method dropdown
            'paymentMethod': paymentMethodC.text.trim(),
            'paymentDateTime': timestamp,
          }).then(
            (value) async {
              Utils.showMessage('Cashbook Entry added!');
              debugPrint('\n\n\nCashbook Entry added!\n\n\n');

              /// update the supplier remaining amount and total amount paid
              DocumentReference supplierRef = FirebaseFirestore.instance
                  .collection(uid)
                  .doc('SuppliersData')
                  .collection('Suppliers')
                  .doc('SUP-$supplierId');

              DocumentSnapshot supplierDocSnapshot = await supplierRef.get();

              supplierPreviousRemainingAmount =
                  supplierDocSnapshot.get('amountRemaining');
              supplierPreviousAmountPaid =
                  supplierDocSnapshot.get('totalPaidAmount');

              supplierRef.update({
                'totalPaidAmount': supplierPreviousAmountPaid +
                    int.tryParse(amountC.text.trim())!,
                'amountRemaining': supplierPreviousRemainingAmount -
                    int.tryParse(amountC.text.trim())!
              }).then(
                (value) {
                  Utils.showMessage('Supplier rem and paid amount updated!');
                  updateListener(false);
                },
              ).onError(
                (error, stackTrace) {
                  Utils.showMessage('Sup rem and paid amount error: $error');
                  updateListener(false);
                },
              );
            },
          ).onError(
            (error, stackTrace) {
              Utils.showMessage('Cashbook entry Error:$error');
              debugPrint('\n\n\nCashbook Entry error!\n\n\n');
              updateListener(false);
            },
          );
          updateListener(false);
        }).onError(
          (error, stackTrace) {
            debugPrint(
                'Error occurred while adding supplier payment history : $error');
            Utils.showMessage('Error Occurred: $error');
            updateListener(false);
          },
        );
      } else {
        Utils.showMessage('Form key is not valid!\n');
        updateListener(false);
      }
    } else {
      debugPrint('Form key is null \n');
      Utils.showMessage('Current state = null');
      updateListener(false);
    }
  }

  setNewStockOrderHistoryId() async {
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
      //     '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastStockOrderId']}');
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
        .doc('0LastCashbookEntryId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastCashbookEntryId'] == null) {
      // debugPrint(
      //     'Cashbook entry id found to be null --------- ${data?['LastCashbookEntryId']}');
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    } else {
      // debugPrint(
      //     '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastCashbookEntryId']}');
      newCashbookEntryId = data?['LastCashbookEntryId'] + 1;
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    }
  }

  updateListener(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
