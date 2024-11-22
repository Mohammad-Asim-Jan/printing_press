import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/rate_list/machine/add_machine_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/round_button.dart';

class AddMachineView extends StatefulWidget {
  const AddMachineView({super.key});

  @override
  State<AddMachineView> createState() => _AddMachineViewState();
}

class _AddMachineViewState extends State<AddMachineView> {
  late AddMachineViewModel addMachineViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addMachineViewModel =
        Provider.of<AddMachineViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Machine'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: addMachineViewModel.formKey,
                  child: Column(
                    children: [
                      Consumer<AddMachineViewModel>(
                        builder: (context, val1, child) {
                          return CustomTextField(
                            controller: val1.machineNameC,
                            iconData: Icons.handyman_rounded,
                            hint: 'Machine name',
                            validators: const [isNotEmpty],
                          );
                        },
                      ),
                      Consumer<AddMachineViewModel>(
                        builder: (context, val2, child) {
                          return CustomTextField(
                            textInputType: TextInputType.number,
                            controller: val2.sizeWidthC,
                            inputFormatter:
                                FilteringTextInputFormatter.digitsOnly,
                            iconData: Icons.tune_rounded,
                            hint: 'Machine width',
                            validators: const [
                              isNotEmpty,
                              isNotZero,
                            ],
                          );
                        },
                      ),
                      Consumer<AddMachineViewModel>(
                        builder: (context, val3, child) {
                          return CustomTextField(
                            textInputType: TextInputType.number,
                            controller: val3.sizeHeightC,
                            inputFormatter:
                                FilteringTextInputFormatter.digitsOnly,
                            iconData: Icons.tune_rounded,
                            hint: 'Machine height',
                            validators: const [
                              isNotEmpty,
                              isNotZero,
                            ],
                          );
                        },
                      ),
                      Consumer<AddMachineViewModel>(
                        builder: (context, val4, child) {
                          return CustomTextField(
                            textInputType: TextInputType.number,
                            controller: val4.plateRateC,
                            inputFormatter:
                                FilteringTextInputFormatter.digitsOnly,
                            iconData: Icons.settings,
                            hint: 'Machine plate rate',
                            validators: const [
                              isNotEmpty,
                              isNotZero,
                            ],
                          );
                        },
                      ),
                      Consumer<AddMachineViewModel>(
                        builder: (context, val5, child) {
                          return CustomTextField(
                            textInputType: TextInputType.number,
                            controller: val5.printingRateC,
                            inputFormatter:
                                FilteringTextInputFormatter.digitsOnly,
                            iconData: Icons.print_rounded,
                            hint: 'Machine printing rate',
                            validators: const [
                              isNotEmpty,
                              isNotZero,
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
          Consumer<AddMachineViewModel>(
            builder: (context, value, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundButton(
                title: 'Add',
                loading: value.loading,
                onPress: () {
                  ///todo: validations
                  value.addMachineInFirebase();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
