import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/payment/payment_view_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_text_field.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({
    super.key,
    this.supplierId,
    this.orderId,
  });

  final int? supplierId;
  final int? orderId;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late PaymentViewModel paymentViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint('Supplier id in the method view is ${widget.supplierId}');
    paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
    paymentViewModel.getSupplierPreviousRemainingAmount(widget.supplierId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Form(
        key: paymentViewModel.formKey,
        child: Column(
          children: [
            Consumer<PaymentViewModel>(
              builder: (context, val, child) {
                return CustomTextField(
                  controller: val.descriptionC,
                  iconData: Icons.description,
                  hint: 'Payment description',
                  validators: const [
                    isNotEmpty,
                  ],
                );
              },
            ),

            ///todo: this amount has to be less than the remaining amount of the supplier
            Consumer<PaymentViewModel>(
              builder: (context, val1, child) {
                return TextFormField(
                  controller: val1.amountC,
                  keyboardType: TextInputType.number,
                  cursorColor: kPrimeColor,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.format_list_numbered_rounded,
                      size: 24,
                    ),
                    hintText: 'Amount',
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
                      return 'Provide payment amount';
                    } else if (val1.supplierPreviousRemainingAmount <
                        int.tryParse(val1.amountC.text.trim())!) {
                      return 'The remaining amount is \$ ${val1.supplierPreviousRemainingAmount}';
                    } else if(int.tryParse(val1.amountC.text.trim())! == 0){
                      return 'Provide some amount!';
                    }
                      return null;
                  },
                );
              },
            ),

            ///todo: this has to be a dropdown instead of a text field, more details are in the view model
            Consumer<PaymentViewModel>(
              builder: (context, val2, child) {
                return CustomTextField(
                    controller: val2.paymentMethodC,
                    iconData: Icons.payment,
                    hint: 'Payment Method',
                    validators: const [
                      isNotEmpty,
                    ],);
              },
            ),
            const Spacer(),
            Consumer<PaymentViewModel>(
              builder: (context, val4, child) => RoundButton(
                  loading: val4.loading,
                  title: 'Payment',
                  onPress: () {
                    debugPrint('\n\nSupplier Id: ${widget.supplierId}');
                    if (widget.supplierId != null || widget.supplierId != 0) {
                      val4.addPaymentInFirestore(widget.supplierId!, 0);
                    } else {
                      debugPrint('No supplier id found>>>>>>>>>>>');

                      /// todo: add order payment
                      // val4.addPaymentInFirestore(0, widget.orderId!);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
