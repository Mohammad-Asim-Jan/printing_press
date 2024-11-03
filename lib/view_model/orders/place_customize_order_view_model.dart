import 'dart:core';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/rate_list/binding.dart';
import 'package:printing_press/model/rate_list/design.dart';
import 'package:printing_press/model/rate_list/numbering.dart';
import 'package:printing_press/model/rate_list/paper_cutting.dart';
import 'package:printing_press/model/rate_list/profit.dart';
import 'package:printing_press/utils/toast_message.dart';
import '../../model/rate_list.dart';

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
  String selectedVariantPrint ='1C';

  // variant type
  List<String> carbonLessVariantTypeNames = ['dup', 'trip', 'quad'];
  String selectedCarbonLessVariantType = 'dup';

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
  List<String> backSidePrintingList = ['none', '1C', '2C', '3C', '4C'];
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
      if (lists.any((element) => element.isNotEmpty) &&
          _customOrderDataFetched) {
        debugPrint('data is not null anymore...');
        // setFirebaseDataLocally();

        ///todo: if there is any element empty (like design, paper etc),
        ///it will always shows progress indicator on the view,
        ///this is a problem that need to be solved
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
        ///todo: let the user know that there is something not set
        ///for ex if there is no design or binding or anything, then show the user that go to add some
        debugPrint('data is null');
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

  setCopyVariantOnChange() {
    copyVariantOnChange = (String? newVal) {
      selectedCopyVariant = newVal!;
      selectedCopyVariantIndex = copyVariantNames.indexOf(selectedCopyVariant);
      updateListener();
    };
  }

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
    debugPrint("Rate of binding: ${bindings[selectedBindingIndex].rate}");
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
    debugPrint("Rate of numbering: ${numberings[selectedNumberingIndex].rate}");
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

  List<int?> calculateMachineSize(int n, int basicWidth, int basicHeight) {
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
    double newWidth = basicHeight / factors[0]; // Big factor
    double newHeight = basicWidth / factors[1]; // Small factor
    debugPrint('Paper Size: ${newWidth.ceil()} x ${newHeight.ceil()}');

    // how many pages can be fit to each machine
    List<int?> fits = [];

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
    return fits;
  }

  int noOfPlates = 0;
  int noOfPrintings = 0;

  // late int basicWidth;
  // late int basicHeight;
  int designRate = 0;
  int paperSizePaperQualityRate = 0;
  int paperCuttingRate = 0;
  int cuttingUnit = 1;
  int totalPages = 0;
  int extraPages = 0;
  int grandTotalPages = 0;
  int profit = 0;
  int expenses = 0;
  int advancePayment = 0;
  int pagesPerBook = 0;
  int bookQuantity = 0;
  int backsidePrint = 0;
  int printType = 1;
  int numberingRate = 0;

  // plates
  int totalPlates = 0;

  int noOfPrinting = 0;

  calculateRate() {
    // cutting unit
    cuttingUnit = basicCuttingUnits[selectedBasicCuttingUnitIndex];

    // advance payment
    advancePayment = int.tryParse(advancePaymentC.text.trim())!;

    // expenses
    expenses = int.tryParse(otherExpensesC.text.trim())!;

    // pages per book
    pagesPerBook = int.tryParse(pagesPerBookC.text.trim())!;

    // books quantity
    bookQuantity = int.tryParse(booksQuantityC.text.trim())!;

    // paper rate
    paperSizePaperQualityRate = papers[selectedPaperSizeIndexes[
            selectedPaperSizePaperQualities.indexOf(selectedPaperQuality)]]
        .rate;

    // profit
    profit = profits[selectedProfitIndex].percentage;

    // print type
    /// print type x machine print rate and plate rate
    printType = int.tryParse(selectedPrint.substring(0, 1))!;
    noOfPrinting = printType;

    // totalPages
    totalPages = bookQuantity * pagesPerBook;
    debugPrint("Total pages: $totalPages");

    /// 3 extra sheets (basic large sheet) per 10 books or 1000 prints
    extraPages = (totalPages * 0.003).ceil();
    debugPrint("Extra Sheets: $extraPages");

    // backside print
    /// (machine plate + printing ) x following
    backsidePrint = int.tryParse(selectedBackSide.substring(0, 1)) ?? 0;

    // design rate
    if (selectedDesign == 'none') {
      designRate = 0;
      debugPrint("No design");
      debugPrint('Design Rate: $designRate');
    } else {
      designRate = designs[selectedDesignIndex - 1].rate;

      /// double the design if selected backside
      // if(backsidePrint != 0 ){
      //   designRate *=2;
      // }
      debugPrint('Design Rate: $designRate');
    }

    // paper cutting
    if (selectedPaperCutting == 'none') {
      paperCuttingRate = 0;
      debugPrint("No paper cutting");
    } else {
      paperCuttingRate = paperCuttings[selectedPaperCuttingIndex].rate;
      debugPrint('Paper cutting Rate: $paperCuttingRate');
    }

    // binding
    if (selectedBinding == 'none') {
      debugPrint("No binding");
    } else {
      debugPrint('Binding Rate: ${bindings[selectedBindingIndex - 1].rate}');

      /// todo: calculate according to book quantity
    }

    // Numbering
    if (selectedNumbering == 'none') {
      numberingRate = 0;
      debugPrint("No numbering");
    } else {
      numberingRate = numberings[selectedNumberingIndex - 1].rate;
      debugPrint('Numbering Rate: $numberingRate');

      /// todo: calculate according to book quantity
    }

    // copy variant
    // remove selectedCopyVariantIndex
    // remove selectedCopyPrintIndex
    switch (selectedCopyVariant) {
      case 'none':
        // no copy variant
        int result = designRate;
        break;
      case 'news':
        // printing expense
        /// todo: selectedCopyPrint == 'none' ? 0 :  printing rate from machine + numbering x 2;
        // rate of the selected News paper size, selected News paper quality
        int rate = newsPapers[selectedNewsPaperSizeIndexes[
                selectedNewsPaperSizePaperQualities
                    .indexOf(selectedNewsPaperQuality)]]
            .rate;
        break;
      case 'dup':

        /// machine print rate + numbering x 2
        break;
      case 'trip':

        /// machine print rate + numbering x 3
        break;
    }

    if (selectedCopyVariant == 'news' &&
        selectedPaperSize == selectedNewsPaperSize) {
    } else {
      Utils.showMessage('Select compatible news paper!');
    }
  }

  paperLogic() {
    if (_formKey.currentState!.validate()) {
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

      // List<List<int>> machinesSizesList = [];
      List<int> machineBasicPriceList = [];
      List<String> machineSizes = [];

      for (var element in machines) {
        // machinesSizesList.add([element.size.width, element.size.height]);
        machineBasicPriceList.add(element.plate + element.printing);
        machineSizes.add('${element.size.width} x ${element.size.height}');
      }
      debugPrint('Machine sizes list: $machineSizes');
      debugPrint('Machine basic price list: $machineBasicPriceList');

      List<int?> fits =
          calculateMachineSize(cuttingUnit, basicWidth, basicHeight);

      debugPrint('Fits of machines are: $fits');

      if (fits.every((element) => element == null)) {
        // no machine is suitable
        Utils.showMessage('No machine is suitable!');
        debugPrint('No machine is suitable!');
      } else {
        int grandTotalPages = totalPages + extraPages;

        int selectedMachineIndex = -1;
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
              'Selected machine rate for less than 1010 pages: ${machineBasicPriceList[selectedMachineIndex]}');
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
            'Ultimate selected machine is: ${machines[selectedMachineIndex].name}');
      }

      // int totalBasicPages = (totalPages / n).ceil() + extraSheets;
      // debugPrint("Total Basic Pages: $totalBasicPages");

      // int rate = papers[selectedPaperSizeIndexes[
      //         selectedPaperSizePaperQualities.indexOf(selectedPaperQuality)]]
      //     .rate;
      // debugPrint("Rate of 500 pages: $rate");

      // debugPrint("Rate of $totalBasicPages pages: ${((rate/500)*totalBasicPages).ceil()}");
    }
  }

}
