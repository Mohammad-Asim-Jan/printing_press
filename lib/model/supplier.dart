
class Supplier {
  final int supplierId; // auto-generated
  final String supplierName; //
  final String supplierPhoneNo; //
  final String supplierEmail; //
  final String supplierAddress; //
  // final List<BankAccount>? bankAccount;
  final int totalAmount; //
  final int totalPaidAmount; //
  final int amountRemaining; //

  Supplier({
    required this.supplierId,
    required this.supplierName,
    required this.supplierPhoneNo,
    required this.supplierEmail,
    required this.supplierAddress,
    required this.totalAmount,
    required this.totalPaidAmount,
    required this.amountRemaining,
    // required this.bankAccount,
  });

  factory Supplier.fromJson(Map<String, dynamic> jsonData) {
    return Supplier(
      supplierId: jsonData['supplierId'],
      supplierName: jsonData['supplierName'],
      supplierPhoneNo: jsonData['supplierPhoneNo'],
      supplierAddress: jsonData['supplierAddress'],
      supplierEmail: jsonData['supplierEmail'],
      totalPaidAmount: jsonData['totalPaidAmount'],
      amountRemaining: jsonData['amountRemaining'],
      totalAmount: jsonData['totalAmount'],
      //bankAccount: (jsonData['bankAccount'] as List)
      //             .map((e) => BankAccount.fromJson(e))
      //             .toList()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supplierId': supplierId,
      'supplierName': supplierName,
      'supplierPhoneNo': supplierPhoneNo,
      'supplierAddress': supplierAddress,
      'supplierEmail': supplierEmail,
      'totalPaidAmount': totalPaidAmount,
      'amountRemaining': amountRemaining,
      'totalAmount': totalAmount,
      // 'bankAccount': bankAccount
    };
  }
}
