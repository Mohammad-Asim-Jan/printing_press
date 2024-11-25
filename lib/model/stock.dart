
class Stock {
  final int stockId;
  final String stockName;
  final String stockCategory;
  final String stockDescription;
  final int availableStock;
  final int stockUnitBuyPrice;
  final int stockUnitSellPrice;
  final int stockQuantity;
  // final Size stockSize;
  final String stockColor;
  final String manufacturedBy;
  int? totalAmount;
  final int supplierId;
  final DateTime stockDateAdded;

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
      stockDateAdded: jsonData['stockDateAdded'].toDate(),
    );
  }
}
