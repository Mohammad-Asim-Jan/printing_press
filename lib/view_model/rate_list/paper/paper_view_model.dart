import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/model/rate_list/paper.dart';

import '../../../colors/color_palette.dart';
import '../../../components/custom_text_field.dart';
import '../../../text_styles/custom_text_styles.dart';
import '../../../utils/toast_message.dart';
import '../../../utils/validation_functions.dart';

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
          backgroundColor: Colors.white,
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
                    kTitleText("Edit Paper"),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: nameController,
                        iconData: null,
                        hint: 'Paper Name',
                        validators: [isNotEmpty]),
                    CustomTextField(
                      controller: widthController,
                      hint: 'Paper Width',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: heightController,
                      hint: 'Paper Height',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: qualityController,
                      hint: 'Paper Quality',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: rateController,
                      hint: 'Paper Rate',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: kTitleText("Cancel", 12),
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
                            child:kTitleText("Update", 12),
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
