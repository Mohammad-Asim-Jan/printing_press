import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/design.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/design/design_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_circular_indicator.dart';
import '../../../view_model/delete_alert_dialogue.dart';

class DesignView extends StatefulWidget {
  const DesignView({super.key});

  @override
  State<DesignView> createState() => _DesignViewState();
}

class _DesignViewState extends State<DesignView> {
  late DesignViewModel designViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    designViewModel = Provider.of<DesignViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DesignViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: value.getDesignsData(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomCircularIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            value.designList = snapshot.data!.docs.map(
              (e) {
                return Design.fromJson(e.data());
              },
            ).toList();
            if (value.designList.isEmpty) {
              return const Center(
                child: Text('No design found!'),
              );
            }
            return ListView.builder(
              itemCount: value.designList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 1.5,
                  shadowColor: Colors.blue.withOpacity(0.1),
                  color: Colors.blue.withOpacity(.15),
                  margin: EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                              kTitleText(value.designList[index].name, 14),
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
                                  'Rs. ${value.designList[index].rate}', 14)
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
                                  onTap: () => value.editDesign(context, index),
                                  child:
                                      Icon(Icons.edit, color: kNew4, size: 20)),
                              GestureDetector(
                                  child: Icon(Icons.delete,
                                      color: kNew4, size: 20),
                                  onTap: () =>
                                      DeleteAlertDialogue.confirmDelete(context,
                                          () {
                                        value.deleteDesign(
                                            value.designList[index].designId);
                                        Navigator.pop(context);
                                      }))
                            ],
                          ),
                        ),
                        SizedBox(width: 5)
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Text('No data!');
        },
      );
    });
  }
}
