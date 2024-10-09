import 'package:flutter/material.dart';
import 'package:printing_press/views/rate_list/paper/add_paper_view.dart';
import 'package:provider/provider.dart';

import '../../../colors/color_palette.dart';
import '../../../view_model/rate_list/paper/paper_view_model.dart';

class PaperView extends StatefulWidget {
  const PaperView({super.key});

  @override
  State<PaperView> createState() => _PaperViewState();
}

class _PaperViewState extends State<PaperView> {
  late PaperViewModel paperViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paperViewModel = Provider.of<PaperViewModel>(context, listen: false);
    paperViewModel.fetchPaperData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddPaperView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('Paper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PaperViewModel>(
          builder: (context, value, child) => value.dataFetched
              ? value.paperList.isEmpty
                  ? const Center(
                      child: Text('No record found!'),
                    )

                  ///todo: change listview.builder to streams builder or future builder
                  : ListView.builder(
                      itemCount: value.paperList.length,
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
                          title: Text(value.paperList[index].name),
                          tileColor: kTwo,
                          subtitleTextStyle: const TextStyle(
                              color: Colors.black, fontStyle: FontStyle.italic),
                          subtitle: Text(
                            'Size: ${value.paperList[index].size.width}x${value.paperList[index].size.height}\nQuality:${value.paperList[index].quality} Rate:${value.paperList[index].rate}',
                          ),
                          leading:
                              Text(value.paperList[index].paperId.toString()),
                        );
                      },
                    )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
