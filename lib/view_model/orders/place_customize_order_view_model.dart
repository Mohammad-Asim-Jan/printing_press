import 'dart:async';
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
import '../../model/rate_list.dart';

class PlaceCustomizeOrderViewModel with ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? data;

  bool _customOrderDataFetched = false;

  get customOrderDataFetched => _customOrderDataFetched;

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

  // Quantity
  TextEditingController quantityC = TextEditingController();

  /// todo: paper sized or any other rate list things must not be same as available in the firebase
  /// if design with name "standard" is available, then user can't add a design with name "standard"
  /// anything that is in the dropdown menu has to be different else it would give you errors
  /// design name must not be same
  /// paper size are only some... they are hard coded, can't have any other size

  ///todo: rating
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

  checkData() {
    fetchData();
    List<List<dynamic>> lists = [
      bindings,
      designs,
      machines,
      newsPapers,
      numberings,
      papers,
      paperCuttings,
      profits
    ];
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!lists.any((element) => element.isEmpty)) {
        debugPrint('data is not null anymore...');
        // setFirebaseDataLocally();

        ///todo: if there is any element empty (like design, paper etc), it will always shows progressindicator on the view, this is a problem that need to be solved
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

        _customOrderDataFetched = true;
        timer.cancel();
        updateListener();
      } else {
        ///todo: let the user know that there is something not set
        ///for ex if there is no design or binding or anything, then show the user that go to add some
        debugPrint('data is null');
        updateListener();
      }
    });
  }

  List<Binding> bindings = [];
  List<Design> designs = [];
  List<Machine> machines = [];
  List<Paper> newsPapers = [];
  List<Numbering> numberings = [];
  List<Paper> papers = [];
  List<PaperCutting> paperCuttings = [];
  List<Profit> profits = [];

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

    // Map<String, dynamic> modelListMap = {
    //   'Binding': bindings,
    //   'Design': designs,
    //   'Machine': machines,
    //   'NewsPaper': newsPapers,
    //   'Numbering': numberings,
    //   'Paper': papers,
    //   'PaperCutting': paperCuttings,
    //   'Profit': profits,
    // };

    // Map<String, dynamic> classMap = {
    //   'Binding': Binding.fromJson,
    //   'Design': Design.fromJson,
    //   'Machine': Machine.fromJson,
    //   'NewsPaper': Paper.fromJson,
    //   'Numbering': Numbering.fromJson,
    //   'Paper': Paper.fromJson,
    //   'PaperCutting': PaperCutting.fromJson,
    //   'Profit': Profit.fromJson,
    // };

    DocumentReference docRef =
        firestore.collection(auth.currentUser!.uid).doc('RateList');

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
  }

  setDesignData() {
    designNames.add('none');
    // design
    for (var design in designs) {
      designNames.add(design.name);
    }
    selectedDesign = designNames[0];
    selectedDesignIndex = 0;
  }

  setPaperSizeData() {
    paperSizes.add('none');
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
    if (selectedPaperSize == 'none') {
      selectedPaperSizePaperQualities.add('none');
    } else {
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
    }

    debugPrint(selectedPaperSizePaperQualities.toString());
    selectedPaperQuality = selectedPaperSizePaperQualities[0];

    // selected paper quality index ? selectedPaperSizeIndexes[paperQualities.indexOf(selectedPaperQuality)]

    // rate of the selected paper size, selected paper quality
    if (selectedPaperSize != 'none') {
      int rate = papers[selectedPaperSizeIndexes[
              selectedPaperSizePaperQualities.indexOf(selectedPaperQuality)]]
          .rate;
      debugPrint('Rate of the selected paper quality is : $rate');
    } else {
      debugPrint('No paper size selected.');
    }
  }

  setPaperCuttingData() {
    paperCuttingNames.add('none');
    for (var paperCutting in paperCuttings) {
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

    if (selectedNewsPaperSize == 'none') {
      selectedNewsPaperSizePaperQualities.add('none');
    }

    ///todo: remove the else block because data in the initial stage is always none
    else {
      int index = 0;
      for (var news in newsPapers) {
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
      int rate = newsPapers[selectedNewsPaperSizeIndexes[
              selectedNewsPaperSizePaperQualities
                  .indexOf(selectedNewsPaperQuality)]]
          .rate;
      debugPrint('Rate of the selected paper quality is : $rate');
    } else {
      debugPrint('No paper size selected.');
    }
  }

  setBindingData() {
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

  setPrintData() {
    // print
    selectedPrint = printNames[0];
    debugPrint("Print names: $printNames");
  }

  setBackSide() {
    selectedBackSide = 'no';
  }

  updateListener() {
    notifyListeners();
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
