import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/utils/toast_message.dart';

class AddDesignViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newDesignId;

  get formKey => _formKey;

  TextEditingController designNameC = TextEditingController();
  TextEditingController rateC = TextEditingController();

  late String designName;
  late int designRate;

  addDesignInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if design is already available
        designName = designNameC.text.trim();
        designRate = int.tryParse(rateC.text.trim())!;

        QuerySnapshot designNameQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Design')
            .where('name', isEqualTo: designName)
            .limit(1)
            .get();

        if (designNameQuerySnapshot.docs.isNotEmpty) {
          Utils.showMessage('Try with a different name');
          updateListeners(false);
        } else {
          /// design doesn't exist
          await setNewDesignId();

          /// Adding a new design
          await fireStore
              .collection(uid)
              .doc('RateList')
              .collection('Design')
              .doc('DES-$newDesignId')
              .set({
            'designId': newDesignId,
            'name': designName,
            'rate': designRate,
          }).then((value) async {
            Utils.showMessage('New Design added');
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

  setNewDesignId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Design')

        /// 0 is added so that the last design id document appears to the top
        /// because when we are getting the data, we ignore the first doc because it is always of id
        .doc('0LastDesignId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastDesignId'] == null) {
      newDesignId = 1;
      debugPrint(
          'Design id found to be null --------- ${data?['lastDesignId']}');
      await documentRef.set({'lastDesignId': newDesignId});
    } else {
      debugPrint(
          '\n\n\nDesign id is found to be available. \nDesign id: ${data?['lastDesignId']}');
      newDesignId = data?['lastDesignId'] + 1;
      await documentRef.set({'lastDesignId': newDesignId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
