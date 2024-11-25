import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/rate_list/machine.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/machine/machine_view_model.dart';
import 'package:printing_press/views/rate_list/machine/add_machine_view.dart';
import 'package:provider/provider.dart';

import '../../../colors/color_palette.dart';
import '../../../components/custom_circular_indicator.dart';

class MachineView extends StatefulWidget {
  const MachineView({super.key});

  @override
  State<MachineView> createState() => _MachineViewState();
}

class _MachineViewState extends State<MachineView> {
  late MachineViewModel machineViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    machineViewModel = Provider.of<MachineViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MachineViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: value.getMachinesData(),
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
              value.machineList = snapshot.data!.docs.map((e) {
                return Machine.fromJson(e.data());
              }).toList();
              if (value.machineList.isEmpty) {
                return const Center(
                  child: Text('No machine found!'),
                );
              }
              return ListView.builder(
                  itemCount: value.machineList.length,
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
                                    Text(
                                      'Name',
                                      style: kDescriptionTextStyle,
                                    ),
                                    SizedBox(height: 4),
                                    kTitleText(
                                        value.machineList[index].name),
                                    SizedBox(height: 8),
                                    Text('Size', style: kDescriptionTextStyle),
                                    SizedBox(height: 4),
                                    kDescription2Text(
                                        '${value.machineList[index].size.width} x ${value.machineList[index].size.height}'),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Plate Rate',
                                        style: kDescriptionTextStyle),
                                    SizedBox(height: 4),
                                    kDescriptionText(
                                        'Rs. ${value.machineList[index].plateRate}'),
                                    SizedBox(height: 8),
                                    Text(
                                      'Printing Rate',
                                      style: kDescriptionTextStyle
                                    ),
                                    SizedBox(height: 4),
                                    kDescriptionText(                                      'Rs. ${value.machineList[index].printingRate}'
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              value.editMachine(context, index),
                                          child: Icon(Icons.edit, color: kNew4),
                                        ),
                                        SizedBox(height: 30),
                                        GestureDetector(
                                            onTap: () => value.confirmDelete(
                                                context, index),
                                            child: Icon(Icons.delete,
                                                color: kNew4))
                                      ])),
                              SizedBox(width: 5),
                            ])));
                  });
            }
            return const Text('No data!');
          });
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
//           onPressed: () => value.editMachine(context, index),
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
//   title: Text(value.machineList[index].name),
//   tileColor: kTwo,
//   subtitleTextStyle: const TextStyle(
//       color: Colors.black, fontStyle: FontStyle.italic),
//   subtitle: Text(
//     'Size: ${value.machineList[index].size.width}x${value.machineList[index].size.height}\nPlateRate:${value.machineList[index].plateRate} PrintingRate:${value.machineList[index].printingRate}',
//   ),
//   leading: Text(value.machineList[index].machineId.toString()),
// );
///

// value.dataFetched
//     ? value.machineList.isEmpty
//     ? const Center(
//   child: Text('No record found!'),
// )
//
// ///todo: change listview.builder to streams builder or future builder
//     : ListView.builder(
//   itemCount: value.machineList.length,
//   itemBuilder: (BuildContext context, int index) {
//     /// todo: change the list tile to custom design
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
//       title: Text(value.machineList[index].name),
//       tileColor: kTwo,
//       subtitleTextStyle: const TextStyle(
//           color: Colors.black, fontStyle: FontStyle.italic),
//       subtitle: Text(
//         'Size: ${value.machineList[index].size.width}x${value
//             .machineList[index].size.height}\nPlateRate:${value
//             .machineList[index].plateRate} PrintingRate:${value
//             .machineList[index].printingRate}',
//       ),
//       leading: Text(
//           value.machineList[index].machineId.toString()),
//     );
//   },
// )
//     : const Center(child: CircularProgressIndicator())
// ,
