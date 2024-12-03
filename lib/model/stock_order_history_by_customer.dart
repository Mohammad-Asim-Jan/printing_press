
class StockOrderHistoryByCustomer {
  final int stockOrderId;
  final int stockId; // ref to the stock
  final String stockName;
  final String stockCategory;
  final int stockUnitSellPrice;
  final int stockQuantity;
  final int totalAmount;
  final int customerOrderId;
  final DateTime stockDateOrdered;

  StockOrderHistoryByCustomer({
    required this.stockOrderId,
    required this.stockId,
    required this.stockName,
    required this.stockCategory,
    required this.stockUnitSellPrice,
    required this.stockQuantity,
    required this.totalAmount,
    required this.customerOrderId,
    required this.stockDateOrdered,
  });

  factory StockOrderHistoryByCustomer.fromJson(Map<String, dynamic> json) {
    return StockOrderHistoryByCustomer(
      stockOrderId: json['stockOrderId'],
      stockId: json['stockId'],
      stockName: json['stockName'],
      stockCategory: json['stockCategory'],
      stockUnitSellPrice: json['stockUnitSellPrice'],
      stockQuantity: json['stockQuantity'],
      totalAmount: json['totalAmount'],
      customerOrderId: json['customerOrderId'],
      stockDateOrdered: json['stockDateOrdered'].toDate(),
    );
  }
}
