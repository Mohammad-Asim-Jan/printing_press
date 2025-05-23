import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_drop_down.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/stock/add_stock_view_model.dart';
import 'package:printing_press/views/suppliers/add_supplier_view.dart';
import 'package:provider/provider.dart';

import '../../components/custom_circular_indicator.dart';

class AddStockView extends StatefulWidget {
  const AddStockView({super.key});

  @override
  State<AddStockView> createState() => _AddStockViewState();
}

class _AddStockViewState extends State<AddStockView> {
  late AddStockViewModel addStockViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addStockViewModel = Provider.of<AddStockViewModel>(context, listen: false);
    addStockViewModel.getAllSuppliersName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Stock'),
        ),
        body: Consumer<AddStockViewModel>(builder: (context, value, child) {
          return value.dataFetched == false
              ? const CustomCircularIndicator()
              : addStockViewModel.suppliersNamesList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              'You don\'t have any supplier registered!'),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddSupplierView(),
                                ),
                              );
                            },
                            child: const Text('Register a supplier'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key: addStockViewModel.formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Consumer<AddStockViewModel>(
                                      builder: (context, val1, child) {
                                        return CustomTextField(
                                          controller: val1.stockNameC,
                                          iconData: Icons.inventory,
                                          hint: 'Stock name',
                                          validators: const [isNotEmpty],
                                        );
                                      },
                                    ),
                                    Consumer<AddStockViewModel>(
                                      builder: (context, val2, child) {
                                        return CustomTextField(
                                          controller: val2.stockCategoryC,
                                          iconData: Icons.category_rounded,
                                          hint: 'Stock category',
                                          validators: const [isNotEmpty],
                                        );
                                      },
                                    ),
                                    Consumer<AddStockViewModel>(
                                      builder: (context, val3, child) {
                                        return CustomTextField(
                                          controller: val3.stockDescriptionC,
                                          iconData: Icons.description_rounded,
                                          hint: 'Stock description',
                                          validators: const [isNotEmpty],
                                        );
                                      },
                                    ),
                                    Consumer<AddStockViewModel>(
                                      builder: (context, val4, child) {
                                        return CustomTextField(
                                          textInputType: TextInputType.number,
                                          controller: val4.stockUnitBuyPriceC,
                                          inputFormatter:
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                          iconData: Icons.attach_money,
                                          hint: 'Stock price',
                                          validators: const [
                                            isNotEmpty,
                                            isNotZero
                                          ],
                                        );
                                      },
                                    ),
                                    Consumer<AddStockViewModel>(
                                      builder: (context, val5, child) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Column(
                                            children: [
                                              CustomTextField(
                                                controller:
                                                    val5.stockUnitSellPriceC,
                                                textInputType:
                                                    TextInputType.number,
                                                inputFormatter:
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                hint: 'Stock selling price',
                                                iconData: Icons.monetization_on,
                                                validators: [
                                                  isNotEmpty,
                                                  (value) => moreThan(
                                                      value,
                                                     ( int.tryParse(val5
                                                              .stockUnitBuyPriceC
                                                              .text
                                                              .trim()) ??
                                                          0) + 1)
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    Consumer<AddStockViewModel>(
                                      ///todo: add plus icon and minus icon for ease
                                      builder: (context, val6, child) {
                                        return CustomTextField(
                                          textInputType: TextInputType.number,
                                          controller: val6.stockQuantityC,
                                          iconData: Icons.list,
                                          inputFormatter:
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                          hint: 'Stock quantity',
                                          validators: const [
                                            isNotEmpty,
                                            isNotZero
                                          ],
                                        );
                                      },
                                    ),
                                    Consumer<AddStockViewModel>(
                                      builder: (context, val7, child) {
                                        return CustomTextField(
                                          controller: val7.stockColorC,
                                          iconData: Icons.color_lens_rounded,
                                          hint: 'Stock color',
                                          validators: const [isNotEmpty],
                                        );
                                      },
                                    ),
                                    Consumer<AddStockViewModel>(
                                      builder: (context, val8, child) {
                                        return CustomTextField(
                                          controller: val8.stockManufacturedByC,
                                          iconData: Icons.factory,
                                          hint: 'Stock brand name',
                                          validators: const [isNotEmpty],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 6),
                                    Text('Stock Supplier',
                                        style: kTitle2TextStyle),
                                    Consumer<AddStockViewModel>(
                                      builder: (context, val9, child) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: CustomDropDown(
                                                prefixIconData:
                                                    Icons.person_2_outlined,
                                                validator: null,
                                                list: val9.suppliersNamesList,
                                                value:
                                                    val9.selectedSupplierName,
                                                hint: val9.selectedSupplierName,
                                                onChanged: (newVal) {
                                                  val9.changeSupplierDropdown(
                                                      newVal);
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Consumer<AddStockViewModel>(
                          builder: (context, value, child) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RoundButton(
                              title: 'Add',
                              loading: value.loading,
                              onPress: () {
                                value.addStockInFirebase();
                              },
                            ),
                          ),
                        ),
                      ],
                    );
        }));
  }
}
