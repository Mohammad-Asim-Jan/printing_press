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
        ///todo: check if the quantity is null or zero, then don't update
        /// check if profit is already available

        profitName = profitNameC.text.trim();
        percentage = int.tryParse(percentageC.text.trim())!;
        QuerySnapshot profitQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Profit')
            .where('name', isEqualTo: profitName)
            .limit(1)
            .get();

        if (profitQuerySnapshot.docs.isNotEmpty) {
          debugPrint('\n\n\nIt means profit exist.'
              '\n\n\n\n\n');
          Utils.showMessage('Try another name!');
          // /// update the profit
          // DocumentSnapshot profitDocumentSnapshot =
          //     profitQuerySnapshot.docs.first;
          //
          // newProfitId = profitDocumentSnapshot.get('profitId');
          // debugPrint('Profit id found is : $newProfitId');
          // // try {
          // DocumentReference profitDocRef = fireStore
          //     .collection(uid)
          //     .doc('RateList')
          //     .collection('Profit')
          //     .doc('DES-$newProfitId');
          //
          // await profitDocRef.update({
          //   'rate': int.tryParse(rateC.text.trim()) ?? 0,
          // }).then((value) async {
          //   debugPrint('\n\n\n\n\n\n\n\n Profit data updated !!\n\n\n\n\n\n');
          //   Utils.showMessage('Profit data updated !!');
          //
          //   updateListeners(false);
          // }).onError((error, stackTrace) {
          //   debugPrint(
          //       '\n\n\n\nNot updated error!!!!!!!!!!!!! ERROR : $error}\n\n\n');
          //   Utils.showMessage(error.toString());
          //   updateListeners(false);
          // });
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
            debugPrint('New Profit added!!!!!!!!!!!!!!!!!');

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

    if (data?['profitId'] == null) {
      newProfitId = 1;
      debugPrint('Profit id found to be null --------- ${data?['profitId']}');
      await documentRef.set({'profitId': newProfitId});
    } else {
      debugPrint(
          '\n\n\nProfit id is found to be available. \nProfit id: ${data?['profitId']}');
      newProfitId = data?['profitId'] + 1;
      await documentRef.set({'profitId': newProfitId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
