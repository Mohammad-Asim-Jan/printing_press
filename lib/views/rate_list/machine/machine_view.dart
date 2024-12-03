import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/rate_list/machine.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/machine/machine_view_model.dart';
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
                        shadowColor: Colors.blue.withOpacity(0.1),
                        color: Colors.blue.withOpacity(.15),
                        margin: EdgeInsets.only(
                            bottom: 10, top: 5),
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
