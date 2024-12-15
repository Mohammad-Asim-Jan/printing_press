import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/utils/toast_message.dart';
import 'package:printing_press/utils/validation_functions.dart';

import '../../../model/rate_list/binding.dart';

class BindingViewModel with ChangeNotifier {
  late List<Binding> bindingList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getBindingsData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Binding')
        .where('bindingId', isNotEqualTo: null)
        .orderBy('bindingId', descending: true)
        .snapshots();
  }

  void editBinding(BuildContext context, int index) {
    final nameController = TextEditingController(text: bindingList[index].name);
    final rateController =
        TextEditingController(text: bindingList[index].rate.toString());

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
                  kTitleText("Edit Binding"),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: nameController,
                      iconData: null,
                      hint: 'Binding Name',
                      validators: [isNotEmpty]),
                  CustomTextField(
                    controller: rateController,
                    hint: 'Binding Rate',
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
                          child:  kTitleText("Cancel", 12),
                        ),
                        TextButton(
                            onPressed: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                String bindingName = nameController.text.trim();
                                int bindingRate =
                                    int.tryParse(rateController.text.trim())!;

                                /// check if binding is already available
                                QuerySnapshot bindingNameQuerySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection(uid)
                                        .doc('RateList')
                                        .collection('Binding')
                                        .where('bindingId',
                                            isNotEqualTo:
                                                bindingList[index].bindingId)
                                        .where('name', isEqualTo: bindingName)
                                        .limit(1)
                                        .get();

                                if (bindingNameQuerySnapshot.docs.isEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('Binding')
                                      .doc(
                                          'BIND-${bindingList[index].bindingId}')
                                      .update({
                                    'name': bindingName,
                                    'rate': bindingRate,
                                  }).then(
                                    (value) {
                                      Utils.showMessage('Binding Updated!');
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
                            child: kTitleText("Update", 12))
                      ])
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteBinding(int bindingId) async {
    await FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Binding')
        .doc('BIND-$bindingId')
        .delete()
        .then(
      (value) {
        Utils.showMessage('Binding deleted!');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error occurred!');
      },
    );
  }
}
