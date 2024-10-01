import 'package:flutter/material.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/view_model/payment/payment_view_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_text_field.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({
    super.key,
    this.supplierId,
    this.orderId = 0,
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
    paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
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
                    validatorText: 'Provide stock description');
              },
            ),

            ///todo: this amount has to be less than the remaining amount of the supplier
            Consumer<PaymentViewModel>(
              builder: (context, val1, child) {
                return CustomTextField(
                    controller: val1.amountC,
                    iconData: Icons.format_list_numbered_rounded,
                    hint: 'Amount',
                    validatorText: 'Provide payment amount');
              },
            ),

            ///todo: this has to be a dropdown instead of a text field, more details are in the view model
            Consumer<PaymentViewModel>(
              builder: (context, val2, child) {
                return CustomTextField(
                    controller: val2.paymentMethodC,
                    iconData: Icons.payment,
                    hint: 'Payment Method',
                    validatorText: 'Provide payment method');
              },
            ),
            const Spacer(),
            Consumer<PaymentViewModel>(
              builder: (context, val4, child) => RoundButton(
                  loading: val4.loading,
                  title: 'Payment',
                  onPress: () {
                    debugPrint('\n\nSupplier Id: ${widget.supplierId}');
                    val4.addPaymentInFirestore(widget.supplierId!);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
