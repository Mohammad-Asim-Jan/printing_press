import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/view_model/rate_list/profit/add_profit_view_model.dart';
import 'package:provider/provider.dart';


class AddProfitView extends StatefulWidget {
  const AddProfitView({super.key});

  @override
  State<AddProfitView> createState() => _AddProfitViewState();
}

class _AddProfitViewState extends State<AddProfitView> {
  late AddProfitViewModel addProfitViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addProfitViewModel =
        Provider.of<AddProfitViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Profit'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: addProfitViewModel.formKey,
                    child: Column(
                      children: [
                        Consumer<AddProfitViewModel>(
                          builder: (context, val1, child) {
                            return CustomTextField(
                                controller: val1.profitNameC,
                                iconData: Icons.trending_up_rounded,
                                hint: 'Profit name',
                                validatorText: 'Provide profit name');
                          },
                        ),
                        Consumer<AddProfitViewModel>(
                          builder: (context, val2, child) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextFormField(
                                maxLength: 2,
                                controller: val2.percentageC,
                                keyboardType: TextInputType.number,
                                cursorColor: kPrimeColor,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Profit percentage',
                                  prefixIcon: const Icon(
                                    Icons.percent_rounded,
                                    size: 24,
                                  ),
                                  hintText: 'Profit percentage',
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
                                    return 'Provide profit percentage';
                                  }
                                  else if (int.tryParse(text)! < 1 ) {
                                    return 'Provide between 1-99';
                                  }
                                  return null;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Consumer<AddProfitViewModel>(
              builder: (context, value, child) => RoundButton(
                title: 'Add',
                loading: value.loading,
                onPress: () {
                  ///todo: validations
                  value.addProfitInFirebase();
                },
              ),
            ),
          ],
        ));
  }
}
