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

  late String supplierName;
  late String supplierPhoneNo;
  late String supplierEmail;
  late String supplierAddress;
  late String accountType;
  late String bankAccountNumber;

  addSupplierInFirebase() async {
    // updateListeners(true);
    /// scenarios: 1. Already exist 2. New Supplier
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if supplier is already available

        supplierName = supplierNameC.text.trim();
        supplierPhoneNo = supplierPhoneNoC.text.trim();
        supplierEmail = supplierEmailC.text.trim();
        supplierAddress = supplierAddressC.text.trim();
        accountType = accountTypeC.text.trim();
        bankAccountNumber = bankAccountNumberC.text.trim();

        QuerySnapshot supplierQuerySnapshot = await fireStore
            .collection(uid)
            .doc('SuppliersData')
            .collection('Suppliers')
            .where('supplierName', isEqualTo: supplierName)
            .limit(1)
            .get();

        if (supplierQuerySnapshot.docs.isNotEmpty) {
          debugPrint('\n\n\nIt means supplier exists.\n\n\n\n\n\n');
          Utils.showMessage('Supplier Already Exists!');

          // /// update the supplier and add the bank account
          // DocumentSnapshot supplierDocumentSnapshot =
          //     supplierQuerySnapshot.docs.first;
          // newSupplierId = supplierDocumentSnapshot.get('supplierId');
          // // try {
          // DocumentReference supplierDocRef = fireStore
          //     .collection(uid)
          //     .doc('SuppliersData')
          //     .collection('Suppliers')
          //     .doc('SUP-$newSupplierId');
          // await supplierDocRef.update({
          //   'supplierPhoneNo':
          //       int.tryParse(supplierPhoneNoC.text.trim()) ?? 00000000000,
          //   'supplierEmail': supplierEmailC.text.trim(),
          //   'supplierAddress': supplierAddressC.text.trim(),
          // }).then((value) async {
          //   debugPrint('\n\n\n\n\n\n\n\n Supplier data updated !!\n\n\n\n\n\n');
          //
          //   /// updating existing bank account data
          //   DocumentSnapshot documentSnapshot = await fireStore
          //       .collection(uid)
          //       .doc('SuppliersData')
          //       .collection('BankAccounts')
          //       .doc('SUP-BANK-$newSupplierId')
          //       .get();
          //
          //   List<BankAccount> bankAccounts = [];
          //   List<dynamic> bankAccountNumbersObj =
          //       documentSnapshot.get('bankAccounts');
          //
          //   int index = 0;
          //   for (var i in bankAccountNumbersObj) {
          //     if (i is Map<String, dynamic>) {
          //       bankAccounts.add(BankAccount.fromJson(i));
          //       debugPrint(
          //           '\n\n\n\n\n Bank account added: ${bankAccounts[index].bankAccountNumber}\n\n\n\n\n\n\n\n');
          //     } else {
          //       debugPrint(
          //           '\n\n\n\n\n IT is not a map of string, dynamic: $i \n\n\n\n\n\n\n\n');
          //     }
          //
          //     index++;
          //   }
          //
          //   index = 0;
          //   int selectedIndex = -1;
          //
          //   if (bankAccounts.isNotEmpty) {
          //     for (var i in bankAccounts) {
          //       if (i.bankAccountNumber.toLowerCase() ==
          //           bankAccountNumberC.text.trim().toLowerCase()) {
          //         selectedIndex = index;
          //       }
          //       index++;
          //     }
          //   }
          //   if (selectedIndex == -1) {
          //     debugPrint(
          //         '\n\n\n\n\n NO SAME ACCOUNT OF BANK FOUND!!! \n\n\n\n\n\n\n\n');
          //     await setNewBankId();
          //     await fireStore
          //         .collection(uid)
          //         .doc('SuppliersData')
          //         .collection('BankAccounts')
          //         .doc('SUP-BANK-$newSupplierId')
          //         .update({
          //       'bankAccounts': FieldValue.arrayUnion([
          //         {
          //           'bankAccountNumberId': newBankAccountNumberId,
          //           'bankAccountNumber': bankAccountNumberC.text.trim(),
          //           'accountType': accountTypeC.text.trim(),
          //         }
          //       ])
          //     });
          //   } else {
          //     debugPrint(
          //         '\n\n\n\n\n SAME ACCOUNT OF BANK FOUND... \n\n\n\n\n\n\n\n');
          //     bankAccounts[selectedIndex] = BankAccount(
          //         bankAccountNumberId:
          //             bankAccounts[selectedIndex].bankAccountNumberId,
          //         bankAccountNumber: bankAccountNumberC.text.trim(),
          //         accountType: accountTypeC.text.trim());
          //
          //     fireStore
          //         .collection(uid)
          //         .doc('SuppliersData')
          //         .collection('BankAccounts')
          //         .doc('SUP-BANK-$newSupplierId')
          //         .update({
          //       'bankAccounts': bankAccounts.map((e) => e.toMap()).toList()
          //     }).then(
          //       (value) {
          //         debugPrint(
          //             "\n\n\n\n\n\nSuccessfully Bank accounts undated !!!\n\n\n\n\n");
          //       },
          //     ).onError(
          //       (error, stackTrace) {
          //         debugPrint(
          //             "\n\n\n\n\n\n While updating the bank accounts list, error: $error\n\n\n\n\n");
          //       },
          //     );
          //   }
          //
          //   // String bankAccountNumberId = bankAccountDocumentSnapshot.get(
          //   //     'bankAccountNumberId').toString();
          //   // newBankAccountNumberId =
          //   // int.tryParse(bankAccountNumberId.substring(9))!;
          //
          //   Utils.showMessage(
          //       'Successfully supplier data and bank account added.');
          //   updateListeners(false);
          // }).onError((error, stackTrace) {
          //   debugPrint(
          //       '\n\n\n\n\n\n\n some thing not worked. errorrrrrr!!!!!!!!!!!!! ERROR : $error}');
          //   Utils.showMessage(error.toString());
          //   updateListeners(false);
          // });
          updateListeners(false);
        } else {
          /// supplier doesn't exist
          await setNewSupplierId();
          await setNewBankId();

          /// Adding a new supplier
          await fireStore
              .collection(uid)
              .doc('SuppliersData')
              .collection('Suppliers')
              .doc('SUP-$newSupplierId')
              .set({
            'supplierId': newSupplierId,
            'supplierName': supplierName,
            'supplierPhoneNo': supplierPhoneNo,
            'supplierEmail': supplierEmail,
            'supplierAddress': supplierAddress,
            'totalAmount': 0,
            'amountRemaining': 0,
            'totalPaidAmount': 0,
          }).then((value) {
            /// Adding a bank account
            fireStore
                .collection(uid)
                .doc('SuppliersData')
                .collection('BankAccounts')
                .doc('SUP-BANK-$newSupplierId')
                .set({
              'supplierId': newSupplierId,
              'bankAccounts': [
                {
                  'bankAccountNumberId': newBankAccountNumberId,
                  'bankAccountNumber': bankAccountNumber,
                  'accountType': accountType
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
      } else {
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
  setNewSupplierId() async {
    newSupplierId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .doc('0LastSupplierId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['lastSupplierId'] == null) {
      // debugPrint(
      //     'Supplier id found to be null --------- ${data?['lastSupplierId']}');
      documentRef.set({'lastSupplierId': newSupplierId});
    } else {
      // debugPrint('Supplier id: ${data?['supplierId']}');
      newSupplierId = data?['lastSupplierId'] + 1;
      documentRef.set({'lastSupplierId': newSupplierId});
    }
  }

  setNewBankId() async {
    newBankAccountNumberId = 1;

    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('SuppliersData')
        .collection('BankAccounts')
        .doc('0LastBankAccountNumberId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();
    if (data?['lastBankAccountNumberId'] == null) {
      // debugPrint(
      //     'BankAccountNoId id found to be null --------- ${data?['lastBankAccountNumberId']}');
      documentRef.set({'lastBankAccountNumberId': newBankAccountNumberId});
    } else {
      // debugPrint('Bank Acc No id: ${data?['bankAccountNumberId']}');
      newBankAccountNumberId = data?['lastBankAccountNumberId'] + 1;
      documentRef.set({'lastBankAccountNumberId': newBankAccountNumberId});
    }
  }
}
