import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_drop_down.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/cashbook/add_cashbook_entry_view_model.dart';
import 'package:provider/provider.dart';

class AddCashbookEntryView extends StatefulWidget {
  const AddCashbookEntryView({super.key});

  @override
  State<AddCashbookEntryView> createState() => _AddCashbookEntryViewState();
}

class _AddCashbookEntryViewState extends State<AddCashbookEntryView> {
  late AddCashbookEntryViewModel addCashbookEntryViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addCashbookEntryViewModel =
        Provider.of<AddCashbookEntryViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cashbook Entry'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: addCashbookEntryViewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<AddCashbookEntryViewModel>(
                          builder: (context, val1, child) {
                            return CustomTextField(
                              controller: val1.amountC,
                              textInputType: TextInputType.number,
                              iconData: Icons.monetization_on_rounded,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              hint: 'Amount',
                              validators: const [
                                isNotEmpty,
                                isNotZero,
                              ],
                            );
                          },
                        ),
                        Consumer<AddCashbookEntryViewModel>(
                          builder: (context, val2, child) {
                            return CustomTextField(
                              controller: val2.descriptionC,
                              iconData: Icons.description,
                              hint: 'Description',
                              validators: const [
                                isNotEmpty,
                              ],
                            );
                          },
                        ),
                        Consumer<AddCashbookEntryViewModel>(
                          builder: (context, val3, child) {
                            return CustomTextField(
                              controller: val3.paymentMethodC,
                              iconData: Icons.cached_sharp,
                              hint: 'Payment method',
                              validators: const [isNotEmpty],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text('Payment Method',
                            style: TextStyle(
                                color: kThirdColor,
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Consumer<AddCashbookEntryViewModel>(
                                builder: (context, val4, child) {
                              return Expanded(
                                child: CustomDropDown(
                                  prefixIconData: Icons.account_balance_wallet_outlined,
                                  validator: null,
                                  list: const ['CASH-OUT', 'CASH-IN'],
                                  value: val4.selectedPaymentType,
                                  hint: val4.selectedPaymentType,
                                  onChanged: (newVal) {
                                    val4.changePaymentTypeDropdown(newVal);
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Consumer<AddCashbookEntryViewModel>(
              builder: (context, value, child) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundButton(
                  title: 'Add',
                  loading: value.loading,
                  onPress: () {
                    value.addCashbookEntryInFirebase();
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
