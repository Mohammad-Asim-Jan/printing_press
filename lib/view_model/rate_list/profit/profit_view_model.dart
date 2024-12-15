import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/model/rate_list/profit.dart';
import 'package:printing_press/utils/toast_message.dart';

import '../../../components/custom_text_field.dart';
import '../../../text_styles/custom_text_styles.dart';
import '../../../utils/validation_functions.dart';

class ProfitViewModel with ChangeNotifier {

  late List<Profit> profitList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getProfitData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Profit')
        .where('profitId', isNotEqualTo: null)
        .orderBy('profitId', descending: true)
        .snapshots();
  }

  void editProfit(BuildContext context, int index) {
    final nameController = TextEditingController(text: profitList[index].name);
    final percentageController =
        TextEditingController(text: profitList[index].percentage.toString());

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
                  kTitleText("Edit Profit"),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: nameController,
                      iconData: null,
                      hint: 'Profit Name',
                      validators: [isNotEmpty]),
                  CustomTextField(
                    maxLength: 2,
                    controller: percentageController,
                    hint: 'Profit Percentage',
                    textInputType: TextInputType.number,
                    inputFormatter: FilteringTextInputFormatter.digitsOnly,
                    validators: [isNotEmpty, isNotZero],
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child:  kTitleText("Cancel", 12)
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              String profitName = nameController.text.trim();
                              int profitPercentage = int.tryParse(
                                  percentageController.text.trim())!;

                              /// check if profit is already available
                              QuerySnapshot profitNameQuerySnapshot =
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('Profit')
                                      .where('profitId',
                                          isNotEqualTo:
                                              profitList[index].profitId)
                                      .where('name', isEqualTo: profitName)
                                      .limit(1)
                                      .get();

                              QuerySnapshot profitPercentageQuerySnapshot =
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('Profit')
                                      .where('profitId',
                                          isNotEqualTo:
                                              profitList[index].profitId)
                                      .where('percentage',
                                          isEqualTo: profitPercentage)
                                      .limit(1)
                                      .get();

                              if (profitNameQuerySnapshot.docs.isEmpty &&
                                  profitPercentageQuerySnapshot.docs.isEmpty) {
                                await FirebaseFirestore.instance
                                    .collection(uid)
                                    .doc('RateList')
                                    .collection('Profit')
                                    .doc('PROFIT-${profitList[index].profitId}')
                                    .update({
                                  'name': profitName,
                                  'percentage': profitPercentage
                                }).then(
                                  (value) {
                                    Utils.showMessage('Profit Updated!');
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

  Future<void> deleteProfit(int profitId) async {
    await FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Profit')
        .doc('PROFIT-$profitId')
        .delete()
        .then(
      (value) {
        Utils.showMessage('Profit deleted!');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error occurred!');
      },
    );
  }

}
