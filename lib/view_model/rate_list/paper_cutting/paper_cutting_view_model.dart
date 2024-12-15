import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../components/custom_text_field.dart';
import '../../../model/rate_list/paper_cutting.dart';
import '../../../text_styles/custom_text_styles.dart';
import '../../../utils/toast_message.dart';
import '../../../utils/validation_functions.dart';

class PaperCuttingViewModel with ChangeNotifier {
  late List<PaperCutting> paperCuttingList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getPaperCuttingData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('PaperCutting')
        .where('paperCuttingId', isNotEqualTo: null)
        .orderBy('paperCuttingId', descending: true)
        .snapshots();
  }

  void editPaperCutting(BuildContext context, int index) {
    final nameController =
        TextEditingController(text: paperCuttingList[index].name);
    final rateController =
        TextEditingController(text: paperCuttingList[index].rate.toString());

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
                  kTitleText("Edit Paper Cutting"),
                  const SizedBox(height: 10),
                  CustomTextField(
                      controller: nameController,
                      iconData: null,
                      hint: 'Paper Cutting Name',
                      validators: [isNotEmpty]),
                  CustomTextField(
                    controller: rateController,
                    hint: 'Paper Cutting Rate',
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
                              String paperCuttingName =
                                  nameController.text.trim();
                              int paperCuttingRate =
                                  int.tryParse(rateController.text.trim())!;

                              /// check if paperCutting is already available
                              QuerySnapshot paperCuttingNameQuerySnapshot =
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('PaperCutting')
                                      .where('paperCuttingId',
                                          isNotEqualTo: paperCuttingList[index]
                                              .paperCuttingId)
                                      .where('name',
                                          isEqualTo: paperCuttingName)
                                      .limit(1)
                                      .get();

                              if (paperCuttingNameQuerySnapshot.docs.isEmpty) {
                                await FirebaseFirestore.instance
                                    .collection(uid)
                                    .doc('RateList')
                                    .collection('PaperCutting')
                                    .doc(
                                        'PAP-CUT-${paperCuttingList[index].paperCuttingId}')
                                    .update({
                                  'name': paperCuttingName,
                                  'rate': paperCuttingRate,
                                }).then(
                                  (value) {
                                    Utils.showMessage('Paper Cutting Updated!');
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
                          child: kTitleText("Update", 12),
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

  Future<void> deletePaperCutting(int paperCuttingId) async {
    await FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('PaperCutting')
        .doc('PAP-CUT-$paperCuttingId')
        .delete()
        .then(
      (value) {
        Utils.showMessage('Paper cutting deleted!');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error occurred!');
      },
    );
  }
}
