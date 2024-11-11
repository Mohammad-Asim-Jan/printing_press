import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/profit.dart';
import 'package:printing_press/utils/toast_message.dart';

class ProfitViewModel with ChangeNotifier {
  // late bool dataFetched;
  late List<Profit> profitList;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getProfitData() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('RateList')
        .collection('Profit')
        .snapshots();
  }

  void editProfit(BuildContext context, int index) {
    final nameController =
    TextEditingController(text: profitList[index].name);
    final percentageController =
    TextEditingController(text: profitList[index].percentage.toString());

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: kSecColor,
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
                    "Edit Profit",
                    style: Theme.of(context)
                        .appBarTheme
                        .titleTextStyle
                        ?.copyWith(color: kOne),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration:
                    const InputDecoration(labelText: 'Profit Name'),
                    validator: (value) {
                      if (value == '' || value == null) {
                        return 'Provide profit name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLength: 2,
                    controller: percentageController,
                    decoration:
                    const InputDecoration(labelText: 'Profit Percentage'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Provide profit percentage';
                      } else if (int.tryParse(value)! < 1) {
                        return 'Provide between 1-99';
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
                                  .collection('Profit')
                                  .doc(
                                  'PROFIT-${profitList[index].profitId}')
                                  .update({
                                'name': nameController.text.trim(),
                                'percentage': int.parse(percentageController.text.trim()),
                              }).then(
                                    (value) {
                                  Utils.showMessage('Profit Updated!');
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
          backgroundColor: kSecColor,
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
                await deleteProfit(
                    profitList[index].profitId);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
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


//
// void fetchProfitData() async {
//   dataFetched = false;
//   profitList = [];
//
//   final collectionReference = FirebaseFirestore.instance
//       .collection(FirebaseAuth.instance.currentUser!.uid)
//       .doc('RateList')
//       .collection('Profit');
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
//       profitList.add(Profit.fromJson(data));
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
