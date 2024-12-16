import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/toast_message.dart';

class AddPaperViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newPaperId;

  get formKey => _formKey;

  TextEditingController paperNameC = TextEditingController();
  TextEditingController sizeWidthC = TextEditingController();
  TextEditingController sizeHeightC = TextEditingController();
  TextEditingController qualityC = TextEditingController();
  TextEditingController rateC = TextEditingController();

  late String paperName;
  late int sizeWidth;
  late int sizeHeight;
  late int quality;
  late int rate;

  addPaperInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if paper is already available
        paperName = paperNameC.text.trim();
        sizeWidth = int.tryParse(sizeWidthC.text.trim())!;
        sizeHeight = int.tryParse(sizeHeightC.text.trim())!;
        quality = int.tryParse(qualityC.text.trim())!;
        rate = int.tryParse(rateC.text.trim())!;

        QuerySnapshot paperNameQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Paper')
            .where('name', isEqualTo: paperName)
            .limit(1)
            .get();

        QuerySnapshot paperSizeQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Paper')
            .where('size',
                isEqualTo: {'height': sizeHeight, 'width': sizeWidth})
            .where('quality', isEqualTo: quality)
            .limit(1)
            .get();

        QuerySnapshot paperSizeOppositeQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Paper')
            .where('size',
                isEqualTo: {'height': sizeWidth, 'width': sizeHeight})
            .where('quality', isEqualTo: quality)
            .limit(1)
            .get();

        if (paperNameQuerySnapshot.docs.isEmpty &&
            paperSizeQuerySnapshot.docs.isEmpty &&
            paperSizeOppositeQuerySnapshot.docs.isEmpty) {
          /// Paper doesn't exist
          await setNewPaperId();

          /// Adding a new paper
          await fireStore
              .collection(uid)
              .doc('RateList')
              .collection('Paper')
              .doc('PAPER-$newPaperId')
              .set({
            'paperId': newPaperId,
            'name': paperName,
            'size': {'width': sizeWidth, 'height': sizeHeight},
            'quality': quality,
            'rate': rate
          }).then((value) async {
            Utils.showMessage('New paper added');
            updateListeners(false);
          }).onError((error, stackTrace) {
            Utils.showMessage(error.toString());
            updateListeners(false);
          });
        } else {
          if(paperNameQuerySnapshot.docs.isNotEmpty) {
            Utils.showMessage('Try a different name');
            updateListeners(false);
          } else {
            Utils.showMessage('Paper already exists');
            updateListeners(false);
          }
        }
      }
      updateListeners(false);
    } else {
      updateListeners(false);
    }
  }

  setNewPaperId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Paper')
        .doc('0LastPaperId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastPaperId'] == null) {
      newPaperId = 1;
      debugPrint('Paper id found to be null --------- ${data?['lastPaperId']}');
      await documentRef.set({'lastPaperId': newPaperId});
    } else {
      debugPrint(
          '\n\n\nPaper id is found to be available. \nPaper id: ${data?['lastPaperId']}');
      newPaperId = await data?['lastPaperId'] + 1;
      await documentRef.set({'lastPaperId': newPaperId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
