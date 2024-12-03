
class StockOrderHistoryToSupplier {
  final int stockOrderId;
  final int stockId; // ref to the stock
  final String stockName; /// todo: remove this because it is no more of use
  final String stockCategory; /// todo: remove this because it is no more of use
  final int stockUnitBuyPrice;
  final int stockQuantity;
  final int totalAmount;
  final int supplierId;
  final DateTime stockDateAdded;

  StockOrderHistoryToSupplier({
    required this.stockOrderId,
    required this.stockId,
    required this.stockName,
    required this.stockCategory,
    required this.stockUnitBuyPrice,
    required this.stockQuantity,
    required this.totalAmount,
    required this.supplierId,
    required this.stockDateAdded,
  });

  factory StockOrderHistoryToSupplier.fromJson(Map<String, dynamic> json) {
    return StockOrderHistoryToSupplier(
      stockOrderId: json['stockOrderId'],
      stockId: json['stockId'],
      stockName: json['stockName'],
      stockCategory: json['stockCategory'],
      stockUnitBuyPrice: json['stockUnitBuyPrice'],
      stockQuantity: json['stockQuantity'],
      totalAmount: json['totalAmount'],
      supplierId: json['supplierId'],
      stockDateAdded: json['stockDateAdded'].toDate(),
    );
  }
}
