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
        .where('paperId', isNotEqualTo: null)
        .orderBy('paperId', descending: true)
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
                    kTitleText( "Edit News-Paper"),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: nameController,
                        iconData: null,
                        hint: 'News-Paper Name',
                        validators: [isNotEmpty]),
                    CustomTextField(
                      controller: widthController,
                      hint: 'News-Paper width',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: heightController,
                      hint: 'News-Paper Height',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: qualityController,
                      hint: 'News-Paper Quality',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: rateController,
                      hint: 'News-Paper Rate',
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
                                int quality =
                                    int.parse(qualityController.text.trim());
                                int rate =
                                    int.parse(rateController.text.trim());
                                int paperWidth =
                                    int.parse(widthController.text.trim());
                                int paperHeight =
                                    int.parse(heightController.text.trim());

                                /// check if newsPaper is already available
                                QuerySnapshot newsPaperNameQuerySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection(uid)
                                        .doc('RateList')
                                        .collection('NewsPaper')
                                        .where('paperId',
                                            isNotEqualTo:
                                                newsPaperList[index].paperId)
                                        .where('name', isEqualTo: paperName)
                                        .limit(1)
                                        .get();

                                if (newsPaperNameQuerySnapshot.docs.isEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('NewsPaper')
                                      .doc(
                                          'NEWS-${newsPaperList[index].paperId}')
                                      .update({
                                    'name': paperName,
                                    'size': {
                                      'width': paperWidth,
                                      'height': paperHeight,
                                    },
                                    'quality': quality,
                                    'rate': rate,
                                  }).then(
                                    (value) {
                                      Utils.showMessage('News-Paper Updated!');
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
                            child: kTitleText("Update", 12),
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

}
