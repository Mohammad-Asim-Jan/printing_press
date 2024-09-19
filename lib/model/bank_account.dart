
class BankAccount {
  BankAccount({
    required this.bankAccountNumberId,
    required this.bankAccountNumber,
    required this.accountType,
  });

  final String bankAccountNumberId;
  final String bankAccountNumber;
  final String accountType;

  factory BankAccount.fromJson(Map<String, dynamic> jsonData) {
    return BankAccount(
      bankAccountNumberId: 'bankAccountNumberID',
      bankAccountNumber: 'accountNumber',
      accountType: 'accountType',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankAccountNumberID': bankAccountNumberId,
      'bankAccountNumber': bankAccountNumber,
      'accountType': accountType
    };
  }
}
