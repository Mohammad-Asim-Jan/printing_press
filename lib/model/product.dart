import 'package:printing_press/model/rate_list.dart';

class Stock {
  final int productId;
  final String productName;
  final String productDescription;
  final String productCategory;
  final int productUnitPrice;
  final List<Size> productSize;
  final int productQuantity;
  final String productColor;
  // final Supplier productSupplier;
  final DateTime? productDateAdded;

  /// todo: intl.dart package for date time formatting
  /// import 'package:intl/intl.dart';
  //
  // void main() {
  //   DateTime now = DateTime.now();
  //   String formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(now);
  //   print(formattedDate); // Example output: "2024-08-23 – 14:30"
  // }

  Stock({
    required this.productId,
    required this.productName,
    required this.productQuantity,
    required this.productDescription,
    required this.productCategory,
    required this.productUnitPrice,
    required this.productSize,
    required this.productColor,
    // required this.productSupplier,
    productDateAdded,
  }) : productDateAdded = productDateAdded ?? DateTime.now();

  factory Stock.fromJson(Map<String, dynamic> jsonData) {
    return Stock(
        productId: jsonData['productId'],
        productName: jsonData['productName'],
        productQuantity: jsonData['productQuantity'],
        productDescription: jsonData['productDescription'],
        productCategory: jsonData['productCategory'],
        productUnitPrice: jsonData['productUnitPrice'],
        productSize: (jsonData['productSize'] as List)
            .map((e) => Size.fromJson(e))
            .toList(),
        productColor: jsonData['productColor'],
        // productSupplier: Supplier.fromJson(jsonData['productSupplier']),
    );
  }
}
