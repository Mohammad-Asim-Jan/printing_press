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
  late int rate;

  addDesignInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        ///todo: check if the quantity is null or zero, then don't update
        /// check if design is already available

        designName = designNameC.text.trim();
        rate = int.tryParse(rateC.text.trim())!;

        QuerySnapshot designQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Design')
            .where('name', isEqualTo: designName)
            .limit(1)
            .get();

        if (designQuerySnapshot.docs.isNotEmpty) {
          debugPrint('\n\n\n\n\n\n\n\n\n\nIt means design exist.'
              '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');

          // /// update the design
          // DocumentSnapshot designDocumentSnapshot =
          //     designQuerySnapshot.docs.first;
          //
          // newDesignId = designDocumentSnapshot.get('designId');
          // debugPrint('Design id found is : $newDesignId');
          // // try {
          // DocumentReference designDocRef = fireStore
          //     .collection(uid)
          //     .doc('RateList')
          //     .collection('Design')
          //     .doc('DES-$newDesignId');
          //
          // await designDocRef.update({
          //   'rate': int.tryParse(rateC.text.trim()) ?? 0,
          // }).then((value) async {
          //   debugPrint('\n\n\n\n\n\n\n\n Design data updated !!\n\n\n\n\n\n');
          //   Utils.showMessage('Design data updated !!');
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
            'rate': rate,
          }).then((value) async {
            Utils.showMessage('New Design added');
            debugPrint('New Design added!!!!!!!!!!!!!!!!!');

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

    if (data?['designId'] == null) {
      newDesignId = 1;
      debugPrint('Design id found to be null --------- ${data?['designId']}');
      await documentRef.set({'designId': newDesignId});
    } else {
      debugPrint(
          '\n\n\nDesign id is found to be available. \nDesign id: ${data?['designId']}');
      newDesignId = data?['designId'] + 1;
      await documentRef.set({'designId': newDesignId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
