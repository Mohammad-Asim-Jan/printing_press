import 'package:flutter/material.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/view_model/suppliers/add_supplier_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/round_button.dart';

class AddSupplierView extends StatefulWidget {
  final int id;
  const AddSupplierView({super.key, required this.id,});

  // late final AddSupplierViewModel addSupplierViewModel;

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
        body: Padding(
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
                        controller: val2.supplierPhoneC,
                        iconData: Icons.call,
                        hint: 'Supplier phone',
                        validatorText: 'Provide supplier phone');
                  },
                ),
                Consumer<AddSupplierViewModel>(
                  builder: (context, val3, child) {
                    return CustomTextField(
                        controller: val3.supplierEmailC,
                        iconData: Icons.email,
                        hint: 'Supplier email',
                        validatorText: 'Provide supplier email');
                  },
                ),
                Consumer<AddSupplierViewModel>(
                  builder: (context, val4, child) {
                    return CustomTextField(
                        controller: val4.supplierAccountNoC,
                        iconData: Icons.account_balance_rounded,
                        hint: 'Supplier account no.',
                        validatorText: 'Provide supplier account no');
                  },
                ),
                Consumer<AddSupplierViewModel>(
                  builder: (context, val5, child) {
                    return CustomTextField(
                        controller: val5.supplierAddressC,
                        iconData: Icons.home_filled,
                        hint: 'Supplier address',
                        validatorText: 'Provide supplier address');
                  },
                ),
                const Spacer(),
                Consumer<AddSupplierViewModel>(builder: (context, value, child) => RoundButton(
                  title: 'Add',
                  loading: value.loading,
                  onPress: () {
                    value.addSupplierInFirebase();
                    debugPrint(widget.id.toString());
                  },
                ),)
              ],
            ),
          ),
        ));
  }
}
