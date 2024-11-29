import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/model/bank_account.dart';
import 'package:printing_press/view_model/suppliers/supplier_details_view_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_circular_indicator.dart';
import '../../text_styles/custom_text_styles.dart';

class SupplierBankAccountsView extends StatefulWidget {
  const SupplierBankAccountsView({super.key, required this.supplierId});

  final int supplierId;

  @override
  State<SupplierBankAccountsView> createState() =>
      _SupplierBankAccountsViewState();
}

class _SupplierBankAccountsViewState extends State<SupplierBankAccountsView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SupplierDetailsViewModel>(
      builder: (context, value, child) => StreamBuilder<
              DocumentSnapshot<Map<String, dynamic>>>(
          stream: value.getSupplierBankAccounts(widget.supplierId),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomCircularIndicator();
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              List bankAccounts = snapshot.data!.data()?['bankAccounts'];
              value.supplierBankAccounts =
                  bankAccounts.map((e) => BankAccount.fromJson(e)).toList();
              if (value.supplierBankAccounts.isEmpty) {
                return const Center(
                  child: Text('No entry found!'),
                );
              }

              return ListView.builder(
                  itemCount: value.supplierBankAccounts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Icon(Icons.account_balance_rounded,
                              color: Colors.blue.shade400),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                columnWidths: {
                                  0: FractionColumnWidth(0.5),
                                  1: FractionColumnWidth(0.5),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText('Account Type', 10,
                                            Colors.black.withOpacity(0.6), 2),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText('Account Number', 10,
                                            Colors.black.withOpacity(0.6), 2),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: kTitleText(
                                              value.supplierBankAccounts[index]
                                                  .accountType,
                                              12,
                                              null,
                                              2)),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: kTitleText(
                                            value.supplierBankAccounts[index]
                                                .bankAccountNumber,
                                            12,
                                            null,
                                            2),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            return const Text('No data!');
          }),
    );
  }
}
