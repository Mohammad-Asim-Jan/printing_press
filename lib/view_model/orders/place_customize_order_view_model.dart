import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/customer_custom_order.dart';
import 'package:printing_press/model/rate_list/binding.dart';
import 'package:printing_press/model/rate_list/design.dart';
import 'package:printing_press/model/rate_list/machine.dart';
import 'package:printing_press/model/rate_list/numbering.dart';
import 'package:printing_press/model/rate_list/paper.dart';
import 'package:printing_press/model/rate_list/paper_cutting.dart';
import 'package:printing_press/model/rate_list/profit.dart';
import 'package:printing_press/utils/toast_message.dart';

class PlaceCustomizeOrderViewModel with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController customerAddressC = TextEditingController();
  TextEditingController customerContactC = TextEditingController();
  TextEditingController businessTitleC = TextEditingController();
  TextEditingController customerNameC = TextEditingController();

  Map<String, dynamic>? data;

  bool _customOrderDataFetched = false;

  get customOrderDataFetched => _customOrderDataFetched;
  bool _dataFound = false;

  get dataFound => _dataFound;

  bool _loading = false;

  get loading => _loading;

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
  TextEditingController booksQuantityC = TextEditingController(text: '10');

  // pages per book
  TextEditingController pagesPerBookC = TextEditingController(text: '100');

  // paper cutting
  List<String> paperCuttingNames = [];
  late String selectedPaperCutting;
  late int selectedPaperCuttingIndex;

  // basic paper cutting units
  List<int> basicCuttingUnits = [1, 2, 3, 4, 6, 8, 12, 16, 32, 64, 128];
  List<String> basicCuttingUnitsList = [];
  late String selectedBasicCuttingUnit;
  int selectedBasicCuttingUnitIndex = 0;

  // single, dup, trip, news - copy variants
  List<String> copyVariantNames = [];
  late String selectedCopyVariant;
  late int selectedCopyVariantIndex;

  // variant paper quality
  late String selectedCopyVariantPaperQuality;

  // print type
  List<String> printNames = ['1C', '2C', '3C', '4C'];
  String selectedPrint = '1C';
  String selectedVariantPrint = '1C';

  // variant type
  List<String> carbonLessVariantTypeNames = ['dup', 'trip', 'quad'];
  String selectedCarbonLessVariantType = 'dup';
  int noOfSelectedCarbonLessVariant = 2;

  // copy printing
  // List<String> copyPrint = ['none', 'printed'];
  // String selectedCopyPrint = 'none';
  // int selectedCopyPrintIndex = 0;
  // late final void Function(String? s)? copyVariantOnChange;

  // News paper
  List<int> selectedNewsPaperSizeIndexes = [];

  // News paper size
  List<String> newsPaperSizes = [];
  late String selectedNewsPaperSize;

  // News paper quality
  List<String> selectedNewsPaperSizePaperQualities = [];
  late String selectedNewsPaperQuality;

  // binding
  List<String> bindingNames = [];
  late String selectedBinding;
  late int selectedBindingIndex;

  // Numbering
  List<String> numberingNames = [];
  late String selectedNumbering;
  late int selectedNumberingIndex;

  // Profits
  List<String> profitNames = [];
  late String selectedProfit;
  late int selectedProfitIndex;

  // back side printing
  List<String> backSidePrintingList = [
    'none',
    'lot-pot',
    '1C',
    '2C',
    '3C',
    '4C'
  ];
  late String selectedBackSide;

  // other expenses
  TextEditingController otherExpensesC = TextEditingController();

  // advance payment
  TextEditingController advancePaymentC = TextEditingController();

  // Quantity
  TextEditingController quantityC = TextEditingController();

  List<Binding> bindings = [];
  List<Design> designs = [];
  List<Machine> machines = [];
  List<Paper> newsPapers = [];
  List<Numbering> numberings = [];
  List<Paper> papers = [];
  List<PaperCutting> paperCuttings = [];
  List<Profit> profits = [];

  checkData() async {
    List<List<dynamic>> lists = [];
    lists = [
      bindings,
      designs,
      machines,
      newsPapers,
      numberings,
      papers,
      paperCuttings,
      profits
    ];
    if (lists.any((element) => element.isEmpty)) {
      await fetchData();
      if (lists.every((element) => element.isNotEmpty) &&
          _customOrderDataFetched) {
        debugPrint('data is not null anymore...');

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
        setProfitData();
        setBackSide();

        _dataFound = true;
        updateListener();
      } else {
        debugPrint('some data is null');
        updateListener();
      }
    }
  }

  fetchData() async {
    List<String> subCollectionNames = [
      'Binding',
      'Design',
      'Machine',
      'NewsPaper',
      'Numbering',
      'Paper',
      'PaperCutting',
      'Profit',
    ];

    DocumentReference docRef =
        firestore.collection(auth.currentUser!.uid).doc('RateList');

    try {
      /// it is used for separate collection
      for (String subCollectionName in subCollectionNames) {
        CollectionReference<Map<String, dynamic>> subCollectionRef =
            docRef.collection(subCollectionName);

        // Fetch documents in the sub-collection
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await subCollectionRef.get();

        if (querySnapshot.size > 1) {
          /// it is used for separate document in a collection
          for (int index = 1; index < querySnapshot.docs.length; index++) {
            Map<String, dynamic> data = querySnapshot.docs[index].data();

            switch (subCollectionName) {
              case 'Binding':
                bindings.add(Binding.fromJson(data));
                break;
              case 'Design':
                designs.add(Design.fromJson(data));
                break;
              case 'Machine':
                machines.add(Machine.fromJson(data));
                break;
              case 'NewsPaper':
                newsPapers.add(Paper.fromJson(data));
                break;
              case 'Numbering':
                numberings.add(Numbering.fromJson(data));
                break;
              case 'Paper':
                papers.add(Paper.fromJson(data));
                break;
              case 'PaperCutting':
                paperCuttings.add(PaperCutting.fromJson(data));
                break;
              case 'Profit':
                profits.add(Profit.fromJson(data));
                break;
            }
          }
        }
      }
      _customOrderDataFetched = true;
    } catch (e) {
      Utils.showMessage('Error: $e');
      _customOrderDataFetched = true;
    }
  }

  setDesignData() {
    designNames = [];
    designNames.add('none');
    // design
    for (var design in designs) {
      designNames.add(design.name);
    }
    selectedDesign = designNames[0];
    selectedDesignIndex = 0;
  }

  setPaperSizeData() {
    paperSizes = [];
    // paperSizes.add('none');
    // paper size
    for (var paper in papers) {
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
    selectedPaperSizePaperQualities = [];
    selectedPaperSizeIndexes = [];
    // if (selectedPaperSize == 'none') {
    //   selectedPaperSizePaperQualities.add('none');
    // } else {
    for (var paper in papers) {
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
    // }

    debugPrint(selectedPaperSizePaperQualities.toString());
    selectedPaperQuality = selectedPaperSizePaperQualities[0];
    selectedCopyVariantPaperQuality = selectedPaperSizePaperQualities[0];

    // selected paper quality index ? selectedPaperSizeIndexes[paperQualities.indexOf(selectedPaperQuality)]

    // rate of the selected paper size, selected paper quality
    if (selectedPaperSize != 'none') {
      int rate = papers[selectedPaperSizeIndexes[
              selectedPaperSizePaperQualities.indexOf(selectedPaperQuality)]]
          .rate;
      debugPrint('Rate of the selected paper quality is : $rate');
    }
  }

  setPaperCuttingData() {
    paperCuttingNames = [];
    paperCuttingNames.add('none');
    for (var paperCutting in paperCuttings) {
      paperCuttingNames.add(paperCutting.name);
    }
    selectedPaperCutting = paperCuttingNames[0];
    selectedPaperCuttingIndex = 0;
    debugPrint("Paper Cutting name: $paperCuttingNames");
  }

  setBasicCuttingUnit() {
    basicCuttingUnitsList = [];
    // basicCuttingUnitsList.add('none');
    for (String a
        in basicCuttingUnits.map((e) => "1/${e.toString()}").toList()) {
      basicCuttingUnitsList.add(a);
    }

    debugPrint('List of basic cutting unit : $basicCuttingUnitsList');
    selectedBasicCuttingUnit = basicCuttingUnitsList[0];
  }

  setCopyVariants() {
    copyVariantNames = ['news', 'none', 'carbon', 'carbon-less'];
    selectedCopyVariant = 'none';
    selectedCopyVariantIndex = 1;
    // setCopyVariantOnChange();
  }

  // setCopyVariantOnChange() {
  //   copyVariantOnChange = (String? newVal) {
  //     selectedCopyVariant = newVal!;
  //     selectedCopyVariantIndex = copyVariantNames.indexOf(selectedCopyVariant);
  //     updateListener();
  //   };
  // }

  setNewsPaperSizeData() {
    newsPaperSizes = [];
    // newsPaperSizes.add('none');
    // paper size
    for (var news in newsPapers) {
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

    selectedNewsPaperSizePaperQualities = [];
    // if (selectedNewsPaperSize == 'none') {
    //   selectedNewsPaperSizePaperQualities.add('none');
    // }
    //
    // ///todo: remove the else block because data in the initial stage is always none
    // else {
    int index = 0;
    for (var news in newsPapers) {
      debugPrint('\nselected news Paper size : $selectedNewsPaperSize');
      debugPrint(
          'checking the news paper size in firebase: ${news.size.width} x ${news.size.height}');

      if (selectedNewsPaperSize == '${news.size.width} x ${news.size.height}' ||
          selectedNewsPaperSize == '${news.size.height} x ${news.size.width}') {
        selectedNewsPaperSizePaperQualities.add('${news.quality}');
        selectedNewsPaperSizeIndexes.add(index);
      }
      debugPrint('News paper quality added, index no: $index');
      index++;
    }
    // }

    debugPrint(selectedNewsPaperSizePaperQualities.toString());
    selectedNewsPaperQuality = selectedNewsPaperSizePaperQualities[0];

    // selected news paper quality index ? selectedNewsPaperSizeIndexes[newsPaperQualities.indexOf(selectedNewsPaperQuality)]

    // rate of the selected news paper size, selected paper quality
    // if (selectedNewsPaperSize != 'none') {
    int rate = newsPapers[selectedNewsPaperSizeIndexes[
            selectedNewsPaperSizePaperQualities
                .indexOf(selectedNewsPaperQuality)]]
        .rate;
    debugPrint('Rate of the selected paper quality is : $rate');
    // } else {
    //   debugPrint('No paper size selected.');
    // }
  }

  setBindingData() {
    bindingNames = [];
    bindingNames.add('none');
    for (var binding in bindings) {
      bindingNames.add(binding.name);
    }
    selectedBinding = bindingNames[0];
    selectedBindingIndex = 0;
    debugPrint(
        "Binding names and index: $selectedBinding $selectedBindingIndex");
    if (selectedBinding == 'none') {
      debugPrint("No binding");
    } else {
      debugPrint('Binding Rate: ${bindings[selectedBindingIndex - 1].rate}');
    }
  }

  setNumberingData() {
    numberingNames = [];
    numberingNames.add('none');
    for (var numbering in numberings) {
      numberingNames.add(numbering.name);
    }
    selectedNumbering = numberingNames[0];
    selectedNumberingIndex = 0;
    debugPrint(
        "Numbering names and index: $selectedNumbering $selectedNumberingIndex");
    if (selectedNumbering == 'none') {
      debugPrint("No numbering");
    } else {
      debugPrint(
          'Numbering Rate: ${numberings[selectedNumberingIndex - 1].rate}');
    }
  }

  setProfitData() {
    profitNames = [];
    for (var profit in profits) {
      profitNames.add(profit.name);
    }
    selectedProfit = profitNames[0];
    selectedProfitIndex = 0;
  }

  setPrintData() {
    // print
    selectedPrint = printNames[0];
    debugPrint("Print names: $printNames");
  }

  setBackSide() {
    selectedBackSide = 'none';
  }

  updateListener() {
    notifyListeners();
  }

  late double newHeight;
  late double newWidth;

  List<int> closestFactors(int n) {
    int minDiff = double.maxFinite.toInt();
    List<int> closestPair = [1, n];

    for (int i = 1; i <= sqrt(n).toInt(); i++) {
      if (n % i == 0) {
        int j = n ~/ i;
        int diff = (i - j).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestPair = [i, j];
        }
      }
    }

    return closestPair;
  }

  int calculateFit(int machineWidth, int machineHeight, double paperWidth,
      double paperHeight) {
    int fitWidth = (machineWidth / paperWidth).floor();
    int fitHeight = (machineHeight / paperHeight).floor();
    return fitWidth * fitHeight;
  }

  calculateMachineSize(int n, int basicWidth, int basicHeight) {
    // Example values
    // int n = 6; // Given number for closest factors

    // paper size
    // int basicWidth = 23;
    // int basicHeight = 36;

    // find the closest factor
    List<int> factors = closestFactors(n);

    // sort it so that higher dimension of the page can be divided by highest factor and vice versa
    factors.sort((a, b) => b.compareTo(a));
    debugPrint('Factors are: $factors');

    // Actual paper size
    newWidth = basicHeight / factors[0]; // Big factor
    newHeight = basicWidth / factors[1]; // Small factor
    debugPrint(
        'Paper Size: ${(newWidth * 100).round() / 100} x ${(newHeight * 100).round() / 100}');
    // how many pages can be fit to each machine
    fits = [];

    for (var machine in machines) {
      int machineWidth = machine.size.width;
      int machineHeight = machine.size.height;

      int normalFit =
          calculateFit(machineWidth, machineHeight, newWidth, newHeight);
      int rotatedFit =
          calculateFit(machineWidth, machineHeight, newHeight, newWidth);
      // debugPrint(
      //     'Machine ${machineWidth}x$machineHeight: Normal Fit = $normalFit, Rotated Fit = $rotatedFit');
      if (normalFit != 0 || rotatedFit != 0) {
        fits.add(normalFit > rotatedFit ? normalFit : rotatedFit);
      } else {
        fits.add(null);
      }
    }
  }

  late String uid;
  late List<int?> fits;

  late int designRate;
  late int noOfPlates;
  late int noOfFrontPrintings;
  late int noOfBackPrintings;
  late int noOfCopyVariantPrintings;
  late int frontPrintType;

  late int paperSizePaperQualityRate;
  late int copyPaperSizePaperQualityRate;
  late int newPaperSizePaperQualityRate;
  late int paperCuttingRate;
  late int cuttingUnit;
  late int noOfFrontPages;
  late int noOfFrontExtraPages;
  late int totalFrontPages;
  late int totalNewsPages;
  late int totalCopyPages;

  late int profit;
  late int? expenses;
  late int? advancePayment;
  late int pagesPerBook;
  late int bookQuantity;
  late int backsidePrint;
  late int numberingExpense;
  late int paperCuttingExpense;
  late int bindingExpenses;
  late int totalExpenses;

  late int selectedMachineFits;
  late int frontPaperExpenses;
  late int copyPaperExpenses;
  late int newsPaperExpenses;
  late int selectedMachineIndex;
  late String customerName;
  late String businessTitle;
  late String customerContactNo;
  late String customerAddress;
  late Timestamp timestamp;

  updateLoading(bool load) {
    _loading = load;
    updateListener();
  }

  calculateRate() async {
    if (_formKey.currentState!.validate()) {
      updateLoading(true);
      try {
        await paperLogic();
        if (fits[selectedMachineIndex] != null) {
          uid = auth.currentUser!.uid;
          timestamp = Timestamp.now();

          designRate = 0;
          noOfPlates = 0;
          noOfFrontPrintings = 0;
          noOfBackPrintings = 0;
          noOfCopyVariantPrintings = 0;
          frontPrintType = 0;
          paperSizePaperQualityRate = 0;
          copyPaperSizePaperQualityRate = 0;
          newPaperSizePaperQualityRate = 0;
          paperCuttingRate = 0;
          cuttingUnit = 0;
          noOfFrontPages = 0;
          noOfFrontExtraPages = 0;
          totalFrontPages = 0;
          totalNewsPages = 0;
          totalCopyPages = 0;
          profit = 0;
          expenses = 0;
          advancePayment = 0;
          pagesPerBook = 0;
          bookQuantity = 0;
          backsidePrint = 0;
          numberingExpense = 0;
          paperCuttingExpense = 0;
          bindingExpenses = 0;
          totalExpenses = 0;
          frontPaperExpenses = 0;
          copyPaperExpenses = 0;

          selectedMachineFits = fits[selectedMachineIndex]!;

          customerName = customerNameC.text.trim();
          businessTitle = businessTitleC.text.trim();
          customerContactNo = customerContactC.text.trim();
          customerAddress = customerAddressC.text.trim();

          cuttingUnit = basicCuttingUnits[selectedBasicCuttingUnitIndex];
          advancePayment = int.tryParse(advancePaymentC.text.trim());
          expenses = int.tryParse(otherExpensesC.text.trim());
          pagesPerBook = int.tryParse(pagesPerBookC.text.trim())!;
          bookQuantity = int.tryParse(booksQuantityC.text.trim())!;
          paperSizePaperQualityRate = papers[selectedPaperSizeIndexes[
                  selectedPaperSizePaperQualities
                      .indexOf(selectedPaperQuality)]]
              .rate;
          newPaperSizePaperQualityRate = newsPapers[
                  selectedNewsPaperSizeIndexes[
                      selectedNewsPaperSizePaperQualities
                          .indexOf(selectedNewsPaperQuality)]]
              .rate;
          copyPaperSizePaperQualityRate = papers[selectedPaperSizeIndexes[
                  selectedPaperSizePaperQualities
                      .indexOf(selectedCopyVariantPaperQuality)]]
              .rate;
          profit = profits[selectedProfitIndex].percentage;

          // FITs
          debugPrint('Selected Machine Fits: ${fits[selectedMachineIndex]}');

          // print type
          /// print type x machine print rate and plate rate
          frontPrintType = int.tryParse(selectedPrint.substring(0, 1))!;
          noOfPlates += frontPrintType;
          noOfFrontPrintings += frontPrintType;

          // totalPages
          noOfFrontPages = ((bookQuantity * pagesPerBook) / cuttingUnit).ceil();
          debugPrint("Total pages: $noOfFrontPages");

          /// 3 extra sheets (basic large sheet) per 10 books or 1000 prints
          noOfFrontExtraPages = (noOfFrontPages * 0.003).ceil();
          debugPrint("Extra Sheets: $noOfFrontExtraPages");

          // total front pages
          totalFrontPages = noOfFrontPages + noOfFrontExtraPages;

          // backside print
          if (selectedBackSide == 'lot-pot') {
            backsidePrint = -1;
            noOfBackPrintings += noOfFrontPrintings;
          } else if (selectedBackSide != 'none') {
            backsidePrint = int.tryParse(selectedBackSide.substring(0, 1))!;
            noOfPlates += backsidePrint;
            noOfBackPrintings += backsidePrint;
          } else {
            backsidePrint = 0;
            debugPrint("No backside selected!");
          }

          // design rate
          if (selectedDesign == 'none') {
            debugPrint("No design");
            debugPrint('Design Rate: $designRate');
          } else {
            designRate = designs[selectedDesignIndex - 1].rate;
            debugPrint('Design Rate: $designRate');
          }

          // binding
          if (selectedBinding == 'none') {
            debugPrint("No binding");
          } else {
            bindingExpenses =
                (bindings[selectedBindingIndex - 1].rate) * bookQuantity;
            debugPrint('Binding Rate: $bindingExpenses');
          }

          // Numbering
          if (selectedNumbering == 'none') {
            debugPrint("No numbering");
          } else {
            numberingExpense =
                (numberings[selectedNumberingIndex - 1].rate) * bookQuantity;
            debugPrint('Numbering Expenses: $numberingExpense');
          }

          // copy variant
          // remove selectedCopyVariantIndex
          // remove selectedCopyPrintIndex

          // The below calculations (before switch statement) are same for all
          frontPaperExpenses =
              ((totalFrontPages / 500) * paperSizePaperQualityRate).ceil();

          switch (selectedCopyVariant) {
            case 'none':
              debugPrint('No copy variant selected!');
              break;
            case 'news':
              // rate of the selected News paper size, selected News paper quality
              totalNewsPages = totalFrontPages;
              newsPaperExpenses =
                  ((totalNewsPages / 500) * newPaperSizePaperQualityRate)
                      .ceil();
              break;
            case 'carbon':
              totalCopyPages = totalFrontPages;
              noOfCopyVariantPrintings +=
                  int.tryParse(selectedVariantPrint.substring(0, 1))!;
              if (selectedVariantPrint != selectedPrint) {
                noOfPlates +=
                    int.tryParse(selectedVariantPrint.substring(0, 1))!;
              }
              copyPaperExpenses =
                  ((totalCopyPages / 500) * paperSizePaperQualityRate).ceil();
              break;
            case 'carbon-less':
              // noOfCopyVariantPrintings += noOfSelectedCarbonLessVariant;
              totalCopyPages = totalFrontPages * noOfSelectedCarbonLessVariant;
              copyPaperExpenses =
                  frontPaperExpenses * noOfSelectedCarbonLessVariant;
              break;
          }

          // paper cutting
          if (selectedPaperCutting == 'none') {
            debugPrint("No paper cutting");
          } else {
            paperCuttingRate =
                paperCuttings[selectedPaperCuttingIndex - 1].rate;
            paperCuttingExpense =
                (((totalNewsPages + totalFrontPages + totalCopyPages) / 500)
                        .ceil() *
                    paperCuttingRate);
            debugPrint('Paper cutting expenses: $paperCuttingExpense');
          }

          debugPrint('Design Rate: $designRate');
          debugPrint(
              'Plates expenses: ${noOfPlates * machines[selectedMachineIndex].plateRate}');

          /// todo: change the following printing expenses as a whole
          debugPrint(
              'Printing Rate: ${(((totalFrontPages * (selectedBackSide == 'lot-pot' ? 2 : 1)) / 1010).ceil() * noOfFrontPrintings) * machines[selectedMachineIndex].printingRate}');
          debugPrint(
              'Backside Rate: ${(selectedBackSide != 'lot-pot') ? (((totalFrontPages / 1010).ceil() * noOfBackPrintings) * machines[selectedMachineIndex].printingRate) : 0}');
          debugPrint('Front Paper Rate: $frontPaperExpenses');
          debugPrint('Other Expenses: $expenses');
          debugPrint('Numbering Expenses: $numberingExpense');
          debugPrint('Paper Cutting Expenses: $paperCuttingExpense');
          debugPrint('Binding Expenses: $bindingExpenses');

          int printingExpenses =
              // printing - if lot-pot(printing of front pages along with lot-pot), else (only front printing)
              (((((totalFrontPages * (selectedBackSide == 'lot-pot' ? 2 : 1)) /
                                      selectedMachineFits) /
                                  1010)
                              .ceil() *
                          noOfFrontPrintings) *
                      machines[selectedMachineIndex].printingRate) +
                  // backside printing - when not lot-pot
                  ((selectedBackSide != 'lot-pot')
                      ? ((((totalFrontPages / selectedMachineFits) / 1010)
                                  .ceil() *
                              noOfBackPrintings) *
                          machines[selectedMachineIndex].printingRate)
                      : 0);

          await setNewCustomerCustomOrderId();

          switch (selectedCopyVariant) {
            case 'none':
              totalExpenses = ((designRate + // design
                          // plates
                          (noOfPlates *
                              machines[selectedMachineIndex].plateRate) +
                          printingExpenses +
                          // noOfCopyVariantPrintings +
                          frontPaperExpenses +
                          // totalNewsPages +
                          // totalCopyPages +
                          (expenses ?? 0) +
                          numberingExpense +
                          paperCuttingExpense +
                          bindingExpenses) /
                      ((100 - profit) / 100))
                  .ceil();
              debugPrint('Total Expenses: $totalExpenses');

              addCustomerCustomOrder(CustomerCustomOrder(
                orderResumedDateTime: timestamp,
                customerOrderId: newCustomerOrderId,
                orderDateTime: timestamp,
                orderStatus: 'New Order',
                customerName: customerName,
                businessTitle: businessTitle,
                customerContact: customerContactNo,
                customerAddress: customerAddress,
                paperSize: '$newWidth x $newHeight',
                paperExpenses: frontPaperExpenses,
                machineName: machines[selectedMachineIndex].name,
                bindingExpenses: bindingExpenses == 0 ? null : bindingExpenses,
                designRate: designRate == 0 ? null : designRate,
                numberingExpenses:
                    numberingExpense == 0 ? null : numberingExpense,
                paperCuttingExpenses:
                    paperCuttingExpense == 0 ? null : paperCuttingExpense,
                plateExpense:
                    noOfPlates * machines[selectedMachineIndex].plateRate,
                printingExpense: printingExpenses,
                bookQuantity: bookQuantity,
                pagesPerBook: pagesPerBook,
                frontPrintType: noOfFrontPrintings,
                backPrintType: backsidePrint == 0 ? null : backsidePrint,
                profitPercent: profits[selectedProfitIndex].percentage,
                otherExpenses: expenses,
                advancePayment: advancePayment ?? 0,
                paidAmount: advancePayment ?? 0,
                totalAmount: totalExpenses,
              ));

              if (advancePayment != null) {
                if (advancePayment! > 0) {
                  setNewCashbookEntryId();
                  addCustomerPaymentInCashbook();
                  updateLoading(false);
                } else {
                  updateLoading(false);
                }
              } else {
                updateLoading(false);
              }
              break;
            case 'news':
              totalExpenses = ((designRate + // design
                          // plates
                          (noOfPlates *
                              machines[selectedMachineIndex].plateRate) +
                          // printing with backside calculations
                          printingExpenses +
                          // noOfCopyVariantPrintings +
                          frontPaperExpenses +
                          newsPaperExpenses +
                          // totalCopyPages +
                          (expenses ?? 0) +
                          numberingExpense +
                          paperCuttingExpense +
                          bindingExpenses) /
                      ((100 - profit) / 100))
                  .ceil();

              debugPrint('Total Expenses: $totalExpenses');

              addCustomerCustomOrder(CustomerCustomOrder(
                  orderResumedDateTime: timestamp,
                  customerOrderId: newCustomerOrderId,
                  orderDateTime: timestamp,
                  orderStatus: 'New Order',
                  customerName: customerName,
                  businessTitle: businessTitle,
                  customerContact: customerContactNo,
                  customerAddress: customerAddress,
                  paperSize: '$newWidth x $newHeight',
                  paperExpenses: frontPaperExpenses,
                  newsPaperExpenses: newsPaperExpenses,
                  copyVariant: 'news',
                  machineName: machines[selectedMachineIndex].name,
                  bindingExpenses:
                      bindingExpenses == 0 ? null : bindingExpenses,
                  designRate: designRate == 0 ? null : designRate,
                  numberingExpenses:
                      numberingExpense == 0 ? null : numberingExpense,
                  paperCuttingExpenses:
                      paperCuttingExpense == 0 ? null : paperCuttingExpense,
                  plateExpense:
                      noOfPlates * machines[selectedMachineIndex].plateRate,
                  printingExpense: printingExpenses,
                  bookQuantity: bookQuantity,
                  pagesPerBook: pagesPerBook,
                  frontPrintType: noOfFrontPrintings,
                  backPrintType: backsidePrint == 0 ? null : backsidePrint,
                  profitPercent: profits[selectedProfitIndex].percentage,
                  otherExpenses: expenses,
                  advancePayment: advancePayment ?? 0,
                  paidAmount: advancePayment ?? 0,
                  totalAmount: totalExpenses));

              if (advancePayment != null) {
                if (advancePayment! > 0) {
                  setNewCashbookEntryId();
                  addCustomerPaymentInCashbook();
                  updateLoading(false);
                } else {
                  updateLoading(false);
                }
              } else {
                updateLoading(false);
              }
              break;
            case 'carbon':
              totalExpenses = ((designRate + // design
                          // plates
                          (noOfPlates *
                              machines[selectedMachineIndex].plateRate) +
                          // printing - if lot-pot(printing of front pages along with lot-pot), else (only front printing)
                          (((((totalFrontPages *
                                                  ((selectedBackSide ==
                                                              'lot-pot'
                                                          ? 2
                                                          : 1) +
                                                      (selectedVariantPrint ==
                                                              selectedPrint
                                                          ? 1
                                                          : 0))) /
                                              selectedMachineFits) /
                                          1010)
                                      .ceil() *
                                  noOfFrontPrintings) *
                              machines[selectedMachineIndex].printingRate) +
                          // backside printing - when not lot-pot
                          ((selectedBackSide != 'lot-pot')
                              ? ((((totalFrontPages / selectedMachineFits) /
                                              1010)
                                          .ceil() *
                                      noOfBackPrintings) *
                                  machines[selectedMachineIndex].printingRate)
                              : 0) +
                          // noOfCopyVariantPrintings +
                          frontPaperExpenses +
                          // totalNewsPages +
                          // copy pages printing when selectedVariantPrint != selectedPrint
                          (selectedVariantPrint != selectedPrint
                              ? ((((totalCopyPages / selectedMachineFits) /
                                              1010)
                                          .ceil() *
                                      noOfCopyVariantPrintings) *
                                  machines[selectedMachineIndex].printingRate)
                              : 0) +
                          // copy pages expenses
                          copyPaperExpenses +
                          (expenses ?? 0) +
                          numberingExpense +
                          paperCuttingExpense +
                          bindingExpenses) /
                      ((100 - profit) / 100))
                  .ceil();

              debugPrint('Total Expenses: $totalExpenses');

              addCustomerCustomOrder(CustomerCustomOrder(
                  orderResumedDateTime: timestamp,
                  customerOrderId: newCustomerOrderId,
                  orderDateTime: timestamp,
                  orderStatus: 'New Order',
                  customerName: customerName,
                  businessTitle: businessTitle,
                  customerContact: customerContactNo,
                  customerAddress: customerAddress,
                  paperSize: '$newWidth x $newHeight',
                  paperExpenses: frontPaperExpenses,
                  carbonExpenses: copyPaperExpenses,
                  copyVariant: 'carbon',
                  machineName: machines[selectedMachineIndex].name,
                  bindingExpenses:
                      bindingExpenses == 0 ? null : bindingExpenses,
                  designRate: designRate == 0 ? null : designRate,
                  numberingExpenses:
                      numberingExpense == 0 ? null : numberingExpense,
                  paperCuttingExpenses:
                      paperCuttingExpense == 0 ? null : paperCuttingExpense,
                  plateExpense:
                      noOfPlates * machines[selectedMachineIndex].plateRate,
                  printingExpense: // printing - if lot-pot(printing of front pages along with lot-pot), else (only front printing)
                      (((((totalFrontPages *
                                                  ((selectedBackSide ==
                                                              'lot-pot'
                                                          ? 2
                                                          : 1) +
                                                      (selectedVariantPrint ==
                                                              selectedPrint
                                                          ? 1
                                                          : 0))) /
                                              selectedMachineFits) /
                                          1010)
                                      .ceil() *
                                  noOfFrontPrintings) *
                              machines[selectedMachineIndex].printingRate) +
                          // backside printing - when not lot-pot
                          ((selectedBackSide != 'lot-pot')
                              ? ((((totalFrontPages / selectedMachineFits) /
                                              1010)
                                          .ceil() *
                                      noOfBackPrintings) *
                                  machines[selectedMachineIndex].printingRate)
                              : 0),
                  bookQuantity: bookQuantity,
                  pagesPerBook: pagesPerBook,
                  frontPrintType: noOfFrontPrintings,
                  backPrintType: backsidePrint == 0 ? null : backsidePrint,
                  profitPercent: profits[selectedProfitIndex].percentage,
                  otherExpenses: expenses,
                  advancePayment: advancePayment ?? 0,
                  paidAmount: advancePayment ?? 0,
                  totalAmount: totalExpenses));

              if (advancePayment != null) {
                if (advancePayment! > 0) {
                  setNewCashbookEntryId();
                  addCustomerPaymentInCashbook();
                  updateLoading(false);
                } else {
                  updateLoading(false);
                }
              } else {
                updateLoading(false);
              }
              break;
            case 'carbon-less':

              /// carbon less can't have backside, carbon-less must have same copy variant printing
              totalExpenses = ((designRate + // design
                          // plates
                          (noOfPlates *
                              machines[selectedMachineIndex].plateRate) +
                          // printing - if lot-pot(printing of front pages along with lot-pot), else (only front printing)
                          ((((totalFrontPages + totalCopyPages) /
                                          selectedMachineFits) /
                                      1010)
                                  .ceil() *
                              machines[selectedMachineIndex].printingRate) +
                          frontPaperExpenses +
                          copyPaperExpenses +
                          (expenses ?? 0) +
                          numberingExpense +
                          paperCuttingExpense +
                          bindingExpenses) /
                      ((100 - profit) / 100))
                  .ceil();

              debugPrint('Total Expenses: $totalExpenses');

              addCustomerCustomOrder(CustomerCustomOrder(
                  orderResumedDateTime: timestamp,
                  customerOrderId: newCustomerOrderId,
                  orderDateTime: timestamp,
                  orderStatus: 'New Order',
                  customerName: customerName,
                  businessTitle: businessTitle,
                  customerContact: customerContactNo,
                  customerAddress: customerAddress,
                  paperSize: '$newWidth x $newHeight',
                  paperExpenses: frontPaperExpenses,
                  carbonLessExpenses: copyPaperExpenses,
                  copyVariant: 'carbon-less',
                  machineName: machines[selectedMachineIndex].name,
                  bindingExpenses:
                      bindingExpenses == 0 ? null : bindingExpenses,
                  designRate: designRate == 0 ? null : designRate,
                  numberingExpenses:
                      numberingExpense == 0 ? null : numberingExpense,
                  paperCuttingExpenses:
                      paperCuttingExpense == 0 ? null : paperCuttingExpense,
                  plateExpense:
                      noOfPlates * machines[selectedMachineIndex].plateRate,
                  printingExpense: // printing - front printing and variant printing
                      (((((totalFrontPages * noOfSelectedCarbonLessVariant) /
                                          selectedMachineFits) /
                                      1010)
                                  .ceil() *
                              noOfFrontPrintings) *
                          machines[selectedMachineIndex].printingRate),
                  bookQuantity: bookQuantity,
                  pagesPerBook: pagesPerBook,
                  frontPrintType: noOfFrontPrintings,
                  profitPercent: profits[selectedProfitIndex].percentage,
                  otherExpenses: expenses,
                  advancePayment: advancePayment ?? 0,
                  paidAmount: advancePayment ?? 0,
                  totalAmount: totalExpenses));

              if (advancePayment != null) {
                if (advancePayment! > 0) {
                  setNewCashbookEntryId();
                  addCustomerPaymentInCashbook();
                  updateLoading(false);
                } else {
                  updateLoading(false);
                }
              } else {
                updateLoading(false);
              }
              break;
          }
        } else {
          updateLoading(false);
        }
      } catch (e) {
        updateLoading(false);
        Utils.showMessage('Error: $e');
      }
    }
  }

  // customer order id
  late int newCustomerOrderId;

  // cashbook id
  late int newCashbookEntryId;

  // addCustomerCustomOrderDataInFirebase(BuildContext context) async {
  //
  //   if (_formKey.currentState != null) {
  //     if (_formKey.currentState!.validate()) {
  //       try {
  //         ///todo: add as a customer order,
  //         await setNewCustomerCustomOrderId();
  //         await addCustomerCustomOrder();
  //
  //         ///todo: add in cashbook
  //         await setNewCashbookEntryId();
  //         await addCustomerPaymentInCashbook();
  //
  //       } catch (e) {
  //         Utils.showMessage('Error: $e');
  //         debugPrint('Error found!\nError: $e');
  //       }
  //     } else {
  //     }
  //   } else {
  //   }
  // }

  setNewCustomerCustomOrderId() async {
    newCustomerOrderId = 1;
    final documentRef = firestore
        .collection(uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('0LastCustomerOrderId');

    final documentSnapshot = await documentRef.get();

    var data = documentSnapshot.data();

    if (data?['LastCustomerOrderId'] == null) {
      debugPrint(
          'Order id found to be null --------- ${data?['LastCustomerOrderId']}');
      await documentRef.set({'LastCustomerOrderId': newCustomerOrderId});
    } else {
      debugPrint(
          '\n\n\nOrder id is found to be available. \nOrder id: ${data?['LastCustomerOrderId']}');
      newCustomerOrderId = data?['LastCustomerOrderId'] + 1;
      await documentRef.set({'LastCustomerOrderId': newCustomerOrderId});
    }
  }

  addCustomerCustomOrder(CustomerCustomOrder customerCustomOrder) async {
    await firestore
        .collection(uid)
        .doc('CustomerData')
        .collection('CustomerOrders')
        .doc('$newCustomerOrderId')
        .set(customerCustomOrder.toJson())
        .then(
      (value) {
        Utils.showMessage('Order added!');
        debugPrint('Customer order added');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error: $error');
        debugPrint('Customer order error....$error');
      },
    );
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
      debugPrint(
          'Cashbook entry id found to be null --------- ${data?['LastCashbookEntryId']}');
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    } else {
      debugPrint(
          '\n\n\nStock ordered id is found to be available. \nStock id: ${data?['LastCashbookEntryId']}');
      newCashbookEntryId = data?['LastCashbookEntryId'] + 1;
      await documentRef.set({'LastCashbookEntryId': newCashbookEntryId});
    }
  }

  addCustomerPaymentInCashbook() async {
    /// adding the payment history to cashbook
    await firestore
        .collection(uid)
        .doc('CashbookData')
        .collection('CashbookEntry')
        .doc('$newCashbookEntryId')
        .set({
      'cashbookEntryId': newCashbookEntryId,
      'customerOrderId': newCustomerOrderId,
      'paymentDateTime': timestamp,
      'amount': advancePayment,
      'description': 'Advance Payment',
      'paymentType': 'CASH-IN',
    }).then(
      (value) {
        Utils.showMessage('Cashbook entry added!');
        debugPrint('\n\n\nCashbook entry added\n\n\n');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error: $error');
        debugPrint('\n\n\nCashbook entry error.... $error\n\n\n');
      },
    );
  }

  paperLogic() {
    // if (_formKey.currentState!.validate()) {
    // cutting unit
    int cuttingUnit = basicCuttingUnits[selectedBasicCuttingUnitIndex];

    // paper width
    int basicWidth = papers[selectedPaperSizeIndexes[
            selectedPaperSizePaperQualities.indexOf(selectedPaperQuality)]]
        .size
        .width;

    // paper height
    int basicHeight = papers[selectedPaperSizeIndexes[
            selectedPaperSizePaperQualities.indexOf(selectedPaperQuality)]]
        .size
        .height;

    // List<List<int>> machinesSizesList = [];
    List<int> machineBasicPriceList = [];
    List<String> machineSizes = [];

    for (var element in machines) {
      // machinesSizesList.add([element.size.width, element.size.height]);
      machineBasicPriceList.add(element.plateRate + element.printingRate);
      machineSizes.add('${element.size.width} x ${element.size.height}');
    }
    debugPrint('Machine sizes list: $machineSizes');
    debugPrint('Machine basic price list: $machineBasicPriceList');

    // List<int?> fits =
    calculateMachineSize(cuttingUnit, basicWidth, basicHeight);
    debugPrint('Fits of machines are: $fits');

    if (fits.every((element) => element == null)) {
      // no machine is suitable
      Utils.showMessage('No machine is suitable!');
      debugPrint('No machine is suitable!');
    } else {
      // pages per book
      int pagesPerBook = int.tryParse(pagesPerBookC.text.trim())!;

      // books quantity
      int bookQuantity = int.tryParse(booksQuantityC.text.trim())!;

      // totalPages
      int totalPages = bookQuantity * pagesPerBook;
      debugPrint("Total pages: $totalPages");

      /// 3 extra sheets (basic large sheet) per 10 books or 1000 prints
      int extraPages = (totalPages * 0.003).ceil();
      debugPrint("Extra Sheets: $extraPages");

      int grandTotalPages = totalPages + extraPages;

      debugPrint("Grand total page before : $grandTotalPages");

      int backPrints = 0;
      if (selectedBackSide == 'lot-pot') {
        backPrints = grandTotalPages;
      }
      int carbonPages = 0;
      int carbonLessPages = 0;
      if (selectedCopyVariant == 'carbon') {
        if (selectedVariantPrint == selectedPrint) {
          carbonPages = grandTotalPages;
        }
      } else if (selectedCopyVariant == 'carbon-less') {
        carbonLessPages = noOfSelectedCarbonLessVariant * grandTotalPages;
      }
      grandTotalPages =
          grandTotalPages + backPrints + carbonLessPages + carbonPages;
      debugPrint("Grand total page after : $grandTotalPages");

      selectedMachineIndex = -1;
      if (grandTotalPages <= 1010) {
        int? smallest;
        for (int i = 0; i < fits.length; i++) {
          if (fits[i] != null) {
            // Check if the first list has a non-null value
            if (smallest == null || machineBasicPriceList[i] < smallest) {
              smallest = machineBasicPriceList[i];
              selectedMachineIndex = i;
            }
          }
        }
        debugPrint(
            'Selected machine rate for less than 1010 pages: ${machineBasicPriceList[selectedMachineIndex]}\t\tIndex: ${selectedMachineIndex + 1}');
      } else {
        // calculate each machine expense
        // int selectedMachineIndex;
        List<int?> machinePriceListAccordingToFits = [];
        for (int i = 0; i < fits.length; i++) {
          if (fits[i] != null) {
            // Check if the first list has a non-null value
            machinePriceListAccordingToFits.add(
                ((((grandTotalPages / fits[i]!) / 1010).ceil()) *
                    machineBasicPriceList[i]));
          } else {
            machinePriceListAccordingToFits.add(null);
          }
        }
        debugPrint(
            'Resultant machines price list according to fits: $machinePriceListAccordingToFits');

        // find the minimum rate
        int? smallest = machinePriceListAccordingToFits
            .whereType<int>()
            .reduce((a, b) => a < b ? a : b);

        selectedMachineIndex =
            machinePriceListAccordingToFits.indexOf(smallest);
      }
      debugPrint(
          'Ultimate selected machine is: ${machines[selectedMachineIndex].name}\t\tIndex: ${selectedMachineIndex + 1}');
    }
    // int totalBasicPages = (totalPages / n).ceil() + extraSheets;
    // debugPrint("Total Basic Pages: $totalBasicPages");

    // int rate = papers[selectedPaperSizeIndexes[
    //         selectedPaperSizePaperQualities.indexOf(selectedPaperQuality)]]
    //     .rate;
    // debugPrint("Rate of 500 pages: $rate");

    // debugPrint("Rate of $totalBasicPages pages: ${((rate/500)*totalBasicPages).ceil()}");
    // } else {
    //   Utils.showMessage('Provide details!');
    // }
  }
}
