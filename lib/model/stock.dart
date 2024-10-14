import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  final int stockId;
  final String stockName;
  final String stockCategory;
  final String stockDescription;
  final int stockUnitBuyPrice;
  final int stockUnitSellPrice;
  final int stockQuantity;
  final int availableStock;

  // final Size stockSize;
  final String stockColor;
  int? totalAmount;
  final String manufacturedBy;
  final int supplierId;
  final Timestamp stockDateAdded;

  Stock({
    required this.stockId,
    required this.stockName,
    required this.stockQuantity,
    required this.stockDescription,
    required this.stockCategory,
    required this.stockUnitBuyPrice,
    required this.stockUnitSellPrice,
    required this.availableStock,
    this.totalAmount,
    // required this.stockSize,
    required this.stockColor,
    required this.manufacturedBy,
    required this.supplierId,
    required this.stockDateAdded,
  });

  factory Stock.fromJson(Map<String, dynamic> jsonData) {
    return Stock(
      stockId: jsonData['stockId'],
      stockName: jsonData['stockName'],
      stockQuantity: jsonData['stockQuantity'],
      stockDescription: jsonData['stockDescription'],
      stockCategory: jsonData['stockCategory'],
      stockUnitBuyPrice: jsonData['stockUnitBuyPrice'],
      stockUnitSellPrice: jsonData['stockUnitSellPrice'],
      availableStock: jsonData['availableStock'],
      // stockSize: Size.fromJson(jsonData['stockSize']),
      stockColor: jsonData['stockColor'],
      totalAmount: jsonData['totalAmount'],
      manufacturedBy: jsonData['manufacturedBy'],
      supplierId: jsonData['supplierId'],
      stockDateAdded: jsonData['stockDateAdded'],
    );
  }

  ///todo: Create a function that convert the DateTime to TimeStamp and returns it
  /// todo: intl.dart package for date time formatting
// import 'package:intl/intl.dart';
//
// void main() {
//   DateTime now = DateTime.now();
//   String formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(now);
//   print(formattedDate); // Example output: "2024-08-23 – 14:30"
// }
}
