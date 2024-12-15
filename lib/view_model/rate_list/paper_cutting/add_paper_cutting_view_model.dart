import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/utils/toast_message.dart';

class AddPaperCuttingViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newPaperCuttingId;

  get formKey => _formKey;

  TextEditingController paperCuttingNameC = TextEditingController();
  TextEditingController rateC = TextEditingController();

  late String paperCuttingName;
  late int rate;

  addPaperCuttingInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if PaperCutting is already available

        paperCuttingName = paperCuttingNameC.text.trim();
        rate = int.tryParse(rateC.text.trim())!;

        QuerySnapshot bindingQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('PaperCutting')
            .where('name', isEqualTo: paperCuttingName)
            .limit(1)
            .get();

        if (bindingQuerySnapshot.docs.isNotEmpty) {
          Utils.showMessage('Try with a different name');
          updateListeners(false);
        } else {
          /// PaperCutting doesn't exist
          await setNewPaperCuttingId();

          /// Adding a new PaperCutting
          await fireStore
              .collection(uid)
              .doc('RateList')
              .collection('PaperCutting')
              .doc('PAP-CUT-$newPaperCuttingId')
              .set({
            'paperCuttingId': newPaperCuttingId,
            'name': paperCuttingName,
            'rate': rate,
          }).then((value) async {
            Utils.showMessage('New paperCutting added');
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

  setNewPaperCuttingId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('PaperCutting')

        /// 0 is added so that the last PaperCutting id document appears to the top
        /// because when we are getting the data, we ignore the first doc because it is always of id
        .doc('0LastPaperCuttingId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastPaperCuttingId'] == null) {
      newPaperCuttingId = 1;
      debugPrint(
          'PaperCutting id found to be null --------- ${data?['lastPaperCuttingId']}');
      await documentRef.set({'lastPaperCuttingId': newPaperCuttingId});
    } else {
      debugPrint(
          '\n\n\nPaperCutting id found to be available. \nPaperCutting id: ${data?['lastPaperCuttingId']}');
      newPaperCuttingId = data?['lastPaperCuttingId'] + 1;
      await documentRef.set({'lastPaperCuttingId': newPaperCuttingId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
