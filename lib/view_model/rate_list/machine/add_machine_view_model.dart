import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/toast_message.dart';

class AddMachineViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  late int newMachineId;

  get formKey => _formKey;

  TextEditingController machineNameC = TextEditingController();
  TextEditingController sizeWidthC = TextEditingController();
  TextEditingController sizeHeightC = TextEditingController();
  TextEditingController plateRateC = TextEditingController();
  TextEditingController printingRateC = TextEditingController();

  late String machineName;
  late int sizeWidth;
  late int sizeHeight;
  late int plateRate;
  late int printingRate;

  addMachineInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if machine is already available
        machineName = machineNameC.text.trim();
        sizeWidth = int.tryParse(sizeWidthC.text.trim())!;
        sizeHeight = int.tryParse(sizeHeightC.text.trim())!;
        plateRate = int.tryParse(plateRateC.text.trim())!;
        printingRate = int.tryParse(printingRateC.text.trim())!;


        QuerySnapshot machineNameQuerySnapshot = await fireStore
            .collection(uid)
            .doc('RateList')
            .collection('Machine')
            .where('name', isEqualTo: machineName)
            .limit(1)
            .get();

        if (machineNameQuerySnapshot.docs.isNotEmpty) {
          Utils.showMessage('Try with a different name');
          updateListeners(false);
        } else {
          /// Machine doesn't exist
          await setNewMachineId();

          /// Adding a new machine
          await fireStore
              .collection(uid)
              .doc('RateList')
              .collection('Machine')
              .doc('MAC-$newMachineId')
              .set({
            'machineId': newMachineId,
            'name': machineName,
            'size': {
              'width': sizeWidth,
              'height': sizeHeight
            },
            'plateRate': plateRate,
            'printingRate': printingRate
          }).then((value) async {
            Utils.showMessage('New Machine added');
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

  setNewMachineId() async {
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Machine')

        /// 0 is added so that the last machine id document appears to the top
        /// because when we are getting the data, we ignore the first doc because it is always of id
        .doc('0LastMachineId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastMachineId'] == null) {
      newMachineId = 1;
      debugPrint('Machine id found to be null --------- ${data?['lastMachineId']}');
      await documentRef.set({'lastMachineId': newMachineId});
    } else {
      debugPrint(
          '\n\n\nMachine id is found to be available. \nMachine id: ${data?['lastMachineId']}');
      newMachineId = data?['lastMachineId'] + 1;
      await documentRef.set({'lastMachineId': newMachineId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
