import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing_press/model/supplier.dart';

class Stock {
  final int stockId;
  final String stockName;
  final String stockCategory;
  final String stockDescription;
  final int stockUnitBuyPrice;
  final int stockUnitSellPrice;
  final int stockQuantity;
  // final Size stockSize;
  final String stockColor;
  final String manufacturedBy;
  final String stockSupplier; ///todo: change it into supplierId
  final Timestamp? stockDateAdded;

  Stock({
    required this.stockId,
    required this.stockName,
    required this.stockQuantity,
    required this.stockDescription,
    required this.stockCategory,
    required this.stockUnitBuyPrice,
    required this.stockUnitSellPrice,
    // required this.stockSize,
    required this.stockColor,
    required this.manufacturedBy,
    required this.stockSupplier,
    stockDateAdded,
  }) : stockDateAdded = stockDateAdded ?? Timestamp.now();

  factory Stock.fromJson(Map<String, dynamic> jsonData) {
    return Stock(
      stockId: jsonData['stockId'],
      stockName: jsonData['stockName'],
      stockQuantity: jsonData['stockQuantity'],
      stockDescription: jsonData['stockDescription'],
      stockCategory: jsonData['stockCategory'],
      stockUnitBuyPrice: jsonData['stockUnitBuyPrice'],
      stockUnitSellPrice: jsonData['stockUnitSellPrice'],
      // stockSize: Size.fromJson(jsonData['stockSize']),
      stockColor: jsonData['stockColor'],
      manufacturedBy: jsonData['manufacturedBy'],
      stockSupplier: jsonData['stockSupplier'],
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
