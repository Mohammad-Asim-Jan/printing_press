
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
  final DateTime paymentDateTime;

  CashbookEntry({
    // this.supplierPaymentId,
    required this.cashbookEntryId,
    required this.amount,
    this.supplierId,
    this.newStockOrderId,
    this.customerOrderId,
    this.description,
    required this.paymentType,
    required this.paymentMethod,
    required this.paymentDateTime,
  });

  factory CashbookEntry.fromJson(Map<String, dynamic> jsonData) {
    return CashbookEntry(
      // supplierPaymentId: jsonData['supplierPaymentId'],
      cashbookEntryId: jsonData['cashbookEntryId'],
      newStockOrderId: jsonData['newStockOrderId'],
      amount: jsonData['amount'],
      supplierId: jsonData['supplierId'],
      customerOrderId: jsonData['customerOrderId'],
      description: jsonData['description'],
      paymentType: jsonData['paymentType'],
      paymentMethod: jsonData['paymentMethod'],
      paymentDateTime: jsonData['paymentDateTime'].toDate(),
    );
  }
}
