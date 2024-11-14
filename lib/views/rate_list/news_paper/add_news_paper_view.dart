import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/rate_list/news_paper/add_news_paper_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/round_button.dart';

class AddNewsPaperView extends StatefulWidget {
  const AddNewsPaperView({super.key});

  @override
  State<AddNewsPaperView> createState() => _AddNewsPaperViewState();
}

class _AddNewsPaperViewState extends State<AddNewsPaperView> {
  late AddNewsPaperViewModel addNewsPaperViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addNewsPaperViewModel =
        Provider.of<AddNewsPaperViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News-Paper'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: addNewsPaperViewModel.formKey,
                  child: Column(
                    children: [
                      Consumer<AddNewsPaperViewModel>(
                        builder: (context, val1, child) {
                          return CustomTextField(
                            controller: val1.newsPaperNameC,
                            iconData: Icons.newspaper,
                            hint: 'News-paper name',
                            validators: const [isNotEmpty],
                          );
                        },
                      ),
                      Consumer<AddNewsPaperViewModel>(
                        builder: (context, val2, child) {
                          return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val2.sizeWidthC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.tune_rounded,
                              hint: 'News-paper width',
                            validators: const [isNotEmpty, isNotZero],
                          );
                        },
                      ),
                      Consumer<AddNewsPaperViewModel>(
                        builder: (context, val3, child) {
                          return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val3.sizeHeightC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.tune_rounded,
                              hint: 'News-paper height',
                            validators: const [isNotEmpty, isNotZero],
                          );
                        },
                      ),
                      Consumer<AddNewsPaperViewModel>(
                        builder: (context, val4, child) {
                          return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val4.qualityC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.label,
                              hint: 'News-paper quality',
                            validators: const [isNotEmpty, isNotZero],
                          );
                        },
                      ),
                      Consumer<AddNewsPaperViewModel>(
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
          Consumer<AddNewsPaperViewModel>(
            builder: (context, value, child) => RoundButton(
              title: 'Add',
              loading: value.loading,
              onPress: () {
                ///todo: validations
                value.addNewsPaperInFirebase();
              },
            ),
          ),
        ],
      ),
    );
  }
}
