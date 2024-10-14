import 'package:cloud_firestore/cloud_firestore.dart';

class CashbookEntry {
  int? supplierPaymentId;
  final int cashbookEntryId;
  final Timestamp paymentDateTime;
  final int amount;
  int? supplierId;
  int? customerOrderId;
  String? description;
  String? paymentType;
  final String paymentMethod;

  CashbookEntry({
    this.supplierPaymentId,
    required this.cashbookEntryId,
    required this.paymentDateTime,
    required this.amount,
    this.supplierId,
    this.customerOrderId,
    this.description,
    required this.paymentType,
    required this.paymentMethod,
  });

  factory CashbookEntry.fromJson(Map<String, dynamic> jsonData) {
    return CashbookEntry(
      supplierPaymentId: jsonData['supplierPaymentId'],
      cashbookEntryId: jsonData['cashbookEntryId'],
      paymentDateTime: jsonData['paymentDateTime'],
      amount: jsonData['amount'],
      supplierId: jsonData['supplierId'],
      customerOrderId: jsonData['customerOrderId'],
      description: jsonData['description'],
      paymentType: jsonData['paymentType'],
      paymentMethod: jsonData['paymentMethod'],
    );
  }
}
