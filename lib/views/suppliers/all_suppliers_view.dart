import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/supplier.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/view_model/suppliers/all_suppliers_view_model.dart';
import 'package:printing_press/views/suppliers/supplier_details_view.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import '../../components/custom_circular_indicator.dart';

class AllSuppliersView extends StatefulWidget {
  const AllSuppliersView({super.key});

  @override
  State<AllSuppliersView> createState() => _AllSuppliersViewState();
}

class _AllSuppliersViewState extends State<AllSuppliersView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AllSuppliersViewModel>(
      builder: (context, value, child) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: value.getSuppliersData(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomCircularIndicator();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              value.allSuppliersModel = snapshot.data!.docs
                  .map((e) => Supplier.fromJson(e.data()))
                  .toList();
              if (value.allSuppliersModel.isEmpty) {
                return const Center(
                  child: Text('No suppliers found!'),
                );
              }
              return ListView.builder(
                itemCount: value.allSuppliersModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SupplierDetailsView(
                              supplierId:
                                  value.allSuppliersModel[index].supplierId)));
                    },
                    child: Card(
                      elevation: 1.5,
                      color: Color(0xffcad6d2).withOpacity(0.5),
                      shadowColor: Color(0xff4ab894).withOpacity(0.2),
                      margin: EdgeInsets.only(bottom: 10, top: 5),
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
                                      value.allSuppliersModel[index]
                                          .supplierName,
                                      18),
                                  SizedBox(height: 4),
                                  kTitleText(
                                      value.allSuppliersModel[index]
                                          .supplierPhoneNo,
                                      14,
                                      kNew5)
                                ],
                              ),
                              // kThirdColor.withOpacity(0.8)
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Bill', style: kDescriptionTextStyle),
                                  SizedBox(height: 4),
                                  kTitleText(
                                      'Rs. ${value.allSuppliersModel[index].amountRemaining}',
                                      null,
                                      kNew8,
                                      2)
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            IconButton(
                              icon: Icon(Icons.delete, color: kNew4),
                              onPressed: () {
                                /// todo:
                              },
                            ),
                            SizedBox(width: 5)
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
      },
    );
  }
}
