import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/numbering.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/numbering/numbering_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_circular_indicator.dart';
import '../../../view_model/delete_alert_dialogue.dart';

class NumberingView extends StatefulWidget {
  const NumberingView({super.key});

  @override
  State<NumberingView> createState() => _NumberingViewState();
}

class _NumberingViewState extends State<NumberingView> {
  late NumberingViewModel numberingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberingViewModel =
        Provider.of<NumberingViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NumberingViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: value.getNumberingsData(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomCircularIndicator();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              value.numberingList = snapshot.data!.docs.map((e) {
                return Numbering.fromJson(e.data());
              }).toList();
              if (value.numberingList.isEmpty) {
                return const Center(child: Text('No numbering found!'));
              }

              return ListView.builder(
                itemCount: value.numberingList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 1.5,
                    shadowColor: Colors.blue.withOpacity(0.1),
                    color: Colors.blue.withOpacity(.15),
                    margin: EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(width: 5),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kTitleText(value.numberingList[index].name, 14)
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rate', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kDescriptionText(
                                    'Rs. ${value.numberingList[index].rate}',
                                    14)
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () =>
                                        value.editNumbering(context, index),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: kNew4,
                                    )),
                                GestureDetector(
                                    child: Icon(Icons.delete,
                                        size: 20, color: kNew4),
                                    onTap: () =>
                                        DeleteAlertDialogue.confirmDelete(
                                            context, () {
                                          value.deleteNumbering(value
                                              .numberingList[index]
                                              .numberingId);
                                          Navigator.pop(context);
                                        }))
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Text('No data!');
          });
    });
  }
}
