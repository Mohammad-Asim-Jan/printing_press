import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import '../../components/custom_text_field.dart';
import '../../components/round_button.dart';
import '../../utils/validation_functions.dart';
import '../../view_model/payment/payment_from_customer_view_model.dart';

class PaymentFromCustomerView extends StatefulWidget {
  const PaymentFromCustomerView({
    super.key,
    required this.customerOrderId,
    required this.remainingAmount,
  });

  final int remainingAmount;
  final int customerOrderId;

  @override
  State<PaymentFromCustomerView> createState() =>
      _PaymentFromCustomerViewState();
}

class _PaymentFromCustomerViewState extends State<PaymentFromCustomerView> {
  late PaymentFromCustomerViewModel paymentFromCustomerViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentFromCustomerViewModel =
        Provider.of<PaymentFromCustomerViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcad6d2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kNew9a,
        title: Text('Receive Payment',
            style: TextStyle(
                color: kNew9a,
                fontSize: 21,
                letterSpacing: 0,
                fontWeight: FontWeight.w500)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: paymentFromCustomerViewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: paymentFromCustomerViewModel.descriptionC,
                      iconData: Icons.description,
                      hint: 'Payment description',
                      validators: const [isNotEmpty],
                    ),

                    /// this amount has to be less than the remaining amount of the supplier
                    CustomTextField(
                        inputFormatter: FilteringTextInputFormatter.digitsOnly,
                        textInputType: TextInputType.number,
                        validators: [
                          isNotEmpty,
                          isNotZero,
                          (value) => lessThan(value, widget.remainingAmount)
                        ],
                        controller: paymentFromCustomerViewModel.amountC,
                        iconData: Icons.payment,
                        hint: 'Amount'),
                    const SizedBox(height: 6),

                    CustomTextField(
                        validators: null,
                        controller: paymentFromCustomerViewModel.paymentMethodC,
                        iconData: Icons.payment,
                        hint: 'Payment'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundButton(
                loading: paymentFromCustomerViewModel.loading,
                title: 'Collect Payment',
                onPress: () {
                  debugPrint('\n\nCustomer Id: ${widget.customerOrderId}');
                  if (widget.customerOrderId != 0) {
                    paymentFromCustomerViewModel.addPaymentInFirestore(
                        widget.customerOrderId, widget.remainingAmount);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
