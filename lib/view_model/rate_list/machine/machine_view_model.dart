import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/model/rate_list/machine.dart';

import '../../../colors/color_palette.dart';
import '../../../components/custom_text_field.dart';
import '../../../text_styles/custom_text_styles.dart';
import '../../../utils/toast_message.dart';
import '../../../utils/validation_functions.dart';

class MachineViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List<Machine> machineList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getMachinesData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Machine')
        .where('machineId', isNotEqualTo: null)
        .orderBy('machineId', descending: true)
        .snapshots();
  }

  void editMachine(BuildContext context, int index) {
    final nameController = TextEditingController(text: machineList[index].name);
    final widthController =
        TextEditingController(text: machineList[index].size.width.toString());
    final heightController =
        TextEditingController(text: machineList[index].size.height.toString());
    final plateRateController =
        TextEditingController(text: machineList[index].plateRate.toString());
    final printingRateController =
        TextEditingController(text: machineList[index].printingRate.toString());

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
                    kTitleText("Edit Machine"),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: nameController,
                        iconData: null,
                        hint: 'Machine Name',
                        validators: [isNotEmpty]),
                    CustomTextField(
                      controller: widthController,
                      hint: 'Machine Width',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: heightController,
                      hint: 'Machine Height',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: plateRateController,
                      hint: 'Plate Rate',
                      textInputType: TextInputType.number,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      validators: [isNotEmpty, isNotZero],
                    ),
                    CustomTextField(
                      controller: printingRateController,
                      hint: 'Printing Rate',
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
                                String machineName = nameController.text.trim();
                                int plateRate = int.tryParse(
                                    plateRateController.text.trim())!;
                                int machineWidth =
                                    int.parse(widthController.text.trim());
                                int machineHeight =
                                    int.parse(heightController.text.trim());
                                int printingRate = int.parse(
                                    printingRateController.text.trim());

                                /// check if machine is already available
                                QuerySnapshot machineNameQuerySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection(uid)
                                        .doc('RateList')
                                        .collection('Machine')
                                        .where('machineId',
                                            isNotEqualTo:
                                                machineList[index].machineId)
                                        .where('name', isEqualTo: machineName)
                                        .limit(1)
                                        .get();

                                if (machineNameQuerySnapshot.docs.isEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection(uid)
                                      .doc('RateList')
                                      .collection('Machine')
                                      .doc(
                                          'MAC-${machineList[index].machineId}')
                                      .update({
                                    'name': machineName,
                                    'size': {
                                      'width': machineWidth,
                                      'height': machineHeight
                                    },
                                    'plateRate': plateRate,
                                    'printingRate': printingRate
                                  }).then((value) {
                                    Utils.showMessage('Machine Updated!');
                                  }).onError((error, stackTrace) {
                                    Utils.showMessage('Error Occurred!');
                                  });
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

  Future<void> deleteMachine(int machineId) async {
    await FirebaseFirestore.instance
        .collection(uid)
        .doc('RateList')
        .collection('Machine')
        .doc('MAC-$machineId')
        .delete()
        .then(
      (value) {
        Utils.showMessage('Machine deleted!');
      },
    ).onError(
      (error, stackTrace) {
        Utils.showMessage('Error occurred!');
      },
    );
  }

}
