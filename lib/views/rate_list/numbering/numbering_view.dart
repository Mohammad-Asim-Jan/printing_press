import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/numbering.dart';
import 'package:printing_press/view_model/rate_list/numbering/numbering_view_model.dart';
import 'package:printing_press/views/rate_list/numbering/add_numbering_view.dart';
import 'package:provider/provider.dart';

class NumberingView extends StatefulWidget {
  const NumberingView({super.key});

  @override
  State<NumberingView> createState() => _NumberingViewState();
}

class _NumberingViewState extends State<NumberingView> {
  late NumberingViewModel numberingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberingViewModel =
        Provider.of<NumberingViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddNumberingView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('Numbering'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NumberingViewModel>(builder: (context, value, child) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: value.getNumberingsData(),
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
                  value.numberingList = snapshot.data!.docs.skip(1).map((e) {
                    return Numbering.fromJson(e.data());
                  }).toList();
                  if (value.numberingList.isEmpty) {
                    return const Center(child: Text('No numbering found!'));
                  }

                  return ListView.builder(
                    itemCount: value.numberingList.length,
                    itemBuilder: (BuildContext context, int index) {
                      /// todo: change the list tile to custom design
                      return ListTile(
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => value.editNumbering(context, index),
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
                        title: Text(value.numberingList[index].name),
                        tileColor: kTwo,
                        subtitleTextStyle: const TextStyle(
                            color: Colors.black, fontStyle: FontStyle.italic),
                        subtitle: Text(
                          'Rate: ${value.numberingList[index].rate}',
                        ),
                        leading: Text(
                            value.numberingList[index].numberingId.toString()),
                      );
                    },
                  );
                }
                return const Text('No data!');
              });

          // value.dataFetched
          //     ? value.numberingList.isEmpty
          //     ? const Center(
          //   child: Text('No record found!'),
          // )
          //
          // ///todo: change listview.builder to streams builder or future builder
          //     : ListView.builder(
          //   itemCount: value.numberingList.length,
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
          //       title: Text(value.numberingList[index].name),
          //       tileColor: kTwo,
          //       subtitleTextStyle: const TextStyle(
          //           color: Colors.black, fontStyle: FontStyle.italic),
          //       subtitle: Text(
          //         'Rate: ${value.numberingList[index].rate}',
          //       ),
          //       leading: Text(value.numberingList[index].numberingId
          //           .toString()),
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
