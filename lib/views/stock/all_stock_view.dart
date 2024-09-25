import 'package:flutter/material.dart';
import 'package:printing_press/view_model/stock/all_stock_view_model.dart';
import 'package:printing_press/views/stock/add_stock_view.dart';
import 'package:provider/provider.dart';

import '../../colors/color_palette.dart';

class AllStockView extends StatefulWidget {
  const AllStockView({super.key});

  @override
  State<AllStockView> createState() => _AllStockViewState();
}

class _AllStockViewState extends State<AllStockView> {
  late AllStockViewModel allStockViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allStockViewModel = Provider.of<AllStockViewModel>(context, listen: false);
    allStockViewModel.fetchAllStockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddStockView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('All Stock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AllStockViewModel>(
          builder: (context, value, child) => value.dataFetched
              ? value.allStockList.isEmpty
                  ? const Center(
                      child: Text('No record found!'),
                    )

                  ///todo: change listview.builder to streams builder or future builder
                  : ListView.builder(
                      itemCount: value.allStockList.length,
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
                          title: Text(value.allStockList[index].stockName),
                          tileColor: kTwo,
                          subtitleTextStyle: const TextStyle(
                              color: Colors.black, fontStyle: FontStyle.italic),
                          subtitle: Text(
                            'Category: ${value.allStockList[index].stockCategory}\nColor: ${value.allStockList[index].stockColor}}',
                          ),
                          leading: Text(
                              value.allStockList[index].stockId.toString()),
                        );
                      },
                    )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
// const Center(child: Text('No stock Found')),
