import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/view_model/rate_list/news_paper/news_paper_view_model.dart';
import 'package:printing_press/views/rate_list/news_paper/add_news_paper_view.dart';
import 'package:provider/provider.dart';

import '../../../colors/color_palette.dart';
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddNewsPaperView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('News Paper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NewsPaperViewModel>(builder: (context, value, child) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: value.getNewspapersData(),
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
                value.newsPaperList = snapshot.data!.docs.skip(1).map((e) {
                  return Paper.fromJson(e.data());
                }).toList();
                if (value.newsPaperList.isEmpty) {
                  return const Center(child: Text('No news paper found!'));
                }

                return ListView.builder(
                  itemCount: value.newsPaperList.length,
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
                      title: Text(value.newsPaperList[index].name),
                      tileColor: kTwo,
                      subtitleTextStyle: const TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                      subtitle: Text(
                        'Size: ${value.newsPaperList[index].size.width}x${value.newsPaperList[index].size.height}\nQuality:${value.newsPaperList[index].quality} Rate:${value.newsPaperList[index].rate}',
                      ),
                      leading:
                          Text(value.newsPaperList[index].paperId.toString()),
                    );
                  },
                );
              }

              return const Text('No data!');
            },
          );

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
        }),
      ),
    );
  }
}
