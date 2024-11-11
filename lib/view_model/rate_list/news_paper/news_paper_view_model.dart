import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/model/rate_list/paper.dart';

import '../../../colors/color_palette.dart';
import '../../../utils/toast_message.dart';

class NewsPaperViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List<Paper> newsPaperList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getNewspapersData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('NewsPaper')
        .snapshots();
  }

  void editNewsPaper(BuildContext context, int index) {
    final nameController =
        TextEditingController(text: newsPaperList[index].name);
    final widthController =
        TextEditingController(text: newsPaperList[index].size.width.toString());
    final heightController = TextEditingController(
        text: newsPaperList[index].size.height.toString());
    final qualityController =
        TextEditingController(text: newsPaperList[index].quality.toString());
    final rateController =
        TextEditingController(text: newsPaperList[index].rate.toString());

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: kSecColor,
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
                      "Edit News-Paper",
                      style: Theme.of(context)
                          .appBarTheme
                          .titleTextStyle
                          ?.copyWith(color: kOne),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'News-Paper Name'),
                      validator: (value) {
                        if (value == '' || value == null) {
                          return 'Provide news-paper name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: widthController,
                      decoration:
                          const InputDecoration(labelText: 'News-Paper Width'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide news-paper width';
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
                          const InputDecoration(labelText: 'News-Paper Height'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide news-paper height';
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
                      decoration: const InputDecoration(
                          labelText: 'News-Paper Quality'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide news-paper quality';
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
                          const InputDecoration(labelText: 'News-Paper Rate'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide news-paper rate';
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
                                await FirebaseFirestore.instance
                                    .collection(uid)
                                    .doc('RateList')
                                    .collection('NewsPaper')
                                    .doc('NEWS-${newsPaperList[index].paperId}')
                                    .update({
                                  'name': nameController.text.trim(),
                                  'size': {
                                    'width':
                                        int.parse(widthController.text.trim()),
                                    'height':
                                        int.parse(heightController.text.trim()),
                                  },
                                  'quality':
                                      int.parse(qualityController.text.trim()),
                                  'rate': int.parse(rateController.text.trim()),
                                }).then(
                                  (value) {
                                    Utils.showMessage('News-Paper Updated!');
                                  },
                                ).onError(
                                  (error, stackTrace) {
                                    Utils.showMessage('Error Occurred!');
                                  },
                                );
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

  void confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kSecColor,
          titleTextStyle: Theme.of(context)
              .appBarTheme
              .titleTextStyle
              ?.copyWith(color: kOne),
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await deleteNewsPaper(newsPaperList[index].paperId);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteNewsPaper(int newsPaperId) async {
    await FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('NewsPaper')
        .doc('NEWS-$newsPaperId')
        .delete()
        .then(
      (value) {
        Utils.showMessage('News-Paper deleted!');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error occurred!');
      },
    );
  }

//
// void fetchNewsPaperData() async {
//   dataFetched = false;
//   newsPaperList = [];
//
//   final collectionReference = FirebaseFirestore.instance
//       .collection(FirebaseAuth.instance.currentUser!.uid)
//       .doc('RateList')
//       .collection('NewsPaper');
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
//       newsPaperList.add(Paper.fromJson(data));
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
