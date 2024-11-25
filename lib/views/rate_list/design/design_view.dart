import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/design.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/design/design_view_model.dart';
import 'package:printing_press/views/rate_list/design/add_design_view.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_circular_indicator.dart';

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
                        //       Text('${value.designList[index].designId}',
                        //           maxLines: 1,
                        //           style: TextStyle(
                        //               overflow: TextOverflow.ellipsis,
                        //               color: kThirdColor,
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w500))
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
                              kTitleText(value.designList[index].name),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        // Spacer(),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rate', style: kDescriptionTextStyle),
                              SizedBox(height: 4),
                              kDescriptionText(
                                  'Rs. ${value.designList[index].rate}')
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
                                  child: Icon(Icons.edit, color: kNew4)),
                              GestureDetector(
                                  child: Icon(Icons.delete, color: kNew4),
                                  onTap: () =>
                                      value.confirmDelete(context, index))
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
// ListTile(
//   trailing: SizedBox(
//     width: 100,
//     child: Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: () => value.editDesign(context, index),
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
//   title: Text(value.designList[index].name),
//   tileColor: kTwo,
//   subtitleTextStyle: const TextStyle(
//       color: Colors.black, fontStyle: FontStyle.italic),
//   subtitle: Text(
//     'Rate: ${value.designList[index].rate}',
//   ),
//   leading: Text(value.designList[index].designId.toString()),
// );

// value.dataFetched
//     ? value.designList.isEmpty
//         ? const Center(
//             child: Text('No record found!'),
//           )
//
//         : ListView.builder(
//             itemCount: value.designList.length,
//             itemBuilder: (BuildContext context, int index) {
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
//                 shape:
//                     Border.all(width: 2, color: kPrimeColor),
//                 // titleAlignment: ListTileTitleAlignment.threeLine,
//                 titleTextStyle: TextStyle(
//                     color: kThirdColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500),
//                 title: Text(value.designList[index].name),
//                 tileColor: kTwo,
//                 subtitleTextStyle: const TextStyle(
//                     color: Colors.black,
//                     fontStyle: FontStyle.italic),
//                 subtitle: Text(
//                   'Rate: ${value.designList[index].rate}',
//                 ),
//                 leading: Text(value.designList[index].designId
//                     .toString()),
//               );
//             },
//           )
//     : const Center(child: CircularProgressIndicator()),
