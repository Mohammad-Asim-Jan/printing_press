import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/stock.dart';
import 'package:printing_press/view_model/stock/all_stock_view_model.dart';
import 'package:printing_press/views/stock/add_stock_view.dart';
import 'package:printing_press/views/stock/stock_details_view.dart';
import 'package:printing_press/views/stock/stock_history_view.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AllStockViewModel>(builder: (context, value, child) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: value.getStocksData(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              value.allStockList = snapshot.data!.docs.map(
                (e) {
                  return Stock.fromJson(e.data());
                },
              ).toList();
              if (value.allStockList.isEmpty) {
                return const Center(
                  child: Text('No stock found!'),
                );
              }
              return ListView.builder(
                itemCount: value.allStockList.length,
                itemBuilder: (BuildContext context, int index) {
                  /// todo: change the list tile to custom design
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return StockDetailsView(
                                  stock: value.allStockList[index]);
                            },
                          ));
                        },
                        trailing: Text(
                            value.allStockList[index].stockQuantity.toString()),
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
                          'Category: ${value.allStockList[index].stockCategory}\nColor: ${value.allStockList[index].stockColor}',
                        ),
                        leading:
                            Text(value.allStockList[index].stockId.toString()),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StockHistoryView(
                                stockId: value.allStockList[index].stockId,
                                availableStock:
                                    value.allStockList[index].availableStock,
                                stockName: value.allStockList[index].stockName,
                                stockQuantity:
                                    value.allStockList[index].stockQuantity,
                              ),
                            ));
                          },
                          child: const Text('History'))
                    ],
                  );
                },
              );
            }

            return const Text('No data!');
          },
        );
        // return
        //   value.dataFetched
        //       ? value.allStockList.isEmpty
        //       ? const Center(
        //     child: Text('No record found!'),
        //   )
        //
        //   ///todo: change listview.builder to streams builder or future builder
        //       : ListView.builder(
        //     itemCount: value.allStockList.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       /// todo: change the list tile to custom design
        //       return ListTile(
        //         onTap: () {
        //           Navigator.of(context)
        //               .push(MaterialPageRoute(
        //             builder: (context) {
        //               return StockDetailsView(
        //                   stock: value.allStockList[index]);
        //             },
        //           ));
        //         },
        //         trailing: Text(value
        //             .allStockList[index].stockQuantity
        //             .toString()),
        //         shape:
        //         Border.all(width: 2, color: kPrimeColor),
        //         // titleAlignment: ListTileTitleAlignment.threeLine,
        //         titleTextStyle: TextStyle(
        //             color: kThirdColor,
        //             fontSize: 18,
        //             fontWeight: FontWeight.w500),
        //         title:
        //         Text(value.allStockList[index].stockName),
        //         tileColor: kTwo,
        //         subtitleTextStyle: const TextStyle(
        //             color: Colors.black,
        //             fontStyle: FontStyle.italic),
        //         subtitle: Text(
        //           'Category: ${value.allStockList[index]
        //               .stockCategory}\nColor: ${value.allStockList[index]
        //               .stockColor}',
        //         ),
        //         leading: Text(value
        //             .allStockList[index].stockId
        //             .toString()),
        //       );
        //     },
        //   )
        //       : const Center(child: CircularProgressIndicator())
        // ,
      }),
    );
  }
}
// const Center(child: Text('No stock Found')),
