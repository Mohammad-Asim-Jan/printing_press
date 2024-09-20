import 'package:printing_press/model/bank_account.dart';

/// todo: there will be a field named key that is supposed to be the key of the new supplier or the last supplier added to the database

class Supplier {
  final int supplierId; // auto-generated
  final String supplierName; //
  final int supplierPhoneNo; //
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
