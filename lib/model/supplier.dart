class Supplier {
  final int supplierId;
  final String supplierName;
  final String supplierPhoneNo;
  final String supplierAddress;
  final String accountNumber;

  Supplier({
    required this.supplierId,
    required this.supplierName,
    required this.supplierPhoneNo,
    required this.supplierAddress,
    required this.accountNumber,
  });

  factory Supplier.fromJson(Map<String, dynamic> jsonData) {
    return Supplier(
        supplierId: jsonData['supplierId'],
        supplierName: jsonData['supplierName'],
        supplierPhoneNo: jsonData['supplierPhoneNo'],
        supplierAddress: jsonData['supplierAddress'],
        accountNumber: jsonData['accountNumber']);
  }




}
