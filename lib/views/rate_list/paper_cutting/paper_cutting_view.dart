import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/paper_cutting.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/paper_cutting/paper_cutting_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_circular_indicator.dart';

class PaperCuttingView extends StatefulWidget {
  const PaperCuttingView({super.key});

  @override
  State<PaperCuttingView> createState() => _PaperCuttingViewState();
}

class _PaperCuttingViewState extends State<PaperCuttingView> {
  late PaperCuttingViewModel paperCuttingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paperCuttingViewModel =
        Provider.of<PaperCuttingViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaperCuttingViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: value.getPaperCuttingData(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomCircularIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            value.paperCuttingList = snapshot.data!.docs.map((e) {
              return PaperCutting.fromJson(e.data());
            }).toList();
            if (value.paperCuttingList.isEmpty) {
              return const Center(child: Text('No paper cutting found!'));
            }
            return ListView.builder(
              itemCount: value.paperCuttingList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 1.5,
                  shadowColor: Colors.blue.withOpacity(0.3),
                  color: kSecColor,
                  margin:
                      EdgeInsets.only(bottom: 10, top: 5, right: 10, left: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Expanded(
                        //   flex: 4,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'ID',
                        //         style: TextStyle(
                        //           fontFamily: 'Iowan',
                        //           color: kNew9a,
                        //         ),
                        //       ),
                        //       SizedBox(height: 4),
                        //       Text(
                        //         '${value.paperCuttingList[index].paperCuttingId}',
                        //         maxLines: 1,
                        //         style: TextStyle(
                        //           overflow: TextOverflow.ellipsis,
                        //           color: kThirdColor,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name', style: kDescriptionTextStyle),
                              SizedBox(height: 4),
                              kTitleText(value.paperCuttingList[index].name)
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rate', style: kDescriptionTextStyle),
                              SizedBox(height: 4),
                              kDescriptionText(
                                  'Rs. ${value.paperCuttingList[index].rate}')
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
                                    value.editPaperCutting(context, index),
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
//           onPressed: () => value.editPaperCutting(context, index),
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
//   title: Text(value.paperCuttingList[index].name),
//   tileColor: kTwo,
//   subtitleTextStyle: const TextStyle(
//       color: Colors.black, fontStyle: FontStyle.italic),
//   subtitle: Text(
//     'Rate: ${value.paperCuttingList[index].rate}',
//   ),
//   leading: Text(value
//       .paperCuttingList[index].paperCuttingId
//       .toString()),
// );

// value.dataFetched
//     ? value.paperCuttingList.isEmpty
//     ? const Center(
//   child: Text('No record found!'),
// )
//
//     : ListView.builder(
//   itemCount: value.paperCuttingList.length,
//   itemBuilder: (BuildContext context, int index) {
//     return ListTile(
//       trailing: SizedBox(
//         width: 100,
//         child: Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//       shape: Border.all(width: 2, color: kPrimeColor),
//       // titleAlignment: ListTileTitleAlignment.threeLine,
//       titleTextStyle: TextStyle(
//           color: kThirdColor,
//           fontSize: 18,
//           fontWeight: FontWeight.w500),
//       title: Text(value.paperCuttingList[index].name),
//       tileColor: kTwo,
//       subtitleTextStyle: const TextStyle(
//           color: Colors.black, fontStyle: FontStyle.italic),
//       subtitle: Text(
//         'Rate: ${value.paperCuttingList[index].rate}',
//       ),
//       leading: Text(value
//           .paperCuttingList[index].paperCuttingId
//           .toString()),
//     );
//   },
// )
//     : const Center(child: CircularProgressIndicator())
// ,
