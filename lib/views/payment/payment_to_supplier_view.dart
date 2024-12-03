import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_drop_down.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/payment/payment_to_supplier_view_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_text_field.dart';

class PaymentToSupplierView extends StatefulWidget {
  const PaymentToSupplierView({
    super.key,
    required this.supplierId,
  });

  final int supplierId;

  @override
  State<PaymentToSupplierView> createState() => _PaymentToSupplierViewState();
}

class _PaymentToSupplierViewState extends State<PaymentToSupplierView> {
  late PaymentToSupplierViewModel paymentViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentViewModel = Provider.of<PaymentToSupplierViewModel>(context, listen: false);
    paymentViewModel.getSupplierPreviousRemainingAmount(widget.supplierId);
    paymentViewModel.getSupplierBankAccountNames(widget.supplierId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcad6d2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kNew9a,
        title: Text('Payment',
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
                key: paymentViewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: paymentViewModel.descriptionC,
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
                          (value) => lessThan(value,
                              paymentViewModel.supplierPreviousRemainingAmount)
                        ],
                        controller: paymentViewModel.amountC,
                        iconData: Icons.payment,
                        hint: 'Amount'),
                    const SizedBox(height: 6),

                    Text('Payment Method',
                        style: TextStyle(
                            color: kThirdColor,
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: Consumer<PaymentToSupplierViewModel>(
                            builder: (BuildContext context,
                                    PaymentToSupplierViewModel value, Widget? child) =>
                                CustomDropDown(
                                  prefixIconData: Icons.account_balance_outlined,
                              validator: null,
                              list: value.listOfSupplierAccounts,
                              value: value.selectedBankAcc,
                              hint: value.selectedBankAcc,
                              onChanged: (newVal) {
                                value.selectedBankAcc = newVal!;
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundButton(
                loading: paymentViewModel.loading,
                title: 'Payment',
                onPress: () {
                  debugPrint('\n\nSupplier Id: ${widget.supplierId}');
                  if (widget.supplierId != 0) {
                    paymentViewModel.addPaymentInFirestore(
                        widget.supplierId, 0);
                  } else {
                    debugPrint('No supplier id found>>>>>>>>>>>');

                    /// todo: add order payment
                    // val4.addPaymentInFirestore(0, widget.orderId!);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
