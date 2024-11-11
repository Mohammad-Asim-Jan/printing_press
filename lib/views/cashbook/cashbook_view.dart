import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/cashbook_entry.dart';
import 'package:printing_press/view_model/cashbook/cashbook_view_model.dart';
import 'package:printing_press/views/cashbook/add_cashbook_entry_view.dart';
import 'package:printing_press/views/cashbook/cashbook_entry_details_view.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';

class CashbookView extends StatefulWidget {
  const CashbookView({super.key});

  @override
  State<CashbookView> createState() => _CashbookViewState();
}

class _CashbookViewState extends State<CashbookView> {
  late CashbookViewModel cashbookViewModel;

  @override
  void initState() {
    // TODO: implement initState
    cashbookViewModel = Provider.of<CashbookViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddCashbookEntryView()));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('Cashbook'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<CashbookViewModel>(builder: (context, value, child) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: value.getCashbookData(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                value.allCashbookEntries = snapshot.data!.docs.map(
                  (e) {
                    return CashbookEntry.fromJson(e.data());
                  },
                ).toList();

                if (value.allCashbookEntries.isEmpty) {
                  return const Center(
                    child: Text('No entry found!'),
                  );
                }

                return ListView.builder(
                  itemCount: value.allCashbookEntries.length,
                  itemBuilder: (BuildContext context, int index) {
                    /// todo: change the list tile to custom design
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return CashbookEntryDetailsView(
                              cashbookEntry: value.allCashbookEntries[index],
                            );
                          },
                        ));
                      },
                      trailing: Text(value.allCashbookEntries[index].cashbookEntryId.toString()),
                      // SizedBox(
                      //   width: 100,
                      //   child: Row(
                      //     children: [
                      //       IconButton(
                      //         icon: const Icon(Icons.edit),
                      //         onPressed: () {},
                      //       ),
                      //       IconButton(
                      //         icon: const Icon(Icons.delete),
                      //         onPressed: () {},
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      shape: Border.all(width: 2, color: kPrimeColor),
                      // titleAlignment: ListTileTitleAlignment.threeLine,
                      titleTextStyle: TextStyle(
                          color: kThirdColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      title: Text(
                          value.allCashbookEntries[index].paymentType ?? '0'),
                      tileColor: kTwo,
                      subtitleTextStyle: const TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                      subtitle: Text(
                        'Method: ${value.allCashbookEntries[index].paymentMethod}\nDescription: ${value.allCashbookEntries[index].description}',
                      ),
                      leading: Text(
                          value.allCashbookEntries[index].amount.toString()),
                    );
                  },
                );
              }

              return const Text('No data!');
            },
          );
          // value.dataFetched
          //     ? value.allCashbookEntries.isEmpty
          //     ? const Center(
          //   child: Text('No record found!'),
          // )
          //
          // ///todo: change listview.builder to streams builder or future builder
          //     : ListView.builder(
          //   itemCount: value.allCashbookEntries.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     /// todo: change the list tile to custom design
          //     return ListTile(
          //       onTap: () {
          //         Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) {
          //             return CashbookEntryDetailsView(
          //               cashbookEntry:
          //               value.allCashbookEntries[index],
          //             );
          //           },
          //         ));
          //       },
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
          //       title: Text(
          //           value.allCashbookEntries[index].paymentType ??
          //               '0'),
          //       tileColor: kTwo,
          //       subtitleTextStyle: const TextStyle(
          //           color: Colors.black, fontStyle: FontStyle.italic),
          //       subtitle: Text(
          //         'Method: ${value.allCashbookEntries[index]
          //             .paymentMethod}\nDescription: ${value
          //             .allCashbookEntries[index].description}',
          //       ),
          //       leading: Text(value.allCashbookEntries[index].amount
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
