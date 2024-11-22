import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/rate_list/profit.dart';
import 'package:printing_press/view_model/rate_list/profit/profit_view_model.dart';
import 'package:printing_press/views/rate_list/profit/add_profit_view.dart';
import 'package:provider/provider.dart';

import '../../../colors/color_palette.dart';

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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            value.profitList = snapshot.data!.docs.skip(1).map((e) {
              return Profit.fromJson(e.data());
            }).toList();
            if (value.profitList.isEmpty) {
              return const Center(child: Text('No profit found!'));
            }
            return ListView.builder(
              itemCount: value.profitList.length,
              itemBuilder: (BuildContext context, int index) {
                /// todo: change the list tile to custom design
                return ListTile(
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => value.editProfit(context, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => value.confirmDelete(context, index),
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
                  title: Text(value.profitList[index].name),
                  tileColor: kTwo,
                  subtitleTextStyle: const TextStyle(
                      color: Colors.black, fontStyle: FontStyle.italic),
                  subtitle: Text(
                    'Percentage: ${value.profitList[index].percentage}',
                  ),
                  leading: Text(value.profitList[index].profitId.toString()),
                );
              },
            );
          }
          return const Text('No data!');
        },
      );
      // value.dataFetched
      //     ? value.profitList.isEmpty
      //         ? const Center(
      //             child: Text('No record found!'),
      //           )
      //
      //         ///todo: change listview.builder to streams builder or future builder
      //         : ListView.builder(
      //             itemCount: value.profitList.length,
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
      //                 shape:
      //                     Border.all(width: 2, color: kPrimeColor),
      //                 // titleAlignment: ListTileTitleAlignment.threeLine,
      //                 titleTextStyle: TextStyle(
      //                     color: kThirdColor,
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.w500),
      //                 title: Text(value.profitList[index].name),
      //                 tileColor: kTwo,
      //                 subtitleTextStyle: const TextStyle(
      //                     color: Colors.black,
      //                     fontStyle: FontStyle.italic),
      //                 subtitle: Text(
      //                   'Percentage: ${value.profitList[index].percentage}',
      //                 ),
      //                 leading: Text(value.profitList[index].profitId
      //                     .toString()),
      //               );
      //             },
      //           )
      //     : const Center(child: CircularProgressIndicator()),
    });
  }
}
