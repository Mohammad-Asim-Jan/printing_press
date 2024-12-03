import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/model/bank_account.dart';
import 'package:printing_press/utils/toast_message.dart';

class PaymentToSupplierViewModel with ChangeNotifier {
  late int newStockOrderId;
  late int newCashbookEntryId;
  final _formKey = GlobalKey<FormState>();

  late List<String> listOfSupplierAccounts = ['Cash'];
  late String selectedBankAcc = 'Cash';

  get formKey => _formKey;
  bool _loading = false;

  get loading => _loading;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;
  TextEditingController amountC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();

  late int supplierPreviousRemainingAmount;

  late int supplierPreviousAmountPaid;

  getSupplierPreviousRemainingAmount(int supplierId) async {
    DocumentReference supplierRef = firestore
        .collection(uid)
        .doc('SuppliersData')
        .collection('Suppliers')
        .doc('SUP-$supplierId');

    DocumentSnapshot supplierDocSnapshot = await supplierRef.get();

    supplierPreviousRemainingAmount =
        supplierDocSnapshot.get('amountRemaining');

    amountC.text = supplierPreviousRemainingAmount.toString();
  }

  addPaymentInFirestore(int supplierId) async {
      updateListener(true);
    if (_formKey.currentState != null) {
      debugPrint('Form key is not null\n');
      if (_formKey.currentState!.validate()) {
        int amount = int.tryParse(amountC.text.trim())!;
        String description = descriptionC.text.trim();
        debugPrint('Form key is valid\n');
        Timestamp timeStamp = Timestamp.now();
        await setNewStockOrderHistoryId();

        await setNewCashbookEntryId();
        await firestore
            .collection(uid)
            .doc('StockData')
            .collection('StockOrderHistory')
            .doc('$newStockOrderId')
            .set({
          'stockOrderId': newStockOrderId,
          'cashbookEntryId': newCashbookEntryId,
          'supplierId': supplierId,
          'amount': amount,
          'description': description,
          'paymentType': 'CASH-OUT',
          'paymentMethod': selectedBankAcc,
          'paymentDateTime': timeStamp,
        }).then((value) async {

          Utils.showMessage('Supplier payment added !');
          /// adding the payment history to cashbook
          await firestore
              .collection(uid)
              .doc('CashbookData')
              .collection('CashbookEntry')
              .doc('$newCashbookEntryId')
              .set({
            'stockOrderId': newStockOrderId,
            'cashbookEntryId': newCashbookEntryId,
            'supplierId': supplierId,
            'amount': amount,
            'description': description,
            'paymentType': 'CASH-OUT',
            'paymentMethod': selectedBankAcc,
            'paymentDateTime': timeStamp,
          }).then(
            (value) async {
              Utils.showMessage('Cashbook Entry added!');
              debugPrint('\n\n\nCashbook Entry added!\n\n\n');

              /// update the supplier remaining amount and total amount paid
              DocumentReference supplierRef = firestore
                  .collection(uid)
                  .doc('SuppliersData')
                  .collection('Suppliers')
                  .doc('SUP-$supplierId');
              //
              // DocumentSnapshot supplierDocSnapshot = await supplierRef.get();
              //
              // supplierPreviousRemainingAmount =
              //     supplierDocSnapshot.get('amountRemaining');
              // supplierPreviousAmountPaid =
              //     supplierDocSnapshot.get('totalPaidAmount');

              supplierRef.update({
                'totalPaidAmount': supplierPreviousAmountPaid + amount,
                'amountRemaining': supplierPreviousRemainingAmount - amount
              }).then(
                (value) {
                  supplierPreviousAmountPaid += amount;
                  supplierPreviousRemainingAmount -= amount;
                  Utils.showMessage('Supplier rem and paid amount updated!');
                  updateListener(false);
                },
              ).onError(
                (error, stackTrace) {
                  debugPrint(error.toString());
                  Utils.showMessage('Sup rem and paid amount error: $error');
                  updateListener(false);
                },
              );
            },
          ).onError(
            (error, stackTrace) {
              debugPrint(error.toString());
              Utils.showMessage('Cashbook entry Error:$error');
              debugPrint('\n\n\nCashbook Entry error!\n\n\n');
              updateListener(false);
            },
          );
          updateListener(false);
        }).onError(
          (error, stackTrace) {
            debugPrint(
                'Error occurred while adding supplier payment history : $error');
            Utils.showMessage('Error Occurred: $error');
            updateListener(false);
          },
        );
      } else {
        Utils.showMessage('Form key is not valid!\n');
        updateListener(false);
      }
    } else {
      debugPrint('Form key is null \n');
      Utils.showMessage('Current state is null');
      updateListener(false);
    }
  }

  setNewStockOrderHistoryId() async {
    newStockOrderId = 1;
    final documentRef = firestore
        .collection(uid)
        .doc('StockData')
        .collection('StockOrderHistory')
        .doc('0LastStockOrderId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastStockOrderId'] == null) {
      // debugPrint(
      //     'Stock ordered id found to be null --------- ${data?['LastStockOrderId']}');
      await documentRef.set({'LastStockOrderId': newStockOrderId});
    } else {
      // debugPrint(
      //     '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastStockOrderId']}');
      newStockOrderId = data?['LastStockOrderId'] + 1;
      await documentRef.set({'LastStockOrderId': newStockOrderId});
    }
  }

  setNewCashbookEntryId() async {
    newCashbookEntryId = 1;
    final documentRef = firestore
        .collection(uid)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .doc('0LastCashbookEntryId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastCashbookEntryId'] == null) {
      // debugPrint(
      //     'Cashbook entry id found to be null --------- ${data?['LastCashbookEntryId']}');
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    } else {
      // debugPrint(
      //     '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastCashbookEntryId']}');
      newCashbookEntryId = data?['LastCashbookEntryId'] + 1;
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    }
  }

  getSupplierBankAccountNames(int supplierId) async {
    listOfSupplierAccounts = ['Cash'];
    await firestore
        .collection(uid)
        .doc('SuppliersData')
        .collection('BankAccounts')
        .doc('SUP-BANK-$supplierId')
        .get()
        .then(
      (value) {
        List data = value.get('bankAccounts');
        List<BankAccount> supplierAccounts = data.map((e) {
          return BankAccount.fromJson(e);
        }).toList();
        for (BankAccount e in supplierAccounts) {
          listOfSupplierAccounts.add(e.accountType);
        }
        notifyListeners();
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage(error.toString());
      },
    );
  }

  updateListener(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
