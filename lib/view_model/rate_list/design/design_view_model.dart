import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/utils/toast_message.dart';

import '../../../colors/color_palette.dart';
import '../../../components/custom_text_field.dart';
import '../../../model/rate_list/design.dart';
import '../../../text_styles/custom_text_styles.dart';
import '../../../utils/validation_functions.dart';

class DesignViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List<Design> designList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getDesignsData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Design')
        .where('designId', isNotEqualTo: null)
        .orderBy('designId', descending: true)
        .snapshots();
  }

  void editDesign(BuildContext context, int index) {
    final nameController = TextEditingController(text: designList[index].name);
    final rateController =
        TextEditingController(text: designList[index].rate.toString());

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
                  kTitleText( "Edit Design"),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: nameController,
                      iconData: null,
                      hint: 'Design Name',
                      validators: [isNotEmpty]),
                  CustomTextField(
                    controller: rateController,
                    hint: 'Design Rate',
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
                              String designName = nameController.text.trim();
                              int designRate =
                                  int.tryParse(rateController.text.trim())!;

                              /// check if design is already available
                              QuerySnapshot designNameQuerySnapshot =
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('Design')
                                      .where('designId',
                                          isNotEqualTo:
                                              designList[index].designId)
                                      .where('name', isEqualTo: designName)
                                      .limit(1)
                                      .get();

                              if (designNameQuerySnapshot.docs.isEmpty) {
                                await FirebaseFirestore.instance
                                    .collection(uid)
                                    .doc('RateList')
                                    .collection('Design')
                                    .doc('DES-${designList[index].designId}')
                                    .update({
                                  'name': designName,
                                  'rate': designRate,
                                }).then(
                                  (value) {
                                    Utils.showMessage('Design Updated!');
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

  Future<void> deleteDesign(int designId) async {
    await FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Design')
        .doc('DES-$designId')
        .delete()
        .then(
      (value) {
        Utils.showMessage('Design deleted!');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error occurred!');
      },
    );
  }

}
