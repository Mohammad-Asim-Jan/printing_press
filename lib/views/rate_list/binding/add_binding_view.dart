import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/rate_list/binding/add_binding_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components/round_button.dart';

class AddBindingView extends StatefulWidget {
  const AddBindingView({super.key});

  @override
  State<AddBindingView> createState() => _AddBindingViewState();
}

class _AddBindingViewState extends State<AddBindingView> {
  late AddBindingViewModel addBindingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addBindingViewModel =
        Provider.of<AddBindingViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Binding'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: addBindingViewModel.formKey,
                    child: Column(
                      children: [
                        Consumer<AddBindingViewModel>(
                          builder: (context, val1, child) {
                            return CustomTextField(
                              controller: val1.bindingNameC,
                              iconData: Icons.my_library_books,
                              hint: 'Binding name',
                              validators: [isNotEmpty],
                            );
                          },
                        ),
                        Consumer<AddBindingViewModel>(
                          builder: (context, val2, child) {
                            return CustomTextField(
                              textInputType: TextInputType.number,
                              controller: val2.bindingRateC,
                              inputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                              iconData: Icons.monetization_on_rounded,
                              hint: 'Binding Rate',
                              validators: [isNotEmpty, isNotZero],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Consumer<AddBindingViewModel>(
              builder: (context, value, child) => RoundButton(
                title: 'Add',
                loading: value.loading,
                onPress: () {
                  ///todo: validations
                  value.addBindingInFirebase();
                },
              ),
            ),
          ],
        ));
  }
}
