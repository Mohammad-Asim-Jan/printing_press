import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/model/rate_list/numbering.dart';

import '../../../colors/color_palette.dart';
import '../../../components/custom_text_field.dart';
import '../../../text_styles/custom_text_styles.dart';
import '../../../utils/toast_message.dart';
import '../../../utils/validation_functions.dart';

class NumberingViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List<Numbering> numberingList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getNumberingsData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Numbering')
        .where('numberingId', isNotEqualTo: null)
        .orderBy('numberingId', descending: true)
        .snapshots();
  }

  void editNumbering(BuildContext context, int index) {
    final nameController =
        TextEditingController(text: numberingList[index].name);
    final rateController =
        TextEditingController(text: numberingList[index].rate.toString());

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  kTitleText( "Edit Numbering"),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: nameController,
                      iconData: null,
                      hint: 'Numbering Name',
                      validators: [isNotEmpty]),
                  CustomTextField(
                    controller: rateController,
                    hint: 'Numbering Rate',
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
                              String numberingName = nameController.text.trim();
                              int numberingRate =
                                  int.tryParse(rateController.text.trim())!;

                              /// check if numbering is already available
                              QuerySnapshot numberingNameQuerySnapshot =
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('Numbering')
                                      .where('numberingId',
                                          isNotEqualTo:
                                              numberingList[index].numberingId)
                                      .where('name', isEqualTo: numberingName)
                                      .limit(1)
                                      .get();

                              if (numberingNameQuerySnapshot.docs.isEmpty) {
                                await FirebaseFirestore.instance
                                    .collection(uid)
                                    .doc('RateList')
                                    .collection('Numbering')
                                    .doc(
                                        'NUM-${numberingList[index].numberingId}')
                                    .update({
                                  'name': numberingName,
                                  'rate': numberingRate,
                                }).then(
                                  (value) {
                                    Utils.showMessage('Numbering Updated!');
                                  },
                                ).onError(
                                  (error, stackTrace) {
                                    Utils.showMessage('Error Occurred!');
                                  },
                                );
                              } else {
                                Utils.showMessage('Try with a different name');
                              }

                              Navigator.pop(context);
                            }
                          },
                          child:kTitleText("Cancel", 12),
                        ),
                      ])
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteNumbering(int numberingId) async {
    await FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Numbering')
        .doc('NUM-$numberingId')
        .delete()
        .then(
      (value) {
        Utils.showMessage('Numbering deleted!');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error occurred!');
      },
    );
  }

}
