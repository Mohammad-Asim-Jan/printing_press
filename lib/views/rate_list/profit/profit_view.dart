import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/rate_list/profit.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/profit/profit_view_model.dart';
import 'package:provider/provider.dart';

import '../../../colors/color_palette.dart';
import '../../../components/custom_circular_indicator.dart';

class ProfitView extends StatefulWidget {
  const ProfitView({super.key});

  @override
  State<ProfitView> createState() => _ProfitViewState();
}

class _ProfitViewState extends State<ProfitView> {
  late ProfitViewModel profitViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profitViewModel = Provider.of<ProfitViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfitViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: value.getProfitData(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomCircularIndicator();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              value.profitList = snapshot.data!.docs.map((e) {
                return Profit.fromJson(e.data());
              }).toList();
              if (value.profitList.isEmpty) {
                return const Center(child: Text('No profit found!'));
              }
              return ListView.builder(
                itemCount: value.profitList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 1.5,
                    shadowColor: Colors.blue.withOpacity(0.1),
                    color: Colors.blue.withOpacity(.15),
                    margin: EdgeInsets.only(bottom: 10, top: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(width: 5),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kTitleText(value.profitList[index].name)
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Percentage',
                                    style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kDescriptionText(
                                    '${value.profitList[index].percentage} %')
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
                                  onTap: () => value.editProfit(context, index),
                                  child: Icon(Icons.edit, color: kNew4),
                                ),
                                GestureDetector(
                                    child: Icon(Icons.delete, color: kNew4),
                                    onTap: () =>
                                        value.confirmDelete(context, index)),
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