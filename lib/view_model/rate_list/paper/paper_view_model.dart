import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/model/rate_list/paper.dart';

import '../../../colors/color_palette.dart';
import '../../../utils/toast_message.dart';

class PaperViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List<Paper> paperList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getPaperData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Paper')
        .where('paperId', isNotEqualTo: null)
        .orderBy('paperId', descending: true)
        .snapshots();
  }

  void editPaper(BuildContext context, int index) {
    final nameController = TextEditingController(text: paperList[index].name);
    final widthController =
        TextEditingController(text: paperList[index].size.width.toString());
    final heightController =
        TextEditingController(text: paperList[index].size.height.toString());
    final qualityController =
        TextEditingController(text: paperList[index].quality.toString());
    final rateController =
        TextEditingController(text: paperList[index].rate.toString());

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: kTwo,
          insetPadding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Edit Paper",
                      style: Theme.of(context)
                          .appBarTheme
                          .titleTextStyle
                          ?.copyWith(color: kOne),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Paper Name'),
                      validator: (value) {
                        if (value == '' || value == null) {
                          return 'Provide paper name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: widthController,
                      decoration:
                          const InputDecoration(labelText: 'Paper Width'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide paper width';
                        } else if (int.tryParse(value) == null) {
                          return 'Provide valid value';
                        } else if (int.tryParse(value) == 0) {
                          return 'Must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: heightController,
                      decoration:
                          const InputDecoration(labelText: 'Paper Height'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide paper height';
                        } else if (int.tryParse(value) == null) {
                          return 'Provide valid value';
                        } else if (int.tryParse(value) == 0) {
                          return 'Must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: qualityController,
                      decoration:
                          const InputDecoration(labelText: 'Paper Quality'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide paper quality';
                        } else if (int.tryParse(value) == null) {
                          return 'Provide valid value';
                        } else if (int.tryParse(value) == 0) {
                          return 'Must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: rateController,
                      decoration:
                          const InputDecoration(labelText: 'Paper Rate'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide paper rate';
                        } else if (int.tryParse(value) == null) {
                          return 'Provide valid value';
                        } else if (int.tryParse(value) == 0) {
                          return 'Must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                String paperName = nameController.text.trim();
                                int paperQuality =
                                    int.parse(qualityController.text.trim());
                                int rate =
                                    int.parse(rateController.text.trim());
                                int paperWidth =
                                    int.parse(widthController.text.trim());
                                int paperHeight =
                                    int.parse(heightController.text.trim());

                                /// check if Paper is already available
                                QuerySnapshot paperNameQuerySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection(uid)
                                        .doc('RateList')
                                        .collection('Paper')
                                        .where('paperId',
                                            isNotEqualTo:
                                                paperList[index].paperId)
                                        .where('name', isEqualTo: paperName)
                                        .limit(1)
                                        .get();

                                if (paperNameQuerySnapshot.docs.isEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('Paper')
                                      .doc('PAPER-${paperList[index].paperId}')
                                      .update({
                                    'name': paperName,
                                    'size': {
                                      'width': paperWidth,
                                      'height': paperHeight,
                                    },
                                    'quality': paperQuality,
                                    'rate': rate,
                                  }).then(
                                    (value) {
                                      Utils.showMessage('Paper Updated!');
                                    },
                                  ).onError(
                                    (error, stackTrace) {
                                      Utils.showMessage('Error Occurred!');
                                    },
                                  );
                                } else {
                                  Utils.showMessage(
                                      'Try with a different name');
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Update"),
                          ),
                        ])
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> deletePaper(int paperId) async {
    await FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Paper')
        .doc('PAPER-$paperId')
        .delete()
        .then(
      (value) {
        Utils.showMessage('Paper deleted!');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error occurred!');
      },
    );
  }

//
// void fetchPaperData() async {
//   dataFetched = false;
//   paperList = [];
//
//   final collectionReference = FirebaseFirestore.instance
//       .collection(FirebaseAuth.instance.currentUser!.uid)
//       .doc('RateList')
//       .collection('Paper');
//
//   final querySnapshot = await collectionReference.get();
//
//   final listQueryDocumentSnapshot = querySnapshot.docs;
//
//   if (listQueryDocumentSnapshot.length <= 1) {
//     debugPrint('No records found !');
//     dataFetched = true;
//     updateListener();
//   } else {
//     for (int i = 1; i < listQueryDocumentSnapshot.length; i++) {
//       var data = listQueryDocumentSnapshot[i].data();
//       debugPrint('hello        ${data.toString()}');
//       paperList.add(Paper.fromJson(data));
//     }
//
//     dataFetched = true;
//     updateListener();
//   }
// }
//
// updateListener() {
//   notifyListeners();
// }
}
