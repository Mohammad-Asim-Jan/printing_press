import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/rate_list/machine.dart';
import 'package:printing_press/view_model/rate_list/machine/machine_view_model.dart';
import 'package:printing_press/views/rate_list/machine/add_machine_view.dart';
import 'package:provider/provider.dart';

import '../../../colors/color_palette.dart';

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddMachineView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('Machine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<MachineViewModel>(builder: (context, value, child) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: value.getMachinesData(),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                value.machineList = snapshot.data!.docs.skip(1).map((e) {
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
                    /// todo: change the list tile to custom design
                    return ListTile(
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      shape: Border.all(width: 2, color: kPrimeColor),
                      // titleAlignment: ListTileTitleAlignment.threeLine,
                      titleTextStyle: TextStyle(
                          color: kThirdColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      title: Text(value.machineList[index].name),
                      tileColor: kTwo,
                      subtitleTextStyle: const TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                      subtitle: Text(
                        'Size: ${value.machineList[index].size.width}x${value.machineList[index].size.height}\nPlateRate:${value.machineList[index].plateRate} PrintingRate:${value.machineList[index].printingRate}',
                      ),
                      leading:
                          Text(value.machineList[index].machineId.toString()),
                    );
                  },
                );
              }

              return const Text('No data!');
            },
          );
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
        }),
      ),
    );
  }
}
