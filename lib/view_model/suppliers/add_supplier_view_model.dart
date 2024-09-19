import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/supplier.dart';
import '../../utils/toast_message.dart';

class AddSupplierViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  late int newSupplierId;

  get formKey => _formKey;
  TextEditingController supplierNameC = TextEditingController();
  TextEditingController supplierPhoneNoC = TextEditingController();
  TextEditingController supplierEmailC = TextEditingController();
  TextEditingController supplierAddressC = TextEditingController();
  TextEditingController accountNumberC = TextEditingController();

  addSupplierInFirebase() {
    updateListeners(true);

    if (_formKey.currentState != null) {
      try {
        if (_formKey.currentState!.validate()) {
          getSupplierId();
          Supplier newSupplier = Supplier(
              supplierId: newSupplierId.toString(),
              supplierName: supplierNameC.text.trim(),
              supplierPhoneNo: int.tryParse(supplierPhoneNoC.text.trim())!,
              supplierAddress: supplierAddressC.text.trim(),
              bankAccount: );
          fireStore
              .collection(uid)
              .doc("AllSuppliers")
              .collection('AllSuppliers')
              .doc(newSupplierId.toString())
              .set({
            newSupplierId.toString(): newSupplier.toMap(),
          }).then((value) {
            Utils.showMessage('Successfully supplier data added.');
            updateListeners(false);
          }).onError((error, stackTrace) {
            Utils.showMessage(error.toString());
            updateListeners(false);
          });
        }
      } on FirebaseException catch (e) {
        Utils.showMessage(e.message.toString());
        updateListeners(false);
      }
    } else {
      updateListeners(false);
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }

  getSupplierId() async {
    final collectionReference = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('AllSuppliers')
        .collection('AllSuppliers').get();

    final listQueryDocumentSnapshot = collectionReference.docs;

    if(listQueryDocumentSnapshot.isNotEmpty) {
      listQueryDocumentSnapshot.last.data().forEach((key, value) {
        newSupplierId = int.parse(key) + 1;
      });
    } else {
      newSupplierId = 1;
    }
  }
}


