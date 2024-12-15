import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/news_paper/news_paper_view_model.dart';
import 'package:provider/provider.dart';

import '../../../colors/color_palette.dart';
import '../../../components/custom_circular_indicator.dart';
import '../../../model/rate_list/paper.dart';
import '../../../view_model/delete_alert_dialogue.dart';

class NewsPaperView extends StatefulWidget {
  const NewsPaperView({super.key});

  @override
  State<NewsPaperView> createState() => _NewsPaperViewState();
}

class _NewsPaperViewState extends State<NewsPaperView> {
  late NewsPaperViewModel newsPaperViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsPaperViewModel =
        Provider.of<NewsPaperViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsPaperViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: value.getNewspapersData(),
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
            value.newsPaperList = snapshot.data!.docs.map((e) {
              return Paper.fromJson(e.data());
            }).toList();
            if (value.newsPaperList.isEmpty) {
              return const Center(child: Text('No news paper found!'));
            }

            return ListView.builder(
              itemCount: value.newsPaperList.length,
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
                        child: Row(children: [
                          SizedBox(width: 5),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kTitleText(value.newsPaperList[index].name, 14),
                                SizedBox(height: 8),
                                Text('Size', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kDescriptionText(
                                    '${value.newsPaperList[index].size.width} x ${value.newsPaperList[index].size.height}',
                                    14)
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quality', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kDescriptionText(
                                    '${value.newsPaperList[index].quality}',
                                    14),
                                SizedBox(height: 8),
                                Text('Rate', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kDescriptionText(
                                    'Rs. ${value.newsPaperList[index].rate}',
                                    14)
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                GestureDetector(
                                  onTap: () =>
                                      value.editNewsPaper(context, index),
                                  child:
                                      Icon(Icons.edit, size: 20, color: kNew4),
                                ),
                                SizedBox(height: 30),
                                GestureDetector(
                                    onTap: () =>
                                        DeleteAlertDialogue.confirmDelete(
                                            context, () {
                                          value.deleteNewsPaper(value
                                              .newsPaperList[index].paperId);
                                          Navigator.pop(context);
                                        }),
                                    child: Icon(Icons.delete,
                                        size: 20, color: kNew4))
                              ])),
                          SizedBox(width: 5),
                        ])));
              },
            );
          }

          return const Text('No data!');
        },
      );
    });
  }
}
