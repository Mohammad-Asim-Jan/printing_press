import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/toast_message.dart';

class AddSupplierViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  get formKey => _formKey;
  TextEditingController supplierNameC = TextEditingController();
  TextEditingController supplierPhoneC = TextEditingController();
  TextEditingController supplierEmailC = TextEditingController();
  TextEditingController supplierAddressC = TextEditingController();
  TextEditingController supplierAccountNoC = TextEditingController();

  addSupplierInFirebase() {
    updateListeners(true);
    // int supplierId = getSupplierId();
    int supplierId = 1;
    fireStore.collection(uid).doc("AllSuppliers").set({
      supplierId.toString():
        {
          'supplierId': supplierId,
          'supplierName': supplierNameC.text.trim(),
          'supplierPhoneNo': supplierPhoneC.text.trim(),
          'supplierAddress': supplierAddressC.text.trim(),
          'accountNumber': supplierAccountNoC.text.trim()
        },
    }).then((value) {
      debugPrint('Value from then function:');
      Utils.showMessage('Successfully supplier data added.');
      updateListeners(false);
    }).onError((error, stackTrace) {
      Utils.showMessage(error.toString());
      updateListeners(false);
    });
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }

// getSupplierId() {
//   ///todo: find id
// }
}
