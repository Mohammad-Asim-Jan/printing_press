import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_circular_indicator.dart';
import 'package:printing_press/model/stock.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/utils/toast_message.dart';
import 'package:printing_press/view_model/stock/all_stock_view_model.dart';
import 'package:printing_press/views/stock/stock_details_view.dart';
import 'package:provider/provider.dart';

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
    return Consumer<AllStockViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: value.getStocksData(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomCircularIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            value.stockList = snapshot.data!.docs.map(
              (e) {
                return Stock.fromJson(e.data());
              },
            ).toList();
            if (value.stockList.isEmpty) {
              return const Center(
                child: Text('No stock found!'),
              );
            }
            return ListView.builder(
              itemCount: value.stockList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    await value.isSupplierAvailable(index).then(
                      (val) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return StockDetailsView(
                              stockId: value.stockList[index].stockId,
                              isSupplierExist: val);
                        }));
                      },
                    ).onError((error, stackTrace) {
                      Utils.showMessage('Try Again!');
                    });
                  },
                  child: Card(
                    elevation: 1.5,
                    color: kNew1a,
                    shadowColor: Colors.green.withOpacity(0.3),
                    margin: EdgeInsets.only(
                        bottom: 10, top: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(width: 5),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kTitleText(
                                    value.stockList[index].stockName, 18),
                                SizedBox(height: 8),
                                kTitleText(value.stockList[index].stockCategory,
                                    15, kNew2),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rate', style: kDescriptionTextStyle),
                                SizedBox(height: 4),
                                kTitleText(
                                    'Rs. ${value.stockList[index].stockUnitSellPrice}',
                                    null,
                                    kOne)
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Text(
                                  'Available',
                                  style: kDescriptionTextStyle,
                                ),
                                SizedBox(height: 4),
                                kTitleText(
                                    value.stockList[index].availableStock
                                        .toString(),
                                    null,
                                    value.stockList[index].availableStock < 10
                                        ? kNew8
                                        : kNew4)
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Text('No data!');
        },
      );
    });
  }
}

// return Column(
//   children: [
//     ListTile(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) {
//             return StockDetailsView(
//                 stock: value.allStockList[index]);
//           },
//         ));
//       },
//       trailing: Text(
//           value.allStockList[index].stockQuantity.toString()),
//       shape: Border.all(width: 2, color: kPrimeColor),
//       // titleAlignment: ListTileTitleAlignment.threeLine,
//       titleTextStyle: TextStyle(
//           color: kThirdColor,
//           fontSize: 18,
//           fontWeight: FontWeight.w500),
//       title: Text(value.allStockList[index].stockName),
//       tileColor: kTwo,
//       subtitleTextStyle: const TextStyle(
//           color: Colors.black, fontStyle: FontStyle.italic),
//       subtitle: Text(
//         'Category: ${value.allStockList[index].stockCategory}\nColor: ${value.allStockList[index].stockColor}',
//       ),
//       leading:
//           Text(value.allStockList[index].stockId.toString()),
//     ),
//     TextButton(
//         onPressed: () {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => StockHistoryView(
//               stockId: value.allStockList[index].stockId,
//               availableStock:
//                   value.allStockList[index].availableStock,
//               stockName: value.allStockList[index].stockName,
//               stockQuantity:
//                   value.allStockList[index].stockQuantity,
//             ),
//           ));
//         },
//         child: const Text('History'))
//   ],
// );
// const Center(child: Text('No stock Found')),
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
