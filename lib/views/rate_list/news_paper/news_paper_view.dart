import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/news_paper/news_paper_view_model.dart';
import 'package:printing_press/views/rate_list/news_paper/add_news_paper_view.dart';
import 'package:provider/provider.dart';

import '../../../colors/color_palette.dart';
import '../../../components/custom_circular_indicator.dart';
import '../../../model/rate_list/paper.dart';

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
                    shadowColor: Colors.blue.withOpacity(0.3),
                    color: kSecColor,
                    margin: EdgeInsets.only(
                        bottom: 10, top: 5, right: 10, left: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(children: [
                          SizedBox(width: 5),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   children: [
                                //     Text(
                                //       'ID',
                                //       style: TextStyle(
                                //         fontSize: 14,
                                //         color: kNew9a,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     SizedBox(width: 4),
                                //     Text(
                                //       value.machineList[index].machineId
                                //           .toString(),
                                //       style: TextStyle(
                                //         fontSize: 16,
                                //         color: kThirdColor,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(height: 8),
                                Text('Name', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kTitleText(value.newsPaperList[index].name),
                                SizedBox(height: 8),
                                Text('Size', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kDescription2Text(
                                    '${value.newsPaperList[index].size.width} x ${value.newsPaperList[index].size.height}')
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quality', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kDescriptionText(
                                    '${value.newsPaperList[index].quality}'),
                                SizedBox(height: 8),
                                Text('Rate', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kDescriptionText(
                                    'Rs. ${value.newsPaperList[index].rate}')
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                              flex: 2,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          value.editNewsPaper(context, index),
                                      child: Icon(Icons.edit, color: kNew4),
                                    ),
                                    SizedBox(height: 30),
                                    GestureDetector(
                                        onTap: () =>
                                            value.confirmDelete(context, index),
                                        child: Icon(Icons.delete, color: kNew4))
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

// return ListTile(
//   trailing: SizedBox(
//     width: 100,
//     child: Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: () => value.editNewsPaper(context, index),
//         ),
//         IconButton(
//           icon: const Icon(Icons.delete),
//           onPressed: () => value.confirmDelete(context, index),
//         ),
//       ],
//     ),
//   ),
//   shape: Border.all(width: 2, color: kPrimeColor),
//   // titleAlignment: ListTileTitleAlignment.threeLine,
//   titleTextStyle: TextStyle(
//       color: kThirdColor,
//       fontSize: 18,
//       fontWeight: FontWeight.w500),
//   title: Text(value.newsPaperList[index].name),
//   tileColor: kTwo,
//   subtitleTextStyle: const TextStyle(
//       color: Colors.black, fontStyle: FontStyle.italic),
//   subtitle: Text(
//     'Size: ${value.newsPaperList[index].size.width}x${value.newsPaperList[index].size.height}\nQuality:${value.newsPaperList[index].quality} Rate:${value.newsPaperList[index].rate}',
//   ),
//   leading:
//   Text(value.newsPaperList[index].paperId.toString()),
// );
///
// value.dataFetched
//     ? value.newsPaperList.isEmpty
//         ? const Center(
//             child: Text('No record found!'),
//           )
//
//         ///todo: change listview.builder to streams builder or future builder
//         : ListView.builder(
//             itemCount: value.newsPaperList.length,
//             itemBuilder: (BuildContext context, int index) {
//               /// todo: change the list tile to custom design
//               return ListTile(
//                 trailing: SizedBox(
//                   width: 100,
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//                 ),
//                 shape: Border.all(width: 2, color: kPrimeColor),
//                 // titleAlignment: ListTileTitleAlignment.threeLine,
//                 titleTextStyle: TextStyle(
//                     color: kThirdColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500),
//                 title: Text(value.newsPaperList[index].name),
//                 tileColor: kTwo,
//                 subtitleTextStyle: const TextStyle(
//                     color: Colors.black, fontStyle: FontStyle.italic),
//                 subtitle: Text(
//                   'Size: ${value.newsPaperList[index].size.width}x${value.newsPaperList[index].size.height}\nQuality:${value.newsPaperList[index].quality} Rate:${value.newsPaperList[index].rate}',
//                 ),
//                 leading: Text(
//                     value.newsPaperList[index].paperId.toString()),
//               );
//             },
//           )
//     : const Center(child: CircularProgressIndicator()),
