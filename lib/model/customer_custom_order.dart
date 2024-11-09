import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerCustomOrder {
  final int customerOrderId;
  final String customerName;
  final String businessTitle;
  final int customerContact;
  final String customerAddress;
  final int? designRate;
  final String paperSize;
  final int paperExpenses;
  final int? carbonExpenses;
  final int? carbonLessExpenses;
  final int? newsPaperExpenses;
  final String machineName;
  final int plateExpense;
  final int printingExpense;
  final int bookQuantity;
  final int pagesPerBook;
  final int? paperCuttingExpenses;
  final String? copyVariant;
  final int? bindingExpenses;
  final int? numberingExpenses;
  final int frontPrintType;
  final int? backPrintType;
  final int profitPercent;
  final int? otherExpenses;
  final String orderStatus;
  final Timestamp orderDateTime;
  final Timestamp? orderDueDateTime;
  final int advancePayment;
  final int paidAmount;

  // final int remainingAmount;
  final int totalAmount;

  CustomerCustomOrder({
    required this.customerOrderId,
    required this.orderStatus,
    required this.orderDateTime,
    required this.customerName,
    required this.businessTitle,
    required this.customerContact,
    required this.customerAddress,
    this.designRate,
    required this.paperSize,
    required this.paperExpenses,
    required this.machineName,
    required this.plateExpense,
    required this.printingExpense,
    required this.bookQuantity,
    this.carbonExpenses,
    this.carbonLessExpenses,
    this.newsPaperExpenses,
    required this.pagesPerBook,
    this.paperCuttingExpenses,
    this.copyVariant,
    this.bindingExpenses,
    this.numberingExpenses,
    required this.frontPrintType,
    this.backPrintType,
    required this.profitPercent,
    this.otherExpenses,
    required this.advancePayment,
    required this.paidAmount,
    this.orderDueDateTime,
    // required this.remainingAmount,
    required this.totalAmount,
  });

  factory CustomerCustomOrder.fromJson(Map<String, dynamic> json) {
    return CustomerCustomOrder(
      customerName: json['customerName'],
      businessTitle: json['businessTitle'],
      customerContact: json['customerContact'],
      customerAddress: json['customerAddress'],
      designRate: json['designRate'],
      carbonExpenses: json['carbonExpenses'],
      carbonLessExpenses: json['carbonLessExpenses'],
      newsPaperExpenses: json['newsPaperExpenses'],
      paperSize: json['paperSize'],
      paperExpenses: json['paperExpenses'],
      machineName: json['machineName'],
      plateExpense: json['plateExpense'],
      printingExpense: json['printingExpense'],
      bookQuantity: json['bookQuantity'],
      pagesPerBook: json['pagesPerBook'],
      paperCuttingExpenses: json['paperCuttingExpenses'],
      copyVariant: json['copyVariant'],
      bindingExpenses: json['bindingExpenses'],
      numberingExpenses: json['numberingExpenses'],
      frontPrintType: json['frontPrintType'],
      backPrintType: json['backPrintType'],
      profitPercent: json['profitPercent'],
      otherExpenses: json['otherExpenses'],
      advancePayment: json['advancePayment'],
      paidAmount: json['paidAmount'],
      // remainingAmount: json['remainingAmount'],
      totalAmount: json['totalAmount'],
      customerOrderId: json['customerOrderId'],
      orderStatus: json['orderStatus'],
      orderDateTime: json['orderDateTime'],
      orderDueDateTime: json['orderDueDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerOrderId': customerOrderId,
      'customerName': customerName,
      'businessTitle': businessTitle,
      'customerContact': customerContact,
      'customerAddress': customerAddress,
      'designRate': designRate,
      'paperSize': paperSize,
      'paperExpenses': paperExpenses,
      'carbonExpenses': carbonExpenses,
      'carbonLessExpenses': carbonLessExpenses,
      'newsPaperExpenses': newsPaperExpenses,
      'machineName': machineName,
      'plateExpense': plateExpense,
      'printingExpense': printingExpense,
      'bookQuantity': bookQuantity,
      'pagesPerBook': pagesPerBook,
      'paperCuttingExpenses': paperCuttingExpenses,
      'copyVariant': copyVariant,
      'bindingExpenses': bindingExpenses,
      'numberingExpenses': numberingExpenses,
      'frontPrintType': frontPrintType,
      'backPrintType': backPrintType,
      'profitPercent': profitPercent,
      'otherExpenses': otherExpenses,
      'orderStatus': orderStatus,
      'orderDateTime': orderDateTime,
      'orderDueDateTime': orderDueDateTime,
      'advancePayment': advancePayment,
      'paidAmount': paidAmount,
      'totalAmount': totalAmount,
    };
  }
}
