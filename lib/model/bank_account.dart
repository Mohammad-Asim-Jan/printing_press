class BankAccount {
  BankAccount({
    required this.bankAccountNumberId, // auto generated
    required this.bankAccountNumber,
    required this.accountType,
    // required this.supplierDocRef,
  });

  final int bankAccountNumberId;
  final String bankAccountNumber;
  final String accountType;
  // final DocumentReference supplierDocRef;

  factory BankAccount.fromJson(Map<String, dynamic> jsonData) {
    return BankAccount(
      bankAccountNumberId: jsonData['bankAccountNumberId'],
      bankAccountNumber: jsonData['bankAccountNumber'],
      accountType: jsonData['accountType'],
      // supplierDocRef: jsonData['supplierDocRef'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankAccountNumberId': bankAccountNumberId,
      'bankAccountNumber': bankAccountNumber,
      'accountType': accountType,
      // 'supplierDocRef': supplierDocRef
    };
  }
}
