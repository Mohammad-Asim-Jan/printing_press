import 'package:cloud_firestore/cloud_firestore.dart';

class BankAccount {
  BankAccount({
    required this.bankAccountNumberId, // auto generated
    required this.bankAccountNumber,
    required this.accountType,
    required this.supplierDocRef,
  });

  final String bankAccountNumberId;
  final String bankAccountNumber;
  final String accountType;
  final DocumentReference supplierDocRef;

  factory BankAccount.fromJson(Map<String, dynamic> jsonData) {
    return BankAccount(
      bankAccountNumberId: jsonData['bankAccountNumberId'],
      bankAccountNumber: jsonData['accountNumber'],
      accountType: jsonData['accountType'],
      supplierDocRef: jsonData['supplierDocRef'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankAccountNumberId': bankAccountNumberId,
      'bankAccountNumber': bankAccountNumber,
      'accountType': accountType,
      'supplierDocRef': supplierDocRef
    };
  }
}
