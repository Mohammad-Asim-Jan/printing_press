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
  TextEditingController rateC = TextEditingController();

  late String bindingName;
  late int rate;
  addBindingInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        ///todo: check if the quantity is null or zero, then don't update
        /// check if binding is already available
        bindingName = bindingNameC.text.trim();
        rate =int.tryParse(rateC.text.trim())!;
        QuerySnapshot bindingQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Binding')
            .where('name', isEqualTo: bindingName)
            .limit(1)
            .get();

        if (bindingQuerySnapshot.docs.isNotEmpty) {
          debugPrint('\n\n\n\n\n\n\n\n\n\nIt means binding exists.'
              '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');

          /// no need to update
          /// just show a message that the binding is already available

          // /// update the binding
          // DocumentSnapshot bindingDocumentSnapshot =
          //     bindingQuerySnapshot.docs.first;
          //
          // newBindingId = bindingDocumentSnapshot.get('bindingId');
          // debugPrint('Binding id found is : $newBindingId');
          // // try {
          // DocumentReference bindingDocRef = fireStore
          //     .collection(uid)
          //     .doc('RateList')
          //     .collection('Binding')
          //     .doc('BIND-$newBindingId');
          //
          // await bindingDocRef.update({
          //   'rate': int.tryParse(rateC.text.trim()) ?? 0,
          // }).then((value) async {
          //   debugPrint('\n\n\n\n\n\n\n\n binding data updated !!\n\n\n\n\n\n');
          //   Utils.showMessage('binding data updated !!');
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
            'rate': rate,
          }).then((value) async {
            Utils.showMessage('New Binding added');
            debugPrint('New binding added!!!!!!!!!!!!!!!!!');

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

    if (data?['bindingId'] == null) {
      newBindingId = 1;
      debugPrint('Binding id found to be null --------- ${data?['bindingId']}');
      await documentRef.set({'bindingId': newBindingId});
    } else {
      debugPrint(
          '\n\n\nBinding id is found to be available. \nBinding id: ${data?['bindingId']}');
      newBindingId = data?['bindingId'] + 1;
      await documentRef.set({'bindingId': newBindingId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
