import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/binding.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/delete_alert_dialogue.dart';
import 'package:printing_press/view_model/rate_list/binding/binding_view_model.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_circular_indicator.dart';

class BindingView extends StatefulWidget {
  const BindingView({super.key});

  @override
  State<BindingView> createState() => _BindingViewState();
}

class _BindingViewState extends State<BindingView> {
  late BindingViewModel bindingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bindingViewModel = Provider.of<BindingViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BindingViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: value.getBindingsData(),
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
            value.bindingList = snapshot.data!.docs.map(
              (e) {
                return Binding.fromJson(e.data());
              },
            ).toList();
            if (value.bindingList.isEmpty) {
              return const Center(
                child: Text('No binding found!'),
              );
            }

            return ListView.builder(
              itemCount: value.bindingList.length,
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
                              kTitleText(value.bindingList[index].name, 14),
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
                                  'Rs. ${value.bindingList[index].rate}', 14)
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
                                onTap: () => value.editBinding(context, index),
                                child: Icon(
                                  Icons.edit,
                                  color: kNew4,
                                  size: 20,
                                ),
                              ),
                              GestureDetector(
                                  child: Icon(
                                    Icons.delete,
                                    color: kNew4,
                                    size: 20,
                                  ),
                                  onTap: () =>
                                      DeleteAlertDialogue.confirmDelete(context,
                                          () {
                                        value.deleteBinding(
                                            value.bindingList[index].bindingId);
                                        Navigator.pop(context);
                                      })),
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
        },
      );
    });
  }
}
