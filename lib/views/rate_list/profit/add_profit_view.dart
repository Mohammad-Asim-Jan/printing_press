import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/view_model/profit/add_profit_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/round_button.dart';

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
                            return CustomTextField(
                                textInputType: TextInputType.number,
                                controller: val2.percentageC,
                                inputFormatter:
                                    FilteringTextInputFormatter.digitsOnly,
                                iconData: Icons.percent_rounded,
                                hint: 'Profit percentage',
                                validatorText: 'Provide profit percentage');
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
