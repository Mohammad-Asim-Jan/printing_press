import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/utils/toast_message.dart';

class AddNumberingViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newNumberingId;

  get formKey => _formKey;

  TextEditingController numberingNameC = TextEditingController();
  TextEditingController rateC = TextEditingController();

  late String numberingName;
  late int rate;

  addNumberingInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
       /// check if Numbering is already available

        numberingName = numberingNameC.text.trim();
        rate = int.tryParse(rateC.text.trim())!;

        QuerySnapshot numberingQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Numbering')
            .where('name', isEqualTo: numberingName)
            .limit(1)
            .get();

        if (numberingQuerySnapshot.docs.isNotEmpty) {
          Utils.showMessage('Try with a different name');
          updateListeners(false);
        } else {
          /// Numbering doesn't exist
          await setNewNumberingId();

          /// Adding a new Numbering
          await fireStore
              .collection(uid)
              .doc('RateList')
              .collection('Numbering')
              .doc('NUM-$newNumberingId')
              .set({
            'numberingId': newNumberingId,
            'name': numberingName,
            'rate': rate,
          }).then((value) async {
            Utils.showMessage('New Numbering added');
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

  setNewNumberingId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Numbering')

        /// 0 is added so that the last Numbering id document appears to the top
        /// because when we are getting the data, we ignore the first doc because it is always of id
        .doc('0LastNumberingId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastNumberingId'] == null) {
      newNumberingId = 1;
      debugPrint(
          'Numbering id found to be null --------- ${data?['lastNumberingId']}');
      await documentRef.set({'lastNumberingId': newNumberingId});
    } else {
      debugPrint(
          '\n\n\nNumbering id found to be available. \nNumbering id: ${data?['lastNumberingId']}');
      newNumberingId = data?['lastNumberingId'] + 1;
      await documentRef.set({'lastNumberingId': newNumberingId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
