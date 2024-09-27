import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase_services/firebase_firestore_services.dart';
import '../../model/rate_list.dart';

class PlaceOrderViewModel with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get formKey => _formKey;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  get formKey2 => _formKey2;

  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  late final RateList rateList;

  Map<String, dynamic>? data;

  bool _customOrderDataFetched = false;

  get customOrderDataFetched => _customOrderDataFetched;

  late bool _inStockOrderDataFetched;

  get inStockOrderDataFetched => _inStockOrderDataFetched;

  // all stock
  List<String> allStockList = [];
  late String selectedStock;
  late int selectedStockIndex;
  TextEditingController stockQuantityC = TextEditingController();

  // new stock order id
  late int newStockOrderedId;

  // stock id
  late int stockId;

  TextEditingController stockIdC = TextEditingController();

  // design
  List<String> designNames = [];
  late String selectedDesign;
  late int selectedDesignIndex;

  // paper
  List<int> selectedPaperSizeIndexes = [];

  // paper size
  List<String> paperSizes = [];
  late String selectedPaperSize;

  // paper quality
  List<String> selectedPaperSizePaperQualities = [];
  late String selectedPaperQuality;

  // books quantity
  TextEditingController booksQuantityC = TextEditingController();

  // paper cutting
  List<String> paperCuttingNames = [];
  late String selectedPaperCutting;
  late int selectedPaperCuttingIndex;

  // basic paper cutting units
  List<int> basicCuttingUnits = [2, 3, 4, 6, 8, 12, 16, 32, 64, 128];
  List<String> basicCuttingUnitsList = [];
  late String selectedBasicCuttingUnit;
  int selectedBasicCuttingUnitIndex = 0;

  // single, dup, trip, news - copy variants
  List<String> copyVariant = [];
  late String selectedCopyVariant;
  late int selectedCopyVariantIndex;

  // print type
  List<String> printNames = ['1C', '2C', '3C', '4C'];
  String selectedPrint = '1C';

  // copy printing
  List<String> copyPrint = ['none', 'printed'];
  String selectedCopyPrint = 'none';
  int selectedCopyPrintIndex = 0;
  late final void Function(String? s)? copyVariantOnChange;

  // News paper
  List<int> selectedNewsPaperSizeIndexes = [];

  // News paper size
  List<String> newsPaperSizes = [];
  late String selectedNewsPaperSize;

  // News paper quality
  List<String> selectedNewsPaperSizePaperQualities = [];
  late String selectedNewsPaperQuality;

  //////////////////////////////////////////////////////////

  // binding
  List<String> bindingNames = [];
  late String selectedBinding;
  late int selectedBindingIndex;

  // Numbering
  List<String> numberingNames = [];
  late String selectedNumbering;
  late int selectedNumberingIndex;

  // back side printing
  List<String> backSide = ['yes', 'no'];
  late String selectedBackSide;

  // other expenses
  TextEditingController otherExpensesC = TextEditingController();

  /// paper + extra sheet
  // binding yes or no -- binding rate * paper quantity / 1000 ?? maybe...
  // Printing 1c, 2c, 3c, 4c
  // numbering yes or no -- numbering rate * paper quantity / 1000 correct if per thousand rate
  // cutting 1/2, 1/4...
  // b/s ...
  // other expenses
  /// machine selection based on paper size, if there could be two plates on it, check for that too
  /// for ex, if a machine size is a4, and your design is a4/2, then you can divide the paper quantity by 2
  /// if you have 1000 papers to be printed, you will divide it by 2, hence only 500 prints are there
  /// now if for each 500 prints, the machine has its rate of 300
  /// you will divide the paper quantity by 500, hence 1 is the output, that will be multiplied by 300 (the rate of the machine)
  /// profit
  // carriage to hangu
  // result = paper quantity depends on cutting + carriage +

  getAllStock() async {
    allStockList= [];
    _inStockOrderDataFetched = false;
    debugPrint('Get all stock called!');
    allStockList.add('None');
    selectedStockIndex = 0;
    selectedStock = allStockList[0];
    var querySnapshot = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('StockData')
        .collection('AvailableStock')
        .get();
    var docs = querySnapshot.docs;
    if (docs.length >= 2) {
      for (int index = 1; index < docs.length; index++) {
        allStockList.add(docs[index].get('stockName'));
      }
    }
    _inStockOrderDataFetched = true;
    updateListener();
  }

  // addCustomerStockOrder()async  {
  //   if(_formKey.currentState != null){
  //     if(_formKey.currentState!.validate()){
  //       {
  //         setNewStockOrderedId();
  //         stockId = int.tryParse(stockIdC.text.trim()) ?? 1;
  //
  //         ///todo: get the details of the stock using the stock id or stock name
  //
  //         /// Adding the history of the stock
  //         await firestore
  //             .collection(auth.currentUser!.uid)
  //             .doc('StockData')
  //             .collection('StockOrdered')
  //             .doc('CUS-ORDER-$newStockOrderedId')
  //             .set({
  //           'stockOrderId': newStockOrderedId,
  //           'stockId': stockId,
  //           'stockName': stockNameC.text.trim(),
  //           'stockCategory': stockCategoryC.text.trim(),
  //           'stockUnitBuyPrice':
  //           int.tryParse(stockUnitBuyPriceC.text.trim()) ?? 0,
  //           'stockQuantity': int.tryParse(stockQuantityC.text.trim()) ?? 0,
  //           'totalAmount': newTotalAmount,
  //           'customerOrderId': int.tryParse(supplierIdC.text.trim()),
  //           'stockDateAdded': Timestamp.now(),
  //         });
  //
  //         /// update the supplier total amount
  //         supplierId = int.tryParse(supplierIdC.text.trim())!;
  //
  //         debugPrint(
  //             '\n\n\n\n\nSupplier id while updating the total amount: $supplierId \n\n\n\n\n');
  //         DocumentReference supplierRef = fireStore
  //             .collection(uid)
  //             .doc('SuppliersData')
  //             .collection('Suppliers')
  //
  //         /// todo: create a method which will find the supplier id by using supplier name
  //             .doc('SUP-$supplierId');
  //
  //         DocumentSnapshot supplierDocSnapshot = await supplierRef.get();
  //
  //         supplierPreviousTotalAmount =
  //             supplierDocSnapshot.get('totalAmount');
  //
  //         debugPrint(
  //             '\n\n\n\n\nSupplier previous total amount: $supplierPreviousTotalAmount \n\n\n\n\n');
  //         debugPrint(
  //             '\n\n\n\n\nSupplier new total amount: $newTotalAmount \n\n\n\n\n');
  //
  //         supplierRef.update({
  //           'totalAmount': supplierPreviousTotalAmount + newTotalAmount,
  //         });
  //
  //         Utils.showMessage('Successfully user stock order Added');
  //         debugPrint('New stock added!!!!!!!!!!!!!!!!!');
  //
  //         updateListener();
  //       }
  //     } else {
  //       updateListener();
  //     }
  //   } else {
  //     updateListener();
  //   }
  // }

  checkData() {
    getFirestoreData();
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (data != null) {
        debugPrint('data is not null anymore...');
        setFirebaseDataLocally();
        _customOrderDataFetched = true;
        timer.cancel();
        updateListener();
      } else {
        debugPrint('data is null');
        updateListener();
      }
    });
  }

  updateListener() {
    notifyListeners();
  }

  getFirestoreData() async {
    FirebaseFirestoreServices firestore = FirebaseFirestoreServices(auth: auth);
    data = await firestore.fetchData();
    rateList = RateList.fromJson(data!);
  }

  setFirebaseDataLocally() {
    setDesignData();
    setPaperSizeData();
    setPaperQualityData();
    setPaperCuttingData();
    setBasicCuttingUnit();
    setCopyVariants();
    setBindingData();
    setNewsPaperSizeData();
    setNewsPaperQualityData();
    setNumberingData();
    setBackSide();
  }

  setDesignData() {
    designNames.add('none');
    // design
    for (var design in rateList.designs) {
      designNames.add(design.name);
    }
    selectedDesign = designNames[0];
    selectedDesignIndex = 0;
    debugPrint("Design names: $designNames");
    if (selectedDesign == 'none') {
      debugPrint("No design");
    } else {
      debugPrint(
          'Design Rate: ${rateList.designs[selectedDesignIndex - 1].rate}');
    }
  }

  setPaperSizeData() {
    paperSizes.add('none');
    // paper size
    for (var paper in rateList.paper) {
      /// TODO: if this or opposite to this
      /// TODO: make changes to all in this file or anywhere else
      if (!paperSizes.contains('${paper.size.width} x ${paper.size.height}') &&
          !paperSizes.contains('${paper.size.height} x ${paper.size.width}')) {
        paperSizes.add('${paper.size.width} x ${paper.size.height}');
      }
    }
    debugPrint('Paper Sizes : $paperSizes}');
    selectedPaperSize = paperSizes[0];
  }

  setPaperQualityData() {
    /// todo: change the list when select any other. use set state or do it through providers
    int index = 0;
    if (selectedPaperSize == 'none') {
      selectedPaperSizePaperQualities.add('none');
    } else {
      for (var paper in rateList.paper) {
        debugPrint('\nselected Paper size : $selectedPaperSize');
        debugPrint(
            'checking the paper size in firebase: ${paper.size.width} x ${paper.size.height}');

        if (selectedPaperSize == '${paper.size.width} x ${paper.size.height}' ||
            selectedPaperSize == '${paper.size.height} x ${paper.size.width}') {
          selectedPaperSizePaperQualities.add('${paper.quality}');
          selectedPaperSizeIndexes.add(index);
        }
        debugPrint('paper quality added, index no: $index');
        index++;
      }
    }

    debugPrint(selectedPaperSizePaperQualities.toString());
    selectedPaperQuality = selectedPaperSizePaperQualities[0];

    // selected paper quality index ? selectedPaperSizeIndexes[paperQualities.indexOf(selectedPaperQuality)]

    // rate of the selected paper size, selected paper quality
    if (selectedPaperSize != 'none') {
      int rate = rateList
          .paper[selectedPaperSizeIndexes[
              selectedPaperSizePaperQualities.indexOf(selectedPaperQuality)]]
          .rate;
      debugPrint('Rate of the selected paper quality is : $rate');
    } else {
      debugPrint('No paper size selected.');
    }
  }

  setPaperCuttingData() {
    paperCuttingNames.add('none');
    for (var paperCutting in rateList.paperCutting) {
      paperCuttingNames.add(paperCutting.name);
    }
    selectedPaperCutting = paperCuttingNames[0];
    selectedPaperCuttingIndex = 0;
    debugPrint("Paper Cutting name: $paperCuttingNames");
  }

  setBasicCuttingUnit() {
    basicCuttingUnitsList.add('none');
    for (String a
        in basicCuttingUnits.map((e) => "1/${e.toString()}").toList()) {
      basicCuttingUnitsList.add(a);
    }

    debugPrint('List of basic cutting unit : $basicCuttingUnitsList');
    selectedBasicCuttingUnit = basicCuttingUnitsList[0];
  }

  setCopyVariants() {
    copyVariant = ['news', 'none', 'dup', 'trip'];
    selectedCopyVariant = 'none';
    selectedCopyVariantIndex = 1;
    setCopyVariantOnChange();
  }

  setCopyVariantOnChange() {
    copyVariantOnChange = (String? newVal) {
      selectedCopyVariant = newVal!;
      selectedCopyVariantIndex = copyVariant.indexOf(selectedCopyVariant);
      updateListener();
    };
  }

  setNewsPaperSizeData() {
    newsPaperSizes.add('none');
    // paper size
    for (var news in rateList.news) {
      /// TODO: if this or opposite to this
      /// TODO: make changes to all in this file or anywhere else
      if (!newsPaperSizes
              .contains('${news.size.width} x ${news.size.height}') &&
          !newsPaperSizes
              .contains('${news.size.height} x ${news.size.width}')) {
        newsPaperSizes.add('${news.size.width} x ${news.size.height}');
      }
    }
    debugPrint('News Paper Sizes : $newsPaperSizes}');
    selectedNewsPaperSize = newsPaperSizes[0];
  }

  setNewsPaperQualityData() {
    /// todo: change the list when select any other. use set state or do it through providers

    if (selectedNewsPaperSize == 'none') {
      selectedNewsPaperSizePaperQualities.add('none');
    }

    ///todo: remove the else block because data in the initial stage is always none
    else {
      int index = 0;
      for (var news in rateList.news) {
        debugPrint('\nselected news Paper size : $selectedNewsPaperSize');
        debugPrint(
            'checking the news paper size in firebase: ${news.size.width} x ${news.size.height}');

        if (selectedNewsPaperSize ==
                '${news.size.width} x ${news.size.height}' ||
            selectedNewsPaperSize ==
                '${news.size.height} x ${news.size.width}') {
          selectedNewsPaperSizePaperQualities.add('${news.quality}');
          selectedNewsPaperSizeIndexes.add(index);
        }
        debugPrint('News paper quality added, index no: $index');
        index++;
      }
    }

    debugPrint(selectedNewsPaperSizePaperQualities.toString());
    selectedNewsPaperQuality = selectedNewsPaperSizePaperQualities[0];

    // selected news paper quality index ? selectedNewsPaperSizeIndexes[newsPaperQualities.indexOf(selectedNewsPaperQuality)]

    // rate of the selected news paper size, selected paper quality
    if (selectedNewsPaperSize != 'none') {
      int rate = rateList
          .news[selectedNewsPaperSizeIndexes[selectedNewsPaperSizePaperQualities
              .indexOf(selectedNewsPaperQuality)]]
          .rate;
      debugPrint('Rate of the selected paper quality is : $rate');
    } else {
      debugPrint('No paper size selected.');
    }
  }

  setBindingData() {
    bindingNames.add('none');
    for (var binding in rateList.binding) {
      bindingNames.add(binding.name);
    }
    selectedBinding = bindingNames[0];
    selectedBindingIndex = 0;
    debugPrint(
        "Binding names and index: $selectedBinding $selectedBindingIndex");
    debugPrint(
        "Rate of binding: ${rateList.binding[selectedBindingIndex].rate}");
    if (selectedBinding == 'none') {
      debugPrint("No binding");
    } else {
      debugPrint(
          'Binding Rate: ${rateList.binding[selectedBindingIndex - 1].rate}');
    }
  }

  setNumberingData() {
    numberingNames.add('none');
    for (var numbering in rateList.numbering) {
      numberingNames.add(numbering.name);
    }
    selectedNumbering = numberingNames[0];
    selectedNumberingIndex = 0;
    debugPrint(
        "Numbering names and index: $selectedNumbering $selectedNumberingIndex");
    debugPrint(
        "Rate of numbering: ${rateList.numbering[selectedNumberingIndex].rate}");
    if (selectedNumbering == 'none') {
      debugPrint("No numbering");
    } else {
      debugPrint(
          'Numbering Rate: ${rateList.numbering[selectedNumberingIndex - 1].rate}');
    }
  }

  setPrintData() {
    // design
    selectedPrint = printNames[0];
    debugPrint("Design names: $printNames");
  }

  setBackSide() {
    selectedBackSide = 'no';
  }

  setNewStockOrderedId() async {
    newStockOrderedId = 1;
    final documentRef = FirebaseFirestore.instance
        .collection(auth.currentUser!.uid)
        .doc('StockData')
        .collection('StockOrdered')
        .doc('LastStockOrderedId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastStockOrderedId'] == null) {
      debugPrint(
          'Stock ordered id found to be null --------- ${data?['LastStockOrderedId']}');
      await documentRef.set({'LastStockOrderedId': newStockOrderedId});
    } else {
      debugPrint(
          '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastStockOrderedId']}');
      newStockOrderedId = data?['LastStockOrderedId'] + 1;
      await documentRef.set({'LastStockOrderedId': newStockOrderedId});
    }
  }

// Function to find the closest factors of a number
  List<int> closestFactors(int n) {
    int minDiff = double.infinity.toInt(); // Initialize minimum difference
    List<int> closestPair = [1, n]; // Default closest pair

    // Iterate over possible factors from 1 up to the square root of n
    for (int i = 1; i <= (sqrt(n)).toInt(); i++) {
      if (n % i == 0) {
        // Check if i is a factor of n
        int j = n ~/ i; // The corresponding pair factor
        int diff = (i - j).abs(); // Calculate the difference
        // Update the closest pair if the current difference is smaller
        if (diff < minDiff) {
          minDiff = diff;
          closestPair = [i, j];
        }
      }
    }

    return closestPair;
  }
}
