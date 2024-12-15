import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/toast_message.dart';

class AddNewsPaperViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newNewsPaperId;

  get formKey => _formKey;

  TextEditingController newsPaperNameC = TextEditingController();
  TextEditingController sizeWidthC = TextEditingController();
  TextEditingController sizeHeightC = TextEditingController();
  TextEditingController qualityC = TextEditingController();
  TextEditingController rateC = TextEditingController();

  late String newsPaperName;
  late int sizeWidth;
  late int sizeHeight;
  late int quality;
  late int rate;

  addNewsPaperInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if newsPaper is already available

        newsPaperName = newsPaperNameC.text.trim();
        sizeWidth = int.tryParse(sizeWidthC.text.trim())!;
        sizeHeight = int.tryParse(sizeHeightC.text.trim())!;
        quality = int.tryParse(qualityC.text.trim())!;
        rate = int.tryParse(rateC.text.trim())!;

        QuerySnapshot newsPaperNameQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('NewsPaper')
            .where('name', isEqualTo: newsPaperName)
            .limit(1)
            .get();

        if (newsPaperNameQuerySnapshot.docs.isNotEmpty) {
          Utils.showMessage('Try with a different name');
          updateListeners(false);
        } else {
          /// NewsPaper doesn't exist
          await setNewNewsPaperId();

          /// Adding a new newsPaper
          await fireStore
              .collection(uid)
              .doc('RateList')
              .collection('NewsPaper')
              .doc('NEWS-$newNewsPaperId')
              .set({
            'paperId': newNewsPaperId,
            'name': newsPaperName,
            'size': {'width': sizeWidth, 'height': sizeHeight},
            'quality': quality,
            'rate': rate
          }).then((value) async {
            Utils.showMessage('New NewsPaper added');
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

  setNewNewsPaperId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('NewsPaper')

        /// 0 is added so that the last newsPaper id document appears to the top
        /// because when we are getting the data, we ignore the first doc because it is always of id
        .doc('0LastNewsPaperId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastNewsPaperId'] == null) {
      newNewsPaperId = 1;
      debugPrint(
          'NewsPaper id found to be null --------- ${data?['lastNewsPaperId']}');
      await documentRef.set({'lastNewsPaperId': newNewsPaperId});
    } else {
      debugPrint(
          '\n\n\nNewsPaper id is found to be available. \nNewsPaper id: ${data?['lastNewsPaperId']}');
      newNewsPaperId = data?['lastNewsPaperId'] + 1;
      await documentRef.set({'lastNewsPaperId': newNewsPaperId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
