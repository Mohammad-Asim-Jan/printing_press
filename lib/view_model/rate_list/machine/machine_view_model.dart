import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/model/rate_list/machine.dart';

import '../../../colors/color_palette.dart';
import '../../../utils/toast_message.dart';

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
        .snapshots();
  }


  void editMachine(BuildContext context, int index) {
    final nameController = TextEditingController(text: machineList[index].name);
    final widthController =
    TextEditingController(text: machineList[index].size.width.toString());
    final heightController =
    TextEditingController(text: machineList[index].size.height.toString());
    final plateRateController = TextEditingController(text: machineList[index].plateRate.toString());
    final printingRateController = TextEditingController(text: machineList[index].printingRate.toString());



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
                      "Edit Machine",
                      style: Theme.of(context)
                          .appBarTheme
                          .titleTextStyle
                          ?.copyWith(color: kOne),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration:
                      const InputDecoration(labelText: 'Machine Name'),
                      validator: (value) {
                        if (value == '' || value == null) {
                          return 'Provide machine name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: widthController,
                      decoration:
                      const InputDecoration(labelText: 'Machine Width'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide machine width';
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
                      const InputDecoration(labelText: 'Machine Height'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide machine height';
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
                      controller: plateRateController,
                      decoration:
                      const InputDecoration(labelText: 'Machine Plate Rate'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide machine plate rate';
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
                      controller: printingRateController,
                      decoration:
                      const InputDecoration(labelText: 'Machine Printing Rate'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Provide machine printing rate';
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
                                    .collection('Machine')
                                    .doc('MAC-${machineList[index].machineId}')
                                    .update({
                                  'name': nameController.text.trim(),
                                  'size': {
                                    'width': int.parse(widthController.text.trim()),
                                    'height': int.parse(heightController.text.trim()),
                                  },
                                  'plateRate': int.parse(plateRateController.text.trim()),
                                  'printingRate': int.parse(printingRateController.text.trim()),
                                }).then(
                                      (value) {
                                    Utils.showMessage('Machine Updated!');
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
          backgroundColor: kTwo,
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
                await deleteMachine(machineList[index].machineId);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
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

//
// void fetchMachineData() async {
//   dataFetched = false;
//   machineList = [];
//
//   final collectionReference = FirebaseFirestore.instance
//       .collection(FirebaseAuth.instance.currentUser!.uid)
//       .doc('RateList')
//       .collection('Machine');
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
//       machineList.add(Machine.fromJson(data));
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
