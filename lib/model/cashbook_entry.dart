import 'package:cloud_firestore/cloud_firestore.dart';

class CashbookEntry {
  final int paymentId;
  final int cashbookEntryId;
  final Timestamp paymentDateTime;
  final int amount;
  final int supplierId;
  final String description;
  final String paymentType;
  final String paymentMethod;

  CashbookEntry({
    required this.paymentId,
    required this.cashbookEntryId,
    required this.paymentDateTime,
    required this.amount,
    required this.supplierId,
    required this.description,
    required this.paymentType,
    required this.paymentMethod,
  });

  factory CashbookEntry.fromJson(Map<String, dynamic> jsonData) {
    return CashbookEntry(
      paymentId: jsonData['paymentId'],
      cashbookEntryId: jsonData['cashbookEntryId'],
      paymentDateTime: jsonData['paymentDateTime'],
      amount: jsonData['amount'],
      supplierId: jsonData['supplierId'],
      description: jsonData['description'],
      paymentType: jsonData['paymentType'],
      paymentMethod: jsonData['paymentMethod'],
    );
  }
}
