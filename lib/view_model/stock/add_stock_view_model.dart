import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:printing_press/utils/toast_message.dart';

class AddStockViewModel with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  late int newStockId;
  late int newStockOrderedId;
  late int supplierId;
  late int previousStockQuantity;

  get formKey => _formKey;

  TextEditingController stockNameC = TextEditingController();
  TextEditingController stockCategoryC = TextEditingController();
  TextEditingController stockDescriptionC = TextEditingController();
  TextEditingController stockUnitBuyPriceC = TextEditingController();
  TextEditingController stockUnitSellPriceC = TextEditingController();
  TextEditingController stockQuantityC = TextEditingController();
  TextEditingController stockSizeWidthC = TextEditingController();
  TextEditingController stockSizeHeightC = TextEditingController();
  TextEditingController stockColorC = TextEditingController();
  TextEditingController stockManufacturedByC = TextEditingController();
  TextEditingController stockSupplierC = TextEditingController();

  addStockInFirebase() async {
    // two scenarios: 1. already exists 2. Not exists
    if (_formKey.currentState != null) {
      updateListeners(true);

      if (_formKey.currentState!.validate()) {
        /// check if stock is already available
        QuerySnapshot stockQuerySnapshot = await fireStore
            .collection(uid)
            .doc('StockData')
            .collection('AvailableStock')

            /// todo: create a method which will find the supplier id by using supplier name
            /// todo: store the supplierId instead of supplier name
            .where('stockName', isEqualTo: stockNameC.text.trim())
            .where('stockCategory', isEqualTo: stockCategoryC.text.trim())
            .where('stockDescription', isEqualTo: stockDescriptionC.text.trim())
            .where('stockUnitBuyPrice',
                isEqualTo: int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0)
            .where('stockUnitSellPrice',
                isEqualTo: int.tryParse(stockUnitSellPriceC.text.trim()) ??
                    int.tryParse(stockUnitBuyPriceC.text.trim()) ??
                    1)
            .where('stockColor', isEqualTo: stockColorC.text.trim())
            .where('manufacturedBy',
                isEqualTo: stockManufacturedByC.text.trim())
            .where('stockSupplier', isEqualTo: stockSupplierC.text.trim())
            .limit(1)
            .get();

        if (stockQuerySnapshot.docs.isNotEmpty) {
          debugPrint('\n\n\n\n\n\n\n\n\n\nIt means stock exists.'
              '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');

          /// update the Stock
          DocumentSnapshot stockDocumentSnapshot =
              stockQuerySnapshot.docs.first;
          newStockId = stockDocumentSnapshot.get('stockId');
          previousStockQuantity = stockDocumentSnapshot.get('stockQuantity');

          // try {
          DocumentReference stockDocRef = fireStore
              .collection(uid)
              .doc('StockData')
              .collection('AvailableStock')

              /// todo: create a method which will find the supplier id by using supplier name
              .doc('STOCK-$newStockId');

          await stockDocRef.update({
            'stockQuantity': int.tryParse(stockQuantityC.text.trim()) == null
                ? previousStockQuantity
                : int.tryParse(stockQuantityC.text.trim())! +
                    previousStockQuantity,
          }).then((value) async {
            debugPrint('\n\n\n\n\n\n\n\n Supplier data updated !!\n\n\n\n\n\n');
            Utils.showMessage('Supplier data updated !!');
            updateListeners(false);

            /// updating existing bank account data
            /// todo: unnecessary code, remove it
            // DocumentSnapshot documentSnapshot = await fireStore
            //     .collection(uid)
            //     .doc('SuppliersData')
            //     .collection('BankAccounts')
            //     .doc('SUP-BANK-$newSupplierId')
            //     .get();
            //
            // List<BankAccount> bankAccounts = [];
            // List<dynamic> bankAccountNumbersObj =
            //     documentSnapshot.get('bankAccounts');
            //
            // int index = 0;
            // for (var i in bankAccountNumbersObj) {
            //   if (i is Map<String, dynamic>) {
            //     bankAccounts.add(BankAccount.fromJson(i));
            //     debugPrint(
            //         '\n\n\n\n\n Bank account added: ${bankAccounts[index].bankAccountNumber}\n\n\n\n\n\n\n\n');
            //   } else {
            //     debugPrint(
            //         '\n\n\n\n\n IT is not a map of string, dynamic: $i \n\n\n\n\n\n\n\n');
            //   }
            //
            //   index++;
            // }

            // index = 0;
            // int selectedIndex = -1;

            // if (bankAccounts.isNotEmpty) {
            //   for (var i in bankAccounts) {
            //     if (i.bankAccountNumber.toLowerCase() ==
            //         bankAccountNumberC.text.trim().toLowerCase()) {
            //       selectedIndex = index;
            //     }
            //     index++;
            //   }
            // }
            // if (selectedIndex == -1) {
            //   debugPrint(
            //       '\n\n\n\n\n NO SAME ACCOUNT OF BANK FOUND!!! \n\n\n\n\n\n\n\n');
            //   await setNewBankId();
            //   await fireStore
            //       .collection(uid)
            //       .doc('SuppliersData')
            //       .collection('BankAccounts')
            //       .doc('SUP-BANK-$newSupplierId')
            //       .update({
            //     'bankAccounts': FieldValue.arrayUnion([
            //       {
            //         'bankAccountNumberId': newBankAccountNumberId,
            //         'bankAccountNumber': bankAccountNumberC.text.trim(),
            //         'accountType': accountTypeC.text.trim(),
            //       }
            //     ])
            //   });
            // } else {
            //   debugPrint(
            //       '\n\n\n\n\n SAME ACCOUNT OF BANK FOUND... \n\n\n\n\n\n\n\n');
            //   bankAccounts[selectedIndex] = BankAccount(
            //       bankAccountNumberId:
            //           bankAccounts[selectedIndex].bankAccountNumberId,
            //       bankAccountNumber: bankAccountNumberC.text.trim(),
            //       accountType: accountTypeC.text.trim());
            //
            //   fireStore
            //       .collection(uid)
            //       .doc('SuppliersData')
            //       .collection('BankAccounts')
            //       .doc('SUP-BANK-$newSupplierId')
            //       .update({
            //     'bankAccounts': bankAccounts.map((e) => e.toMap()).toList()
            //   }).then(
            //     (value) {
            //       debugPrint(
            //           "\n\n\n\n\n\nSuccessfully Bank accounts undated !!!\n\n\n\n\n");
            //     },
            //   ).onError(
            //     (error, stackTrace) {
            //       debugPrint(
            //           "\n\n\n\n\n\n While updating the bank accounts list, error: $error\n\n\n\n\n");
            //     },
            //   );
            // }

            // String bankAccountNumberId = bankAccountDocumentSnapshot.get(
            //     'bankAccountNumberId').toString();
            // newBankAccountNumberId =
            // int.tryParse(bankAccountNumberId.substring(9))!;

            // Utils.showMessage(
            //     'Successfully supplier data and bank account added.');
          }).onError((error, stackTrace) {
            debugPrint(
                '\n\n\n\n\n\n\n some thing not worked. error!!!!!!!!!!!!! ERROR : $error}');
            Utils.showMessage(error.toString());
            updateListeners(false);
          });
          // } catch (e, s) {
          //   debugPrint(
          //       '\n\n\n\n\n\n\n some thing not worked. errorrrrrr 222222222222!!!!!!!!!!!!!');
          // }
          updateListeners(false);
        } else {
          /// stock doesn't exist
          await setNewStockId();
          await setNewStockOrderedId();

          /// Adding a new supplier
          await fireStore
              .collection(uid)
              .doc('StockData')
              .collection('AvailableStock')
              .doc('STOCK-$newStockId')
              .set({
            'stockId': newStockId,
            'stockName': stockNameC.text.trim(),
            'stockCategory': stockCategoryC.text.trim(),
            'stockDescription': stockDescriptionC.text.trim(),
            'stockUnitBuyPrice':
                int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0,
            'stockUnitSellPrice':
                int.tryParse(stockUnitSellPriceC.text.trim()) ??
                    int.tryParse(stockUnitBuyPriceC.text.trim()) ??
                    1,
            'stockQuantity': int.tryParse(stockQuantityC.text.trim()) ?? 0,
            'stockColor': stockColorC.text.trim(),
            'manufacturedBy': stockManufacturedByC.text.trim(),
            'stockSupplier': stockSupplierC.text.trim(),
          }).then((value) {

            Utils.showMessage('Successfully stock added');
            debugPrint('New stock added!!!!!!!!!!!!!!!!!');
            /// adding a stock ordered
            ///

            updateListeners(false);
          }).onError((error, stackTrace) {
            Utils.showMessage(error.toString());
            updateListeners(false);
          });
        }
      }
    } else {
      updateListeners(false);
    }
  }

  /// when you want to add data of supplier or any bank account, you need to set the supplier id and bank id
  setNewStockId() async {
    newStockId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('StockData')
        .collection('AvailableStock')
        .doc('LastStockId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['stockId'] == null) {
      debugPrint('Stock id found to be null --------- ${data?['stockId']}');
      await documentRef.set({'stockId': newStockId});
    } else {
      debugPrint(
          '\n\n\nStock id is found to be available. \nStock id: ${data?['stockId']}');
      newStockId = data?['stockId'] + 1;
      await documentRef.set({'stockId': newStockId});
    }
  }
  ///todo:
  setNewStockOrderedId() async {
    newStockOrderedId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(uid)
        .doc('StockData')
        .collection('StockOrdered')
        .doc('LastStockOrderedId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastStockOrderedId'] == null) {
      debugPrint('Stock ordered id found to be null --------- ${data?['LastStockOrderedId']}');
      await documentRef.set({'LastStockOrderedId': newStockOrderedId});
    } else {
      debugPrint(
          '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastStockOrderedId']}');
      newStockOrderedId = data?['LastStockOrderedId'] + 1;
      await documentRef.set({'LastStockOrderedId': newStockOrderedId});
    }
  }

  updateListeners(bool val) {
    loading = val;
    notifyListeners();
  }
}
