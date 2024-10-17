import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/utils/email_validation.dart';
import 'package:printing_press/view_model/suppliers/add_supplier_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/round_button.dart';

class AddSupplierView extends StatefulWidget {
  const AddSupplierView({super.key});

  @override
  State<AddSupplierView> createState() => _AddSupplierViewState();
}

class _AddSupplierViewState extends State<AddSupplierView> {
  @override
  void initState() {
    // TODO: implement initState
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
                padding: const EdgeInsets.all(8.0),
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
                              validatorText: 'Provide supplier name');
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
                              validatorText: 'Provide supplier phone');
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val3, child) {
                          return TextFormField(
                            controller: val3.supplierEmailC,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: kPrimeColor,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                size: 24,
                              ),
                              hintText: 'Supplier email',
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: kPrimeColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: kSecColor,
                                ),
                              ),
                            ),
                            validator: (text) {
                              if (text == '' || text == null) {
                                return 'Provide supplier email';
                              } else if (!EmailValidation.isEmailValid(text)) {
                                return 'Invalid email';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val4, child) {
                          return CustomTextField(
                              controller: val4.supplierAddressC,
                              iconData: Icons.home_filled,
                              hint: 'Supplier address',
                              validatorText: 'Provide supplier address');
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val5, child) {
                          return CustomTextField(
                              controller: val5.accountTypeC,
                              iconData: Icons.account_balance_rounded,
                              hint: 'Supplier bank type',
                              validatorText: 'Provide supplier bank type');
                        },
                      ),
                      Consumer<AddSupplierViewModel>(
                        builder: (context, val6, child) {
                          return CustomTextField(
                              controller: val6.bankAccountNumberC,
                              iconData: Icons.numbers,
                              hint: 'Supplier Account no.',
                              validatorText:
                                  'Provide supplier bank account no.');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Consumer<AddSupplierViewModel>(
            builder: (context, value, child) => RoundButton(
              title: 'Add',
              loading: value.loading,
              onPress: () {
                ///todo: validations
                value.addSupplierInFirebase();
              },
            ),
          ),
        ],
      ),
    );
  }
}
