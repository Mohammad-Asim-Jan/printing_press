import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_drop_down.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/view_model/stock/add_stock_view_model.dart';
import 'package:printing_press/views/suppliers/add_supplier_view.dart';
import 'package:provider/provider.dart';

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
        body: Center(
          child: Consumer<AddStockViewModel>(
            builder: (context, value, child) {
              return value.dataFetched == false
                  ? const CircularProgressIndicator(
                      color: Colors.redAccent,
                    )
                  : addStockViewModel.suppliersNamesList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'You don\'t have any supplier registered!'),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddSupplierView(),
                                  ),
                                );
                              },
                              child: const Text('Register a supplier'),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
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
                                                validatorText:
                                                    'Provide stock name');
                                          },
                                        ),
                                        Consumer<AddStockViewModel>(
                                          builder: (context, val2, child) {
                                            return CustomTextField(
                                                controller: val2.stockCategoryC,
                                                iconData:
                                                    Icons.category_rounded,
                                                hint: 'Stock category',
                                                validatorText:
                                                    'Provide stock category');
                                          },
                                        ),
                                        Consumer<AddStockViewModel>(
                                          builder: (context, val3, child) {
                                            return CustomTextField(
                                                controller:
                                                    val3.stockDescriptionC,
                                                iconData:
                                                    Icons.description_rounded,
                                                hint: 'Stock description',
                                                validatorText:
                                                    'Provide stock description');
                                          },
                                        ),
                                        Consumer<AddStockViewModel>(
                                          builder: (context, val4, child) {
                                            return CustomTextField(
                                                textInputType:
                                                    TextInputType.number,
                                                controller:
                                                    val4.stockUnitBuyPriceC,
                                                inputFormatter:
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                iconData: Icons.attach_money,
                                                hint: 'Stock price',
                                                validatorText:
                                                    'Provide stock buying price');
                                          },
                                        ),
                                        Consumer<AddStockViewModel>(
                                          builder: (context, val5, child) {
                                            return TextFormField(
                                              controller:
                                                  val5.stockUnitSellPriceC,
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor: kPrimeColor,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.monetization_on,
                                                  size: 24,
                                                ),
                                                hintText: 'Stock selling price',
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: kPrimeColor,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                    color: kSecColor,
                                                  ),
                                                ),
                                              ),
                                              validator: (text) {
                                                if (text == '' ||
                                                    text == null) {
                                                  return 'Provide stock selling price';
                                                } else if (val5
                                                        .stockUnitBuyPriceC.text
                                                        .trim() ==
                                                    '') {
                                                  return 'Provide stock buy price first';
                                                } else if (int.tryParse(
                                                        text.trim())! <=
                                                    int.tryParse(val5
                                                        .stockUnitBuyPriceC.text
                                                        .trim())!) {
                                                  return 'Stock selling price must be greater than buying price';
                                                }
                                                return null;
                                              },
                                            );
                                          },
                                        ),
                                        Consumer<AddStockViewModel>(
                                          ///todo: add plus icon and minus icon for ease
                                          builder: (context, val6, child) {
                                            return CustomTextField(
                                                controller: val6.stockQuantityC,
                                                iconData: Icons.list,
                                                inputFormatter:
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                hint: 'Stock quantity',
                                                validatorText:
                                                    'Provide stock quantity');
                                          },
                                        ),
                                        Consumer<AddStockViewModel>(
                                          builder: (context, val7, child) {
                                            return CustomTextField(
                                                controller: val7.stockColorC,
                                                iconData:
                                                    Icons.color_lens_rounded,
                                                hint: 'Stock color',
                                                validatorText:
                                                    'Provide stock color');
                                          },
                                        ),
                                        Consumer<AddStockViewModel>(
                                          builder: (context, val8, child) {
                                            return CustomTextField(
                                                controller:
                                                    val8.stockManufacturedByC,
                                                iconData: Icons.factory,
                                                hint: 'Stock brand name',
                                                validatorText:
                                                    'Provide stock brand name');
                                          },
                                        ),

                                        Row(
                                          children: [
                                            const Text('Stock supplier'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Consumer<AddStockViewModel>(
                                              builder: (context, val9, child) {
                                                return Expanded(
                                                  flex: 2,
                                                  child: CustomDropDown(
                                                    validator: null,
                                                    list:
                                                        val9.suppliersNamesList,
                                                    value: val9
                                                        .selectedSupplierName,
                                                    hint: val9
                                                        .selectedSupplierName,
                                                    onChanged: (newVal) {
                                                      val9.changeSupplierDropdown(
                                                          newVal);
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),

                                        ///todo: change the text field to a dropdown
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Consumer<AddStockViewModel>(
                              builder: (context, value, child) => RoundButton(
                                title: 'Add',
                                loading: value.loading,
                                onPress: () {
                                  ///todo: validations

                                  value.addStockInFirebase();
                                },
                              ),
                            ),
                          ],
                        );
            },
          ),
        ));
  }
}
