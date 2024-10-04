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

  addPaperCuttingInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        ///todo: check if the quantity is null or zero, then don't update
        /// check if PaperCutting is already available

        QuerySnapshot bindingQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('PaperCutting')
            .where('name', isEqualTo: paperCuttingNameC.text.trim())
            .limit(1)
            .get();

        if (bindingQuerySnapshot.docs.isNotEmpty) {
          debugPrint('\n\n\n\n\n\n\n\n\n\nIt means PaperCutting exist.'
              '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');

          /// update the PaperCutting
          DocumentSnapshot paperCuttingDocumentSnapshot =
              bindingQuerySnapshot.docs.first;

          newPaperCuttingId =
              paperCuttingDocumentSnapshot.get('paperCuttingId');
          debugPrint('PaperCutting id found : $newPaperCuttingId');
          // try {
          DocumentReference paperCuttingDocRef = fireStore
              .collection(uid)
              .doc('RateList')
              .collection('PaperCutting')
              .doc('PAP-CUT-$newPaperCuttingId');

          await paperCuttingDocRef.update({
            'rate': int.tryParse(rateC.text.trim()) ?? 0,
          }).then((value) async {
            debugPrint(
                '\n\n\n\n\n\n\n\nPaperCutting data updated !!\n\n\n\n\n\n');
            Utils.showMessage('PaperCutting data updated !!');

            updateListeners(false);
          }).onError((error, stackTrace) {
            debugPrint(
                '\n\n\n\nNot updated error!!!!!!!!!!!!! ERROR : $error}\n\n\n');
            Utils.showMessage(error.toString());
            updateListeners(false);
          });
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
            'name': paperCuttingNameC.text.trim(),
            'rate': int.tryParse(rateC.text.trim()) ?? 0,
          }).then((value) async {
            Utils.showMessage('New paperCutting added');
            debugPrint('New paperCutting added!!!!!!!!!!!!!!!!!');

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

    if (data?['paperCuttingId'] == null) {
      newPaperCuttingId = 1;
      debugPrint(
          'PaperCutting id found to be null --------- ${data?['paperCuttingId']}');
      await documentRef.set({'paperCuttingId': newPaperCuttingId});
    } else {
      debugPrint(
          '\n\n\nPaperCutting id found to be available. \nPaperCutting id: ${data?['paperCuttingId']}');
      newPaperCuttingId = data?['paperCuttingId'] + 1;
      await documentRef.set({'paperCuttingId': newPaperCuttingId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
