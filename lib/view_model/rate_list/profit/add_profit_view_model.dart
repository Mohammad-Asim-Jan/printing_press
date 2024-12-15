import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/toast_message.dart';

class AddProfitViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newProfitId;

  get formKey => _formKey;

  TextEditingController profitNameC = TextEditingController();
  TextEditingController percentageC = TextEditingController();

  late String profitName;
  late int percentage;

  addProfitInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if profit is already available

        profitName = profitNameC.text.trim();
        percentage = int.tryParse(percentageC.text.trim())!;
        QuerySnapshot profitNameQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Profit')
            .where('name', isEqualTo: profitName)
            .limit(1)
            .get();

        QuerySnapshot profitPercentageQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Profit')
            .where('percentage', isEqualTo: percentage)
            .limit(1)
            .get();

        if (profitNameQuerySnapshot.docs.isNotEmpty &&
            profitPercentageQuerySnapshot.docs.isNotEmpty) {
          Utils.showMessage('Try with a different name');
          updateListeners(false);
        } else {
          /// profit doesn't exist
          await setNewProfitId();

          /// Adding a new Profit
          await fireStore
              .collection(uid)
              .doc('RateList')
              .collection('Profit')
              .doc('PROFIT-$newProfitId')
              .set({
            'profitId': newProfitId,
            'name': profitName,
            'percentage': percentage,
          }).then((value) async {
            Utils.showMessage('New Profit added');
            updateListeners(false);
          }).onError((error, stackTrace) {
            Utils.showMessage(error.toString());
            updateListeners(false);
          });
        }
      }
      updateListeners(false);
    } else {
      updateListeners(false);
    }
  }

  setNewProfitId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Profit')

        /// 0 is added so that the last profit id document appears to the top
        /// because when we are getting the data, we ignore the first doc because it is always of id
        .doc('0LastProfitId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastProfitId'] == null) {
      newProfitId = 1;
      debugPrint(
          'Profit id found to be null --------- ${data?['lastProfitId']}');
      await documentRef.set({'lastProfitId': newProfitId});
    } else {
      debugPrint(
          '\n\n\nProfit id is found to be available. \nProfit id: ${data?['lastProfitId']}');
      newProfitId = data?['lastProfitId'] + 1;
      await documentRef.set({'lastProfitId': newProfitId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
