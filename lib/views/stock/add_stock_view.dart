import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/view_model/stock/add_stock_view_model.dart';
import 'package:provider/provider.dart';

import '../../colors/color_palette.dart';

class AddStockView extends StatefulWidget {
  const AddStockView({super.key});

  @override
  State<AddStockView> createState() => _AddStockViewState();
}

class _AddStockViewState extends State<AddStockView> {
  @override
  Widget build(BuildContext context) {
    AddStockViewModel addStockViewModel =
        Provider.of<AddStockViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: addStockViewModel.formKey,
            child: Column(
              children: [
        
                Consumer<AddStockViewModel>(
                  builder: (context, val1, child) {
                    return CustomTextField(
                        controller: val1.stockNameC,
                        iconData: Icons.inventory,
                        hint: 'Stock name',
                        validatorText: 'Provide stock name');
                  },
                ),
                Consumer<AddStockViewModel>(
                  builder: (context, val2, child) {
                    return CustomTextField(
                        controller: val2.stockCategoryC,
                        iconData: Icons.category_rounded,
                        hint: 'Stock category',
                        validatorText: 'Provide stock category');
                  },
                ),
                Consumer<AddStockViewModel>(
                  builder: (context, val3, child) {
                    return CustomTextField(
                        controller: val3.stockDescriptionC,
                        iconData: Icons.description_rounded,
                        hint: 'Stock description',
                        validatorText: 'Provide stock description');
                  },
                ),
                Consumer<AddStockViewModel>(
                  builder: (context, val4, child) {
                    return CustomTextField(
                        textInputType: TextInputType.number,
                        controller: val4.stockUnitBuyPriceC,
                        inputFormatter: FilteringTextInputFormatter.digitsOnly,
                        iconData: Icons.attach_money,
                        hint: 'Stock price',
                        validatorText: 'Provide stock buying price');
                  },
                ),
                Consumer<AddStockViewModel>(
                  builder: (context, val5, child) {
                    return CustomTextField(
                        textInputType: TextInputType.number,
                        controller: val5.stockUnitSellPriceC,
                        iconData: Icons.monetization_on,
                        inputFormatter: FilteringTextInputFormatter.digitsOnly,
                        hint: 'Stock selling price',
                        validatorText: 'Provide stock selling price');
                  },
                ),
                Consumer<AddStockViewModel>(
                  ///todo: add plus icon and minus icon for ease
                  builder: (context, val6, child) {
                    return CustomTextField(
                        controller: val6.stockQuantityC,
                        iconData: Icons.list,
                        inputFormatter: FilteringTextInputFormatter.digitsOnly,
                        hint: 'Stock quantity',
                        validatorText: 'Provide stock quantity');
                  },
                ),
                Consumer<AddStockViewModel>(
                  builder: (context, val7, child) {
                    return CustomTextField(
                        controller: val7.stockColorC,
                        iconData: Icons.color_lens_rounded,
                        hint: 'Stock color',
                        validatorText: 'Provide stock color');
                  },
                ),
                Consumer<AddStockViewModel>(
                  builder: (context, val8, child) {
                    return CustomTextField(
                        controller: val8.stockManufacturedByC,
                        iconData: Icons.factory,
                        hint: 'Stock brand name',
                        validatorText: 'Provide stock brand name');
                  },
                ),
                ///todo: change the text field to a dropdown
                Consumer<AddStockViewModel>(
                  builder: (context, val9, child) {
                    return CustomTextField(
                        controller: val9.supplierIdC,
                        iconData: Icons.business,
                        hint: 'Stock supplier id',
                        validatorText: 'Provide stock supplier id');
                  },
                ),
                // const Spacer(),
                Consumer<AddStockViewModel>(
                  builder: (context, value, child) => RoundButton(
                    title: 'Add',
                    loading: value.loading,
                    onPress: () {
                      ///todo: validations
                      value.addStockInFirebase();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}