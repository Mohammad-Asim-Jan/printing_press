import 'package:cloud_firestore/cloud_firestore.dart';

class CashbookEntry {
  final int cashbookEntryId;
  final int? supplierId;
  final int? customerOrderId;
  final int? newStockOrderId;
  // final int? supplierPaymentId;
  final int amount;
  final String? description;
  final String paymentType;
  final String? paymentMethod;
  final Timestamp paymentDateTime;

  CashbookEntry({
    // this.supplierPaymentId,
    required this.cashbookEntryId,
    required this.paymentDateTime,
    required this.amount,
    this.supplierId,
    this.newStockOrderId,
    this.customerOrderId,
    this.description,
    required this.paymentType,
    required this.paymentMethod,
  });

  factory CashbookEntry.fromJson(Map<String, dynamic> jsonData) {
    return CashbookEntry(
      // supplierPaymentId: jsonData['supplierPaymentId'],
      cashbookEntryId: jsonData['cashbookEntryId'],
      paymentDateTime: jsonData['paymentDateTime'],
      newStockOrderId: jsonData['newStockOrderId'],
      amount: jsonData['amount'],
      supplierId: jsonData['supplierId'],
      customerOrderId: jsonData['customerOrderId'],
      description: jsonData['description'],
      paymentType: jsonData['paymentType'],
      paymentMethod: jsonData['paymentMethod'],
    );
  }
}
