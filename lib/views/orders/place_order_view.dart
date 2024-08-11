import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  List<int> selectedPaperSizeIndexes = [];

  // paper size
  List<String> paperSizes = [];
  late String selectedPaperSize;

  // paper quality
  List<String> paperQualities = [];
  late String selectedPaperQuality;

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

    // paper qualities
    /// todo: change the list when select any other. use set state
    int index = 0;
    for (var paper in rateList.paper) {
      debugPrint('\nselected Paper size : $selectedPaperSize');
      debugPrint(
          'checking the paper size in firebase: ${paper.size.width} x ${paper.size.height}');
      if (selectedPaperSize == '${paper.size.width} x ${paper.size.height}') {
        paperQualities.add('${paper.quality}');
        selectedPaperSizeIndexes.add(index);
        debugPrint('paper quality added, index no: $index');
        index++;
      }
    }
    debugPrint(paperQualities.toString());
    selectedPaperQuality = paperQualities[0];

    // selected paper quality index ? selectedPaperSizeIndexes[paperQualities.indexOf(selectedPaperQuality)]

    // rate of the selected paper size, selected paper quality
    int rate = rateList
        .paper[selectedPaperSizeIndexes[
            paperQualities.indexOf(selectedPaperQuality)]]
        .rate;
    debugPrint('Rate of the selected paper quality is : $rate');
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
                                    paperQualities.clear();
                                    selectedPaperSizeIndexes.clear();

                                    // change the next dropdown according to the selected paper size
                                    int index = 0;
                                    for (var paper in rateList.paper) {
                                      // debugPrint(
                                      //     '\n selected Paper size : $selectedPaperSize');
                                      // debugPrint(
                                      //     'checking the paper size in firebase: ${paper.size.width} x ${paper.size.height}');
                                      if (selectedPaperSize ==
                                          '${paper.size.width} x ${paper.size.height}') {
                                        paperQualities.add('${paper.quality}');
                                        selectedPaperSizeIndexes.add(index);
                                        debugPrint(
                                            'paper quality added of index $index');
                                        index++;
                                      }
                                      index++;
                                    }

                                    debugPrint(
                                        'Paper size indexes : $selectedPaperSizeIndexes');
                                    debugPrint(
                                        'Paper Qualities: $paperQualities');
                                    selectedPaperQuality = paperQualities[0];
                                    debugPrint(
                                        'Selected Paper Quality: $selectedPaperQuality');

                                    // rate of the selected paper size, selected paper quality
                                    int rate = rateList
                                        .paper[selectedPaperSizeIndexes[
                                            paperQualities
                                                .indexOf(selectedPaperQuality)]]
                                        .rate;
                                    debugPrint(
                                        'Rate of the selected paper quality is : $rate');
                                    setState(() {});
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
                                  value: selectedPaperQuality,
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
                                    setState(() {
                                      debugPrint(
                                          "All Paper Qualities: ${paperQualities.toString()}");
                                      // rate of the selected paper size, selected paper quality
                                      int rate = rateList
                                          .paper[selectedPaperSizeIndexes[
                                              paperQualities.indexOf(
                                                  selectedPaperQuality)]]
                                          .rate;
                                      debugPrint(
                                          'Rate of the selected paper quality is : $rate');
                                    });
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
                        print('add a paper');
                        // todo: remove it
                        Map<String, dynamic> data = {
                          "name": "paper3",
                          "quality": 100,
                          "size": {"width": 17, "height": 27},
                          "rate": 1540
                        };

                        /// todo:
                        // Updating data to the firebase, but you have to fetch the data first, then you alter the data, and then update that data to the firebase firestore
                        // FirebaseFirestore.instance
                        //     .collection(auth.currentUser!.uid)
                        //     .doc("RateList")
                        //     .update({
                        //   "paper": [data]
                        // });

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
// Decrement from allProduct or stock if selected a product
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
/// if design with name "standard" is available, then user can't add a design with name "standard"
/// anything that is in the dropdown menu has to be different as it would give you errors
/// design name must not be same
/// paper size are only some... they are hard coded, can't have any other size
///
