import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/utils/toast_message.dart';

class AddBindingViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newBindingId;

  get formKey => _formKey;

  TextEditingController bindingNameC = TextEditingController();
  TextEditingController bindingRateC = TextEditingController();

  late String bindingName;
  late int bindingRate;

  addBindingInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if binding is already available
        bindingName = bindingNameC.text.trim();
        bindingRate = int.tryParse(bindingRateC.text.trim())!;

        QuerySnapshot bindingNameQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Binding')
            .where('name', isEqualTo: bindingName)
            .limit(1)
            .get();

        if (bindingNameQuerySnapshot.docs.isNotEmpty) {
          Utils.showMessage('Try with a different name');
          updateListeners(false);
        } else {
          /// binding doesn't exist
          await setNewBindingId();

          /// Adding a new binding
          await fireStore
              .collection(uid)
              .doc('RateList')
              .collection('Binding')
              .doc('BIND-$newBindingId')
              .set({
            'bindingId': newBindingId,
            'name': bindingName,
            'rate': bindingRate,
          }).then((value) async {
            Utils.showMessage('New Binding added');
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

  setNewBindingId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Binding')

        /// 0 is added so that the last binding id document appears to the top
        /// because when we are getting the data, we ignore the first doc because it is always of id
        .doc('0LastBindingId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastBindingId'] == null) {
      newBindingId = 1;
      debugPrint(
          'Binding id found to be null --------- ${data?['lastBindingId']}');
      await documentRef.set({'lastBindingId': newBindingId});
    } else {
      debugPrint(
          '\n\n\nBinding id is found to be available. \nBinding id: ${data?['lastBindingId']}');
      newBindingId = data?['lastBindingId'] + 1;
      await documentRef.set({'lastBindingId': newBindingId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
