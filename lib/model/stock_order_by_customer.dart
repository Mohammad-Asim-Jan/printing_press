import 'package:cloud_firestore/cloud_firestore.dart';

class StockOrderByCustomer {
  ///todo: implement it in the add order view model (customer)
  final int customerOrderId;
  final String customerName;
  final String businessTitle;
  final int customerContact;
  final String customerAddress;
  final int stockId; // ref to the stock
  final String stockName;
  final String stockCategory; // this might not be essential
  final int stockUnitSellPrice;
  final int stockQuantity;
  final Timestamp orderDateTime;
  // Timestamp? orderDueDateTime; /// todo: no due date for in-stock order
  final String orderStatus;

  // final List<Stock> itemOrdered; ///todo: either to add this or not!
  // final Timestamp stockDateAdded;
  final int paidAmount;
  final int totalAmount;

  StockOrderByCustomer({
    required this.customerName,
    required this.businessTitle,
    required this.customerContact,
    required this.customerOrderId,
    required this.customerAddress,
    required this.orderDateTime,
    // this.orderDueDateTime,
    required this.orderStatus,
    required this.paidAmount,
    required this.totalAmount,
    required this.stockId,
    required this.stockName,
    required this.stockCategory,
    required this.stockUnitSellPrice,
    required this.stockQuantity,
    // required this.stockDateAdded,
  });

  factory StockOrderByCustomer.fromJson(Map<String, dynamic> json) {
    return StockOrderByCustomer(
      stockId: json['stockId'],
      stockName: json['stockName'],
      stockCategory: json['stockCategory'],
      stockUnitSellPrice: json['stockUnitSellPrice'],
      stockQuantity: json['stockQuantity'],
      // stockDateAdded: json['stockDateAdded'],
      customerName: json['customerName'],
      businessTitle: json['businessTitle'],
      customerContact: json['customerContact'],
      customerOrderId: json['customerOrderId'],
      customerAddress: json['customerAddress'],
      orderDateTime: json['orderDateTime'],
      // orderDueDateTime: json['orderDueDateTime'],
      orderStatus: json['orderStatus'],
      paidAmount: json['paidAmount'],
      totalAmount: json['totalAmount'],
    );
  }
}
