import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/round_button.dart';
import '../../../view_model/rate_list/paper/add_paper_view_model.dart';

class AddPaperView extends StatefulWidget {
  const AddPaperView({super.key});

  @override
  State<AddPaperView> createState() => _AddPaperViewState();
}

class _AddPaperViewState extends State<AddPaperView> {
  late AddPaperViewModel addPaperViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addPaperViewModel = Provider.of<AddPaperViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Paper'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: addPaperViewModel.formKey,
                  child: Column(
                    children: [
                      Consumer<AddPaperViewModel>(
                        builder: (context, val1, child) {
                          return CustomTextField(
                              controller: val1.paperNameC,
                              iconData: Icons.newspaper,
                              hint: 'Paper name',
                            validators: const [isNotEmpty],
                          );
                        },
                      ),
                      Consumer<AddPaperViewModel>(
                        builder: (context, val2, child) {
                          return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val2.sizeWidthC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.tune_rounded,
                              hint: 'Paper width',
                            validators: const [isNotEmpty, isNotZero],
                          );
                        },
                      ),
                      Consumer<AddPaperViewModel>(
                        builder: (context, val3, child) {
                          return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val3.sizeHeightC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.tune_rounded,
                              hint: 'Paper height',
                            validators: const [isNotEmpty, isNotZero],
                          );
                        },
                      ),
                      Consumer<AddPaperViewModel>(
                        builder: (context, val4, child) {
                          return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val4.qualityC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.label,
                              hint: 'Paper quality',
                            validators: const [isNotEmpty, isNotZero],
                          );
                        },
                      ),
                      Consumer<AddPaperViewModel>(
                        builder: (context, val5, child) {
                          return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val5.rateC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.monetization_on_rounded,
                              hint: 'Rate',
                            validators: const [isNotEmpty, isNotZero],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Consumer<AddPaperViewModel>(
            builder: (context, value, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundButton(
                title: 'Add',
                loading: value.loading,
                onPress: () {
                  ///todo: validations
                  value.addPaperInFirebase();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
