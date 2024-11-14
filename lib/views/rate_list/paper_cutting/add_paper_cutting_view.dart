import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/rate_list/paper_cutting/add_paper_cutting_view_model.dart';
import 'package:provider/provider.dart';

class AddPaperCuttingView extends StatefulWidget {
  const AddPaperCuttingView({super.key});

  @override
  State<AddPaperCuttingView> createState() => _AddPaperCuttingViewState();
}

class _AddPaperCuttingViewState extends State<AddPaperCuttingView> {
  late AddPaperCuttingViewModel addPaperCuttingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addPaperCuttingViewModel =
        Provider.of<AddPaperCuttingViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Paper Cutting'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: addPaperCuttingViewModel.formKey,
                    child: Column(
                      children: [
                        Consumer<AddPaperCuttingViewModel>(
                          builder: (context, val1, child) {
                            return CustomTextField(
                                controller: val1.paperCuttingNameC,
                                iconData: Icons.cut,
                                hint: 'Paper Cutting name',
                              validators: const [isNotEmpty],
                            );
                          },
                        ),
                        Consumer<AddPaperCuttingViewModel>(
                          builder: (context, val2, child) {
                            return CustomTextField(
                                textInputType: TextInputType.number,
                                controller: val2.rateC,
                                inputFormatter:
                                    FilteringTextInputFormatter.digitsOnly,
                                iconData: Icons.monetization_on_rounded,
                                hint: 'Paper Cutting Rate',
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
            Consumer<AddPaperCuttingViewModel>(
              builder: (context, value, child) => RoundButton(
                title: 'Add',
                loading: value.loading,
                onPress: () {
                  ///todo: validations
                  value.addPaperCuttingInFirebase();
                },
              ),
            ),
          ],
        ));
  }
}
