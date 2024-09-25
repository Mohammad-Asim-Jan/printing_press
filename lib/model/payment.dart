import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  // Payment is link to order (either customer order or supply order)

  final int paymentId;
  /// todo: payment in or out??
  //  Link to the associated order or expenses (supply order or any expenses). could it be customer order ????
  final int orderId;
  final Timestamp paymentDateTime;
  final int amount;

  Payment({
    required this.paymentId,
    required this.orderId,
    /// todo: which order??
    required this.paymentDateTime,
    required this.amount,
  });

  factory Payment.fromJson(Map<String, dynamic> jsonData) {
    return Payment(
        paymentId: jsonData['paymentId'],
        orderId: jsonData['orderId'],
        paymentDateTime: jsonData['paymentDateTime'],
        amount: jsonData['amount']);
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'paymentDateTime': paymentDateTime,
      'amount': amount,
    };
  }
}
