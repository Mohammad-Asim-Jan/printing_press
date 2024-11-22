import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/supplier.dart';
import 'package:printing_press/view_model/suppliers/all_suppliers_view_model.dart';
import 'package:printing_press/views/suppliers/supplier_orders_history_view.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import 'add_supplier_view.dart';

class AllSuppliersView extends StatefulWidget {
  const AllSuppliersView({super.key});

  @override
  State<AllSuppliersView> createState() => _AllSuppliersViewState();
}

class _AllSuppliersViewState extends State<AllSuppliersView> {
  late AllSuppliersViewModel allSuppliersViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allSuppliersViewModel =
        Provider.of<AllSuppliersViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AllSuppliersViewModel>(
        builder: (context, value, child) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: value.getSuppliersData(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                value.allSuppliersModel = snapshot.data!.docs.skip(1).map(
                  (e) {
                    return Supplier.fromJson(e.data());
                  },
                ).toList();
                if (value.allSuppliersModel.isEmpty) {
                  return const Center(
                    child: Text('No suppliers found!'),
                  );
                }
                return ListView.builder(
                  itemCount: value.allSuppliersModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    /// todo: change the list tile to custom design
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SupplierOrdersHistoryView(
                              supplierId:
                                  value.allSuppliersModel[index].supplierId,
                              totalAmount:
                                  value.allSuppliersModel[index].totalAmount,
                              remainingAmount: value
                                  .allSuppliersModel[index].amountRemaining,
                              paidAmount: value
                                  .allSuppliersModel[index].totalPaidAmount,
                            ),
                          ),
                        );
                      },
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
                      title: Text(value.allSuppliersModel[index].supplierName),
                      tileColor: kTwo,
                      subtitleTextStyle: const TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                      subtitle: Text(
                        'Phone No: ${value.allSuppliersModel[index].supplierPhoneNo}\nAddress: ${value.allSuppliersModel[index].supplierAddress}}',
                      ),
                      leading: Text(
                          value.allSuppliersModel[index].supplierId.toString()),
                    );
                  },
                );
              }
              return const Text('No data!');
            },
          );
        },
      ),
    );
  }
}
