import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:printing_press/firebase_options.dart';
import 'package:printing_press/firebase_services/firebase_firestore_services.dart';
import '../../colors/color_palette.dart';
import '../../components/round_button.dart';
import '../../model/rate_list.dart';

class PlaceOrderView extends StatefulWidget {
  const PlaceOrderView({super.key});

  @override
  State<PlaceOrderView> createState() => _PlaceOrderViewState();
}

class _PlaceOrderViewState extends State<PlaceOrderView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  late final RateList rateList;
  Map<String, dynamic>? data;
  bool dataFetched = false;

  // design
  List<String> designNames = [];
  late String selectedDesign;
  late int selectedDesignIndex;

  // paper
  List<int> paperSizeIndex = [];

  // paper size
  List<String> paperSizes = [];
  late String selectedPaperSize;
  late int selectedPaperSizeIndex;

  // paper quality
  List<String> paperQualities = [];
  late String selectedPaperQuality;

  // this index is same for both paper size and paper quality, it refers to the paper object
  int selectedPaperQualityIndex = 0;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirestoreData();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (data != null) {
        debugPrint('data is not null anymore...');
        setFirebaseDataLocally();
        dataFetched = true;
        setState(() {});
        timer.cancel();
      } else {
        debugPrint('data is null');
        return;
      }
    });
  }

  getFirestoreData() async {
    FirebaseFirestoreServices firestore = FirebaseFirestoreServices(auth: auth);
    data = await firestore.fetchData();
    rateList = RateList.fromJson(data!);
  }

  setFirebaseDataLocally() {
    // design
    for (var design in rateList.designs) {
      designNames.add(design.name);
    }
    selectedDesign = designNames[0];
    selectedDesignIndex = 0;
    debugPrint("Design names: $designNames");

    // paper size
    for (var paper in rateList.paper) {
      /// TODO: if this or opposite to this
      /// TODO: make changes to all in this file or anywhere else
      if (!paperSizes.contains('${paper.size.width} x ${paper.size.height}')) {
        paperSizes.add('${paper.size.width} x ${paper.size.height}');
      }
    }
    debugPrint('Paper Sizes : $paperSizes}');
    selectedPaperSize = paperSizes[0];
    selectedPaperSizeIndex = 0;

    // paper quality
    /// todo: change the list when select any other. use set state

    for (var paper in rateList.paper) {
      debugPrint('\nselected Paper size : $selectedPaperSize');
      debugPrint(
          'checking the paper size in firebase: ${paper.size.width} x ${paper.size.height}');
      if (selectedPaperSize == '${paper.size.width} x ${paper.size.height}') {
        paperQualities.add('${paper.quality}');
        paperSizeIndex.add(selectedPaperQualityIndex);
        debugPrint('paper quality added, index no: $selectedPaperQualityIndex');
        selectedPaperQualityIndex++;
      }
    }
    debugPrint(paperQualities.toString());
    selectedPaperQuality = paperQualities[0];

    ///todo: remove the index as it might not be the correct one
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
      ),
      body: dataFetched
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Design'),
                            SizedBox(
                              height: 60,
                              width: 140,
                              child: DropdownButtonFormField<String>(
                                  dropdownColor: kSecColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: const Icon(
                                    //   Icons.design_services_outlined,
                                    //   size: 30,
                                    // ),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: kPrimeColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kSecColor,
                                      ),
                                    ),
                                  ),
                                  // isExpanded: true,
                                  // selectedItemBuilder: (context) {
                                  //   if (_selectedLocation == 'A') {
                                  //     return [const Text('You have selected a')];
                                  //   }
                                  //   return [];
                                  // },
                                  // style: ,

                                  items: designNames.map((String val) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: val,
                                      child: Text(
                                        val,
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(selectedDesign),
                                  onChanged: (newVal) {
                                    selectedDesign = newVal!;
                                    selectedDesignIndex =
                                        designNames.indexOf(selectedDesign);
                                    setState(() {});
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            const Text('Paper Size'),
                            SizedBox(
                              height: 60,
                              width: 140,
                              child: DropdownButtonFormField<String>(
                                  dropdownColor: kSecColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: const Icon(
                                    //   Icons.design_services_outlined,
                                    //   size: 30,
                                    // ),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: kPrimeColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kSecColor,
                                      ),
                                    ),
                                  ),
                                  // isExpanded: true,
                                  // selectedItemBuilder: (context) {
                                  //   if (_selectedLocation == 'A') {
                                  //     return [const Text('You have selected a')];
                                  //   }
                                  //   return [];
                                  // },
                                  // style: ,

                                  items: paperSizes.map((String val) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: val,
                                      child: Text(
                                        val,
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(selectedPaperSize),
                                  onChanged: (newVal) {
                                    selectedPaperSize = newVal!;
                                    selectedPaperSizeIndex =
                                        paperSizes.indexOf(selectedPaperSize);
                                    paperQualities.clear();

                                    setState(() {
                                      // change the next dropdown according to the selected
                                      selectedPaperQualityIndex = 0;
                                      for (var paper in rateList.paper) {
                                        // debugPrint(
                                        //     '\nselected Paper size : $selectedPaperSize');
                                        // debugPrint(
                                        //     'checking the paper size in firebase: ${paper.size.width} x ${paper.size.height}');
                                        if (selectedPaperSize ==
                                            '${paper.size.width} x ${paper.size.height}') {
                                          paperQualities
                                              .add('${paper.quality}');
                                          paperSizeIndex
                                              .add(selectedPaperQualityIndex);
                                          debugPrint(
                                              'paper quality added of index $selectedPaperQualityIndex');
                                          selectedPaperQualityIndex++;
                                        }
                                      }

                                      debugPrint('Paper size indexes : $paperSizeIndex');
                                      debugPrint('Paper Qualities: $paperQualities');
                                      selectedPaperQuality = paperQualities[0];
                                    });
                                  }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Quality'),
                            SizedBox(
                              height: 60,
                              width: 100,
                              child: DropdownButtonFormField<String>(
                                  dropdownColor: kSecColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: const Icon(
                                    //   Icons.design_services_outlined,
                                    //   size: 30,
                                    // ),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: kPrimeColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kSecColor,
                                      ),
                                    ),
                                  ),
                                  // isExpanded: true,
                                  // selectedItemBuilder: (context) {
                                  //   if (_selectedLocation == 'A') {
                                  //     return [const Text('You have selected a')];
                                  //   }
                                  //   return [];
                                  // },
                                  // style: ,

                                  items: paperQualities.map((String val) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: val,
                                      child: Text(
                                        val,
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(selectedPaperQuality),
                                  onChanged: (newVal) {
                                    selectedPaperQuality = newVal!;
                                    setState(() {});
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('something else'),
                            SizedBox(
                              height: 60,
                              width: 140,
                              child: DropdownButtonFormField<String>(
                                  dropdownColor: kSecColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: const Icon(
                                    //   Icons.design_services_outlined,
                                    //   size: 30,
                                    // ),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: kPrimeColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kSecColor,
                                      ),
                                    ),
                                  ),
                                  // isExpanded: true,
                                  // selectedItemBuilder: (context) {
                                  //   if (_selectedLocation == 'A') {
                                  //     return [const Text('You have selected a')];
                                  //   }
                                  //   return [];
                                  // },
                                  // style: ,

                                  items: designNames.map((String val) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: val,
                                      child: Text(
                                        val,
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(selectedDesign),
                                  onChanged: (newVal) {
                                    selectedDesign = newVal!;
                                    selectedDesignIndex =
                                        designNames.indexOf(selectedDesign);
                                    setState(() {});
                                  }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Design'),
                            SizedBox(
                              height: 60,
                              width: 140,
                              child: DropdownButtonFormField<String>(
                                  dropdownColor: kSecColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: const Icon(
                                    //   Icons.design_services_outlined,
                                    //   size: 30,
                                    // ),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: kPrimeColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kSecColor,
                                      ),
                                    ),
                                  ),
                                  // isExpanded: true,
                                  // selectedItemBuilder: (context) {
                                  //   if (_selectedLocation == 'A') {
                                  //     return [const Text('You have selected a')];
                                  //   }
                                  //   return [];
                                  // },
                                  // style: ,

                                  items: designNames.map((String val) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: val,
                                      child: Text(
                                        val,
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(selectedDesign),
                                  onChanged: (newVal) {
                                    selectedDesign = newVal!;
                                    selectedDesignIndex =
                                        designNames.indexOf(selectedDesign);
                                    setState(() {});
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    RoundButton(
                      title: 'Log In',
                      onPress: () {
                        Map<String, dynamic> data = {
                          "name": "paper3",
                          "quality": 100,
                          "size": {"width": 17, "height": 27},
                          "rate": 1540
                        };

                        // debugPrint(
                        //     'The rate of the standard is : ${rateList.designs[selectedDesignIndex].rate}');
                        // debugPrint(
                        //     'The rate of the standard is : ${rateList.paper[selectedPaperSizeIndex].rate}');
                      },
                    ),
                  ]),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// Navigate here from allodersview through floatingactionbutton
// Having two tabs
// 1. Service
//  Get list of services from all services
// 2. Product
//  Get list of products from available

// Add the amount in cash book
// Add the order in all orders
// Decrement from allProduct if selected product
// Order date and time plus order completion time
// Pages or anything we may need for this

//Text('Design',
//                         style: TextStyle(
//                             color: kOne,
//                             fontSize: 23,
//                             fontWeight: FontWeight.bold)),

// TextFormField(
//   controller: designC,
//   onChanged: (text) {
//     debugPrint('Changed text: $text');
//   },
//   keyboardType: TextInputType.number,
//   cursorColor: kPrimeColor,
//   decoration: InputDecoration(
//     hintText: 'Design',
//     filled: true,
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(20),
//       borderSide: BorderSide(
//         width: 2,
//         color: kPrimeColor,
//       ),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(
//         color: kSecColor,
//       ),
//     ),
//   ),
//   validator: (text) {
//     if (text == '' || text == null) {
//       return 'Please provide design';
//     }
//     return null;
//   },
// ),

/// todo: paper sized or any other rate list things must not be same as available in the firebase
/// if design with name standard is available, then user can't add a design with name standard
/// anything that is in the dropdown menu has to be different as it would give you errors
/// design name must not be same
/// paper size are only some... they are hard coded, can't have any other size
///
