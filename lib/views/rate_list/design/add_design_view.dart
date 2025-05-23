import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/rate_list/design/add_design_view_model.dart';
import 'package:provider/provider.dart';

class AddDesignView extends StatefulWidget {
  const AddDesignView({super.key});

  @override
  State<AddDesignView> createState() => _AddDesignViewState();
}

class _AddDesignViewState extends State<AddDesignView> {
  late AddDesignViewModel addDesignViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addDesignViewModel =
        Provider.of<AddDesignViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Design'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: addDesignViewModel.formKey,
                    child: Column(
                      children: [
                        Consumer<AddDesignViewModel>(
                          builder: (context, val1, child) {
                            return CustomTextField(
                              controller: val1.designNameC,
                              iconData: Icons.design_services_rounded,
                              hint: 'Design name',
                              validators: const [isNotEmpty],
                            );
                          },
                        ),
                        Consumer<AddDesignViewModel>(
                          builder: (context, val2, child) {
                            return CustomTextField(
                                textInputType: TextInputType.number,
                                controller: val2.rateC,
                                inputFormatter:
                                    FilteringTextInputFormatter.digitsOnly,
                                iconData: Icons.monetization_on_rounded,
                                hint: 'Design Rate',
                                validators: const [
                                  isNotEmpty,
                                  isNotZero,
                                ],);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Consumer<AddDesignViewModel>(
              builder: (context, value, child) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundButton(
                  title: 'Add',
                  loading: value.loading,
                  onPress: () {
                    ///todo: validations
                    value.addDesignInFirebase();
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
