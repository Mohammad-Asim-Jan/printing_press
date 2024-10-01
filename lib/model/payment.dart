import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final int paymentId;

  /// only for supplier, for customer order this will be null or even it won't exist
  final int supplierId;

  /// only for customer order, for supplier this will be null or even it won't exist
   int? orderId;

  /// this is either cash-in or cash-out
  final String paymentType;

  String? description;
  final Timestamp paymentDateTime;
  final int amount;
  final String paymentMethod;

  Payment({
    required this.paymentId,
    this.orderId = 0,
    required this.paymentDateTime,
    required this.amount,
    required this.supplierId,
    this.description = '...',
    required this.paymentType,
    required this.paymentMethod,
  });

  factory Payment.fromJson(Map<String, dynamic> jsonData) {
    return Payment(
      paymentId: jsonData['paymentId'],
      orderId: jsonData['orderId'],
      paymentDateTime: jsonData['paymentDateTime'],
      amount: jsonData['amount'],
      supplierId: jsonData['supplierId'],
      description: jsonData['description'],
      paymentType: jsonData['paymentType'],
      paymentMethod: jsonData['paymentMethod'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'paymentDateTime': paymentDateTime,
      'amount': amount,
      'supplierId': supplierId,
      'description': description,
      'paymentType': paymentType,
      'paymentMethod': paymentMethod,
    };
  }
}
