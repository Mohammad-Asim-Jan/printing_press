import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/toast_message.dart';

class AddSupplierViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  late int newSupplierId;
  late int newBankAccountNumberId;

  get formKey => _formKey;
  TextEditingController supplierNameC = TextEditingController();
  TextEditingController supplierPhoneNoC = TextEditingController();
  TextEditingController supplierEmailC = TextEditingController();
  TextEditingController supplierAddressC = TextEditingController();
  TextEditingController accountTypeC = TextEditingController();
  TextEditingController bankAccountNumberC = TextEditingController();

  addSupplierInFirebase() async {
    updateListeners(true);

    if (_formKey.currentState != null) {
      try {
        if (_formKey.currentState!.validate()) {
          await getSupplierId();
          await getBankId();

          await fireStore
              .collection(uid)
              .doc('SuppliersData')
              .collection('Suppliers')
              .doc('SUP-$newSupplierId')
              .set({
            'supplierId': 'SUP-$newSupplierId',
            'supplierName': supplierNameC.text.trim(),
            'supplierPhoneNo':
                int.tryParse(supplierPhoneNoC.text.trim()) ?? 00000000000,
            'supplierEmail': supplierEmailC.text.trim(),
            'supplierAddress': supplierAddressC.text.trim(),
            'totalAmount': 0,
            'amountRemaining': 0,
            'totalPaidAmount': 0,
          }).then((value) {
            DocumentReference supplierDocRef = fireStore
                .collection(uid)
                .doc('SuppliersData')
                .collection('Suppliers')
                .doc('SUP-$newSupplierId');

            fireStore
                .collection(uid)
                .doc('SuppliersData')
                .collection('BankAccounts')
                .doc('SUP-BANK-$newBankAccountNumberId')
                .set({
              'SUP-BANK-$newBankAccountNumberId': [
                {
                  'bankAccountNumberId': 'SUP-BANK-$newBankAccountNumberId',
                  'bankAccountNumber': bankAccountNumberC.text.trim(),
                  'accountType': accountTypeC.text.trim(),
                  'supplierDocRef': supplierDocRef
                }
              ]
            });

            Utils.showMessage(
                'Successfully supplier data and bank account added.');
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

  /// when you want to add data of supplier or any bank account, you need to set the supplier id and bank id
  getSupplierId() async {
    newSupplierId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .doc('LastSupplierId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['supplierId'] == null) {
      debugPrint(
          'Supplier id found to be null --------- ${data?['supplierId']}');
      documentRef.set({'supplierId': newSupplierId});
    } else {
      debugPrint('Supplier id: ${data?['supplierId']}');
      newSupplierId = data?['supplierId'] + 1;
      documentRef.set({'supplierId': newSupplierId});
    }
  }

  getBankId() async {
    newBankAccountNumberId = 1;

    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('SuppliersData')
        .collection('BankAccounts')
        .doc('LastBankAccountNumberId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();
    if (data?['bankAccountNumberId'] == null) {
      debugPrint(
          'BankAccountNoId id found to be null --------- ${data?['bankAccountNumberId']}');
      documentRef.set({'bankAccountNumberId': newBankAccountNumberId});
    } else {
      debugPrint('Bank Acc No id: ${data?['bankAccountNumberId']}');
      newBankAccountNumberId = data?['bankAccountNumberId'] + 1;
      documentRef.set({'bankAccountNumberId': newBankAccountNumberId});
    }
  }
}
