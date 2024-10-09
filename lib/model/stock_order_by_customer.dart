// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class StockOrderByCustomer {
//   ///todo: implement it in the add order view model (customer)
//   final String customerName;
//   final String businessTitle;
//   final String customerContact;
//   final int orderId;
//   final String customerAddress;
//   final int stockId; // ref to the stock
//   final String stockName;
//   final String stockCategory;
//   final int stockUnitSellPrice;
//   final int stockQuantity;
//   final Timestamp orderDateTime;
//   final Timestamp orderDueDateTime;
//   final String orderStatus;
//   // final List<Stock> itemOrdered; ///todo: either to add this or not!
//   final Timestamp stockDateAdded;
//   final int advancePayment;
//   final int totalAmount;
//
//
//   StockOrderByCustomer({
//     required this.stockOrderId,
//     required this.stockId,
//     required this.stockName,
//     required this.stockCategory,
//     required this.stockUnitSellPrice,
//     required this.stockQuantity,
//     required this.stockDateAdded,
//   }) ;
//
//   factory StockOrderByCustomer.fromJson(Map<String, dynamic> json) {
//     return StockOrderByCustomer(
//       stockOrderId: json['stockOrderId'],
//       stockId: json['stockId'],
//       stockName: json['stockName'],
//       stockCategory: json['stockCategory'],
//       stockUnitSellPrice: json['stockUnitSellPrice'],
//       stockQuantity: json['stockQuantity'],
//       stockDateAdded: json['stockDateAdded'],
//     );
//   }
// }
