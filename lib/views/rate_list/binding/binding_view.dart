import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/model/rate_list/binding.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/rate_list/binding/binding_view_model.dart';
import 'package:provider/provider.dart';
import '../../../components/custom_circular_indicator.dart';

class BindingView extends StatefulWidget {
  const BindingView({super.key});

  @override
  State<BindingView> createState() => _BindingViewState();
}

class _BindingViewState extends State<BindingView> {
  late BindingViewModel bindingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bindingViewModel = Provider.of<BindingViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BindingViewModel>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: value.getBindingsData(),
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
            value.bindingList = snapshot.data!.docs.map(
              (e) {
                return Binding.fromJson(e.data());
              },
            ).toList();
            if (value.bindingList.isEmpty) {
              return const Center(
                child: Text('No binding found!'),
              );
            }

            return ListView.builder(
              itemCount: value.bindingList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 1.5,
                  color: kSecColor,
                  shadowColor: Colors.blue.withOpacity(0.3),
                  margin:
                      EdgeInsets.only(bottom: 10, top: 5, right: 10, left: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Expanded(
                        //   flex: 4,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'ID',
                        //         style:kDescriptionTextStyle,
                        //       ),
                        //       SizedBox(height: 4),
                        //       Text(
                        //         '${value.bindingList[index].bindingId}',
                        //         maxLines: 1,
                        //         style: TextStyle(
                        //           overflow: TextOverflow.ellipsis,
                        //           color: kThirdColor,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: kDescriptionTextStyle,
                              ),
                              SizedBox(height: 4),
                              kTitleText(value.bindingList[index].name),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rate',
                                style: kDescriptionTextStyle,
                              ),
                              SizedBox(height: 4),
                              kDescriptionText(
                                  'Rs. ${value.bindingList[index].rate}')
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => value.editBinding(context, index),
                                child: Icon(Icons.edit, color: kNew4),
                              ),
                              GestureDetector(
                                  child: Icon(Icons.delete, color: kNew4),
                                  onTap: () =>
                                      value.confirmDelete(context, index)),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
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

// ListTile(
//   trailing: SizedBox(
//     width: 100,
//     child: Row(
//       children: [
//         IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () =>
//                 value.editBinding(context, index)),
//         IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () =>
//                 value.confirmDelete(context, index)),
//       ],
//     ),
//   ),
//   shape: Border.all(width: 2, color: kPrimeColor),
//   // titleAlignment: ListTileTitleAlignment.threeLine,
//   titleTextStyle: TextStyle(
//       color: kThirdColor,
//       fontSize: 18,
//       fontWeight: FontWeight.w500),
//   title: Text(value.bindingList[index].name),
//   tileColor: kTwo,
//   subtitleTextStyle: const TextStyle(
//       color: Colors.black, fontStyle: FontStyle.italic),
//   subtitle: Text(
//     'Rate: ${value.bindingList[index].rate}',
//   ),
//   leading:
//       Text(value.bindingList[index].bindingId.toString()),
// );
// Scaffold(
// floatingActionButton: FloatingActionButton(
//   backgroundColor: kSecColor,
//   onPressed: () {
//     Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => const AddBindingView()));
//   },
//   child: Text(
//     'Add +',
//     style: TextStyle(color: kThirdColor),
//   ),
// ),

// appBar: AppBar(
//   title: const Text('Binding'),
// ),
//   body: ,
// )
// value.dataFetched
//     ? value.bindingList.isEmpty
//     ? const Center(
//   child: Text('No record found!'),
// )
//
// ///todo: change listview.builder to streams builder or future builder
//     : ListView.builder(
//   itemCount: value.bindingList.length,
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
//       title: Text(value.bindingList[index].name),
//       tileColor: kTwo,
//       subtitleTextStyle: const TextStyle(
//           color: Colors.black, fontStyle: FontStyle.italic),
//       subtitle: Text(
//         'Rate: ${value.bindingList[index].rate}',
//       ),
//       leading: Text(
//           value.bindingList[index].bindingId.toString()),
//     );
//   },
// )
//     : const Center(child: CircularProgressIndicator())
// ,
// ListTile(
//                   trailing: SizedBox(
//                     width: 100,
//                     child: Row(
//                       children: [
//                         IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () =>
//                                 value.editBinding(context, index)),
//                         IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () =>
//                                 value.confirmDelete(context, index)),
//                       ],
//                     ),
//                   ),
//                   shape: Border.all(width: 2, color: kPrimeColor),
//                   // titleAlignment: ListTileTitleAlignment.threeLine,
//                   titleTextStyle: TextStyle(
//                       color: kThirdColor,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500),
//                   title: Text(value.bindingList[index].name),
//                   tileColor: kTwo,
//                   subtitleTextStyle: const TextStyle(
//                       color: Colors.black, fontStyle: FontStyle.italic),
//                   subtitle: Text(
//                     'Rate: ${value.bindingList[index].rate}',
//                   ),
//                   leading:
//                       Text(value.bindingList[index].bindingId.toString()),
//                 );
