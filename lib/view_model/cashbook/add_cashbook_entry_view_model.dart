import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/utils/toast_message.dart';

class AddCashbookEntryViewModel with ChangeNotifier {
  late int newCashbookEntryId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController amountC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();

  TextEditingController paymentMethodC = TextEditingController();

  get formKey => _formKey;

  bool _loading = false;

  get loading => _loading;

  final uId = FirebaseAuth.instance.currentUser!.uid;

  String selectedPaymentType = 'CASH-OUT';

  changePaymentTypeDropdown(String? newVal) {
    if (newVal != null) {
      selectedPaymentType = newVal;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  addCashbookEntryInFirebase() async {
    if (_formKey.currentState != null) {
      updateListeners(true);
      if (_formKey.currentState!.validate()) {
        await setNewCashbookEntryId();
        await FirebaseFirestore.instance
            .collection(uId)
            .doc('CashbookData')
            .collection('CashbookEntry')
            .doc('RND-PAY-$newCashbookEntryId')
            .set({
          'paymentId': newCashbookEntryId,
          'paymentDateTime': Timestamp.now(),
          'amount': int.tryParse(amountC.text.trim()),
          'description': descriptionC.text.trim(),
          'paymentType': selectedPaymentType,
          'paymentMethod': paymentMethodC.text.trim(),
        }).then(
          (value) {
            Utils.showMessage('Entry Added Successfully!');
            updateListeners(false);
          },
        ).onError(
          (error, stackTrace) {
            Utils.showMessage('Error: $error');
            updateListeners(false);
          },
        );
      } else {
        updateListeners(false);
      }
    } else {
      updateListeners(false);
    }
  }

  setNewCashbookEntryId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uId)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .doc('LastCashbookEntryId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastCashbookEntryId'] == null) {
      newCashbookEntryId = 1;

      debugPrint(
          'Cashbook entry id found to be null --------- ${data?['LastCashbookEntryId']}');
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    } else {
      debugPrint(
          '\n\n\nCashbook entry id is found to be available. \nEntry Id: ${data?['LastCashbookEntryId']}');
      newCashbookEntryId = data?['LastCashbookEntryId'] + 1;
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    }
  }

  updateListeners(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
