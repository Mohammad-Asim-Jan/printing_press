import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/toast_message.dart';

class PaymentFromCustomerViewModel with ChangeNotifier {
  late int newCashbookEntryId;

  final _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  bool _loading = false;

  get loading => _loading;

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;

  TextEditingController amountC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController paymentMethodC = TextEditingController();

  addPaymentInFirestore(int customerOrderId, int previousAmount) async {
    updateListener(true);
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        int amount = int.tryParse(amountC.text.trim())!;
        String description = descriptionC.text.trim();
        String paymentMethod = paymentMethodC.text.trim();
        Timestamp timeStamp = Timestamp.now();

        await setNewCashbookEntryId();

        /// adding the payment history to cashbook
        await firestore
            .collection(uid)
            .doc('CashbookData')
            .collection('CashbookEntry')
            .doc('$newCashbookEntryId')
            .set({
          'cashbookEntryId': newCashbookEntryId,
          'customerOrderId': customerOrderId,
          'amount': amount,
          'description': description,
          'paymentType': 'CASH-IN',
          'paymentMethod': paymentMethod,
          'paymentDateTime': timeStamp,
        }).then(
          (value) async {
            Utils.showMessage('Cashbook Entry added!');

            DocumentReference customerOrderRef = firestore
                .collection(uid)
                .doc('CustomerData')
                .collection('CustomerOrders')
                .doc('$customerOrderId');

            customerOrderRef
                .update({'paidAmount': previousAmount + amount}).then(
              (value) {
                updateListener(false);
              },
            ).onError(
              (error, stackTrace) {
                debugPrint(error.toString());
                updateListener(false);
              },
            );
          },
        ).onError(
          (error, stackTrace) {
            debugPrint(error.toString());
            updateListener(false);
          },
        );
        updateListener(false);
      } else {
        Utils.showMessage('Fill the values');
        updateListener(false);
      }
    } else {
      Utils.showMessage('Error');
      updateListener(false);
    }
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
