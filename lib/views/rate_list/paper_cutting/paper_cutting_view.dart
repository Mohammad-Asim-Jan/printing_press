import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/paper_cutting.dart';
import 'package:printing_press/view_model/rate_list/paper_cutting/paper_cutting_view_model.dart';
import 'package:printing_press/views/rate_list/paper_cutting/add_paper_cutting_view.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddPaperCuttingView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('Paper Cutting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PaperCuttingViewModel>(
          builder: (context, value, child) {

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: value.getPaperCuttingData(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  value.paperCuttingList = snapshot.data!.docs.skip(1).map((e) {
                    return PaperCutting.fromJson(e.data());
                  }).toList();
                  if (value.paperCuttingList.isEmpty) {
                    return const Center(child: Text('No paper cutting found!'));
                  }
                  return ListView.builder(
                    itemCount: value.paperCuttingList.length,
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
                        title: Text(value.paperCuttingList[index].name),
                        tileColor: kTwo,
                        subtitleTextStyle: const TextStyle(
                            color: Colors.black, fontStyle: FontStyle.italic),
                        subtitle: Text(
                          'Rate: ${value.paperCuttingList[index].rate}',
                        ),
                        leading: Text(value
                            .paperCuttingList[index].paperCuttingId
                            .toString()),
                      );
                    },
                  );
                }
                return const Text('No data!');
              },
            );
            // value.dataFetched
            //     ? value.paperCuttingList.isEmpty
            //     ? const Center(
            //   child: Text('No record found!'),
            // )
            //
            // ///todo: change listview.builder to streams builder or future builder
            //     : ListView.builder(
            //   itemCount: value.paperCuttingList.length,
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

          }
        ),
      ),
    );
  }
}
