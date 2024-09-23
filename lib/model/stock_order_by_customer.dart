import 'package:cloud_firestore/cloud_firestore.dart';

class StockOrderByCustomer {
  ///todo: implement it in the add order view model (customer)
  final int stockOrderId;
  final int stockId; // ref to the stock
  final String stockName;
  final String stockCategory;
  final int stockUnitSellPrice;
  final int stockQuantity;
  final Timestamp stockDateAdded;

  StockOrderByCustomer({
    required this.stockOrderId,
    required this.stockId,
    required this.stockName,
    required this.stockCategory,
    required this.stockUnitSellPrice,
    required this.stockQuantity,
    required this.stockDateAdded,
  }) ;

  factory StockOrderByCustomer.fromJson(Map<String, dynamic> json) {
    return StockOrderByCustomer(
      stockOrderId: json['stockOrderId'],
      stockId: json['stockId'],
      stockName: json['stockName'],
      stockCategory: json['stockCategory'],
      stockUnitSellPrice: json['stockUnitSellPrice'],
      stockQuantity: json['stockQuantity'],
      stockDateAdded: json['stockDateAdded'],
    );
  }
}
