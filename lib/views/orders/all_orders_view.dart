
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/views/orders/place_order_view.dart';

import '../../view_model/auth/sign_out.dart';

class AllOrdersView extends StatefulWidget {
  const AllOrdersView({super.key});

  @override
  State<AllOrdersView> createState() => _AllOrdersViewState();
}

class _AllOrdersViewState extends State<AllOrdersView> {
  bool data = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    debugPrint(auth.currentUser!.uid.toString());
    debugPrint(auth.currentUser!.email.toString());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const PlaceOrderView()));
        },
        child: Text('Add +', style: TextStyle(color: kThirdColor),),
      ),
      appBar: AppBar(
        title: const Text('All Orders'),
        actions: [
          IconButton(
            onPressed: () async {
              SignOut().signOut(context);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: data
          ? ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                  // margin: EdgeInsets.all(10),
                  color: kOne,
                  child: ListTile(
                    // enabled: true, true for all except cancelled
                    // tileColor: ,
                    isThreeLine: true,
                    onTap: () {
                      /// todo: goto that specific order along with the details
                    },
                    contentPadding: const EdgeInsets.all(5),
                    iconColor: kSecColor,
                    // minVerticalPadding: 1,
                    minLeadingWidth: 10,
                    horizontalTitleGap: 15,
                    leading: const Text(
                      '1',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.pending),
                    title: const Text('Business Title'),
                    subtitle: const Text(
                        'Click on it to get into more details, it will show you the descriptions about the order being placed'),
                  ),
                );
              })
          : const Center(child: Text('No Order Found')),
    );
  }
}

// Searching
// Filtering unpaid, incomplete orders

// Go to that specific order on click
// Receipt or invoice

// One or multiple orders

// Order number
// Customer name
// Product or services
// Total amount
// Amount paid
// remaining amount
