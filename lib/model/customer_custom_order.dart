import 'package:printing_press/model/rate_list.dart';
import 'package:printing_press/model/rate_list/binding.dart';
import 'package:printing_press/model/rate_list/design.dart';
import 'package:printing_press/model/rate_list/numbering.dart';
import 'package:printing_press/model/rate_list/paper_cutting.dart';
import 'package:printing_press/model/rate_list/profit.dart';

class CustomerCustomOrder {
  final String customerName;
  final String businessName;
  final int customerContactNo;
  final String customerAddress;
  final Design? design;
  final Paper paper;
  final Machine machine;
  final int plateExpense;
  final int printingExpense;
  final int bookQuantity;
  final int pagesPerBook;
  final PaperCutting? paperCutting;
  final int paperCuttingUnit;
  final String? copyVariant;
  final Binding binding;
  final Numbering numbering;
  final int printType;
  final int? backSidePrint;
  final Profit profit;
  final int otherExpenses;
  final int advancePayment;
  final int paidAmount;
  final int remainingAmount;
  final int totalAmount;

  CustomerCustomOrder({
    required this.customerName,
    required this.businessName,
    required this.customerContactNo,
    required this.customerAddress,
    this.design,
    required this.paper,
    required this.machine,
    required this.plateExpense,
    required this.printingExpense,
    required this.bookQuantity,
    required this.pagesPerBook,
    this.paperCutting,
    required this.paperCuttingUnit,
    this.copyVariant,
    required this.binding,
    required this.numbering,
    required this.printType,
    this.backSidePrint,
    required this.profit,
    required this.otherExpenses,
    required this.advancePayment,
    required this.paidAmount,
    required this.remainingAmount,
    required this.totalAmount,
  });

  factory CustomerCustomOrder.fromJson(Map<String, dynamic> json) {
    return CustomerCustomOrder(
      customerName: json['customerName'],
      businessName: json['businessName'],
      customerContactNo: json['customerContactNo'],
      customerAddress: json['customerAddress'],
      design: json['design'],
      paper: json['paper'],
      machine: json['machine'],
      plateExpense: json['plateExpense'],
      printingExpense: json['printingExpense'],
      bookQuantity: json['bookQuantity'],
      pagesPerBook: json['pagesPerBook'],
      paperCutting: json['paperCutting'],
      paperCuttingUnit: json['paperCuttingUnit'],
      copyVariant: json['copyVariant'],
      binding: json['binding'],
      numbering: json['numbering'],
      printType: json['printType'],
      backSidePrint: json['backSidePrint'],
      profit: json['profit'],
      otherExpenses: json['otherExpenses'],
      advancePayment: json['advancePayment'],
      paidAmount: json['paidAmount'],
      remainingAmount: json['remainingAmount'],
      totalAmount: json['totalAmount'],
    );
  }
}