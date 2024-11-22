import 'package:flutter/material.dart';

import '../../views/cashbook/add_cashbook_entry_view.dart';
import '../../views/cashbook/cashbook_view.dart';
import '../../views/orders/all_orders_view.dart';
import '../../views/orders/place_order_view.dart';
import '../../views/rate_list/rate_list_view.dart';
import '../../views/stock/add_stock_view.dart';
import '../../views/stock/all_stock_view.dart';
import '../../views/suppliers/add_supplier_view.dart';
import '../../views/suppliers/all_suppliers_view.dart';

class HomeViewModel with ChangeNotifier {
  int index = 0;

  void updateIndex(int newIndex) {
    index = newIndex;
    updateListeners();
  }

  List<String> viewNames = [
    'All Orders',
    'Cashbook',
    'Suppliers',
    'Stock',
    'Rate list'
  ];

  updateListeners() {
    notifyListeners();
  }

  List views =
  [
    const AllOrdersView(),
    const CashbookView(),
    const AllSuppliersView(),
    const AllStockView(),
    const RateListView()
  ];

  viewNavigation() => views[index];


  List floatingButtonNavigationList = const [
    PlaceOrderView(),
    AddCashbookEntryView(),
    AddSupplierView(),
    AddStockView(),
    null
  ];

  floatingButtonNavigation() => floatingButtonNavigationList[index];

  String appBarText() => viewNames[index];
}
