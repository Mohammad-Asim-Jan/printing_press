import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/view_model/suppliers/add_supplier_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/round_button.dart';
import '../../utils/validation_functions.dart';

class AddSupplierView extends StatefulWidget {
  const AddSupplierView({super.key});

  @override
  State<AddSupplierView> createState() => _AddSupplierViewState();
}

class _AddSupplierViewState extends State<AddSupplierView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AddSupplierViewModel addSupplierViewModel =
        Provider.of<AddSupplierViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Supplier'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: addSupplierViewModel.formKey,
                  child: Column(
                    children: [
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val1, child) {
                          return CustomTextField(
                            controller: val1.supplierNameC,
                            iconData: Icons.person,
                            hint: 'Supplier name',
                            validators: const [isNotEmpty],
                          );
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val2, child) {
                          return CustomTextField(
                            maxLength: 11,
                            textInputType: TextInputType.number,
                            inputFormatter:
                                FilteringTextInputFormatter.digitsOnly,
                            controller: val2.supplierPhoneNoC,
                            iconData: Icons.call,
                            hint: 'Supplier phone',
                            validators: const [isNotEmpty],
                          );
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val3, child) {
                          return CustomTextField(
                            controller: val3.supplierEmailC,
                            textInputType: TextInputType.emailAddress,
                            iconData: Icons.email,
                            hint: 'Supplier email',
                            validators: const [isNotEmpty, isEmailValid],
                          );
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val4, child) {
                          return CustomTextField(
                            controller: val4.supplierAddressC,
                            iconData: Icons.home_filled,
                            hint: 'Supplier address',
                            validators: const [isNotEmpty],
                          );
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val5, child) {
                          return CustomTextField(
                            controller: val5.accountTypeC,
                            iconData: Icons.account_balance_rounded,
                            hint: 'Supplier bank type',
                            validators: const [isNotEmpty],
                          );
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val6, child) {
                          return CustomTextField(
                            controller: val6.bankAccountNumberC,
                            iconData: Icons.numbers,
                            hint: 'Supplier Account no.',
                            validators: const [isNotEmpty],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Consumer<AddSupplierViewModel>(
            builder: (context, value, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundButton(
                title: 'Add',
                loading: value.loading,
                onPress: () {
                  value.addSupplierInFirebase();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
