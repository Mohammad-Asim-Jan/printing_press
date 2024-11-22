import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/rate_list/numbering/add_numbering_view_model.dart';
import 'package:provider/provider.dart';

class AddNumberingView extends StatefulWidget {
  const AddNumberingView({super.key});

  @override
  State<AddNumberingView> createState() => _AddNumberingViewState();
}

class _AddNumberingViewState extends State<AddNumberingView> {
  late AddNumberingViewModel addNumberingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addNumberingViewModel =
        Provider.of<AddNumberingViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Numbering'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: addNumberingViewModel.formKey,
                    child: Column(
                      children: [
                        Consumer<AddNumberingViewModel>(
                          builder: (context, val1, child) {
                            return CustomTextField(
                              controller: val1.numberingNameC,
                              iconData: Icons.numbers_outlined,
                              hint: 'Numbering Name',
                              validators: const [isNotEmpty],
                            );
                          },
                        ),
                        Consumer<AddNumberingViewModel>(
                          builder: (context, val2, child) {
                            return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val2.rateC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.monetization_on_rounded,
                              hint: 'Numbering Rate',
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
            Consumer<AddNumberingViewModel>(
              builder: (context, value, child) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundButton(
                  title: 'Add',
                  loading: value.loading,
                  onPress: () {
                    ///todo: validations
                    value.addNumberingInFirebase();
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
