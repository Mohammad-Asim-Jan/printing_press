import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/utils/toast_message.dart';

import '../../../model/rate_list/binding.dart';

class BindingViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List<Binding> bindingList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getBindingsData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Binding')
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
          backgroundColor: kTwo,
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
                  Text(
                    "Edit Binding",
                    style: Theme.of(context)
                        .appBarTheme
                        .titleTextStyle
                        ?.copyWith(color: kOne),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Binding Name'),
                    validator: (value) {
                      if (value == '' || value == null) {
                        return 'Provide binding name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: rateController,
                    decoration:
                        const InputDecoration(labelText: 'Binding Rate'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Provide binding rate';
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
                                  .collection('Binding')
                                  .doc('BIND-${bindingList[index].bindingId}')
                                  .update({
                                'name': nameController.text.trim(),
                                'rate': int.parse(rateController.text.trim()),
                              }).then(
                                (value) {
                                  Utils.showMessage('Binding Updated!');
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
                await deleteBinding(bindingList[index].bindingId);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
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

//
// void fetchBindingData() async {
//   dataFetched = false;
//   bindingList = [];
//
//   final collectionReference = FirebaseFirestore.instance
//       .collection(FirebaseAuth.instance.currentUser!.uid)
//       .doc('RateList')
//       .collection('Binding');
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
//       bindingList.add(Binding.fromJson(data));
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
