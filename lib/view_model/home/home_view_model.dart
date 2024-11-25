import 'package:flutter/material.dart';
import '../../views/cashbook/add_cashbook_entry_view.dart';
import '../../views/cashbook/cashbook_view.dart';
import '../../views/orders/all_orders_view.dart';
import '../../views/orders/place_order_view.dart';
import '../../views/rate_list/binding/add_binding_view.dart';
import '../../views/rate_list/binding/binding_view.dart';
import '../../views/rate_list/design/add_design_view.dart';
import '../../views/rate_list/design/design_view.dart';
import '../../views/rate_list/machine/add_machine_view.dart';
import '../../views/rate_list/machine/machine_view.dart';
import '../../views/rate_list/news_paper/add_news_paper_view.dart';
import '../../views/rate_list/news_paper/news_paper_view.dart';
import '../../views/rate_list/numbering/add_numbering_view.dart';
import '../../views/rate_list/numbering/numbering_view.dart';
import '../../views/rate_list/paper/add_paper_view.dart';
import '../../views/rate_list/paper/paper_view.dart';
import '../../views/rate_list/paper_cutting/add_paper_cutting_view.dart';
import '../../views/rate_list/paper_cutting/paper_cutting_view.dart';
import '../../views/rate_list/profit/add_profit_view.dart';
import '../../views/rate_list/profit/profit_view.dart';
import '../../views/stock/add_stock_view.dart';
import '../../views/stock/all_stock_view.dart';
import '../../views/suppliers/add_supplier_view.dart';
import '../../views/suppliers/all_suppliers_view.dart';

class HomeViewModel with ChangeNotifier {
  int index = 0;
  int rateListIndex = 0;

  void updateIndex(int newIndex) {
    index = newIndex;
    updateListeners();
  }

  void updateRateListIndex(int newIndex) {
    rateListIndex = newIndex;
    updateListeners();
  }

  List<String> rateListViewTitle = [
    'Binding',
    'Design',
    'Machine',
    'News Paper',
    'Numbering',
    'Paper',
    'Paper Cutting',
    'Profit',
  ];

  String getAppBarText() {
    List<String> mainViewsTitles = [
      'Customer Orders',
      'Cashbook',
      'Suppliers',
      'Stock',
      rateListViewTitle[rateListIndex]
    ];
    return mainViewsTitles[index];
  }

  getMainView() {
    List views = [
      const AllOrdersView(),
      const CashbookView(),
      const AllSuppliersView(),
      const AllStockView(),
      getRateListView()
    ];
    return views[index];
  }

  List<String> floatingButtonLabel = [
    'Place Order',
    'Add/Pay Amount',
    'Register a Supplier',
    'Order Stock',
    'Add +'
  ];

  getFloatingBtnLabel() => floatingButtonLabel[index];

  floatingButtonNavigation() {
    List floatingButtonViews = [
      const PlaceOrderView(),
      const AddCashbookEntryView(),
      const AddSupplierView(),
      const AddStockView(),
      rateListFloatingBtnView[rateListIndex]
    ];
    return floatingButtonViews[index];
  }

  List<Widget> rateListViews = [
    const BindingView(),
    const DesignView(),
    const MachineView(),
    const NewsPaperView(),
    const NumberingView(),
    const PaperView(),
    const PaperCuttingView(),
    const ProfitView(),
  ];

  getRateListView() => rateListViews[rateListIndex];

  List<Widget> rateListFloatingBtnView = [
    const AddBindingView(),
    const AddDesignView(),
    const AddMachineView(),
    const AddNewsPaperView(),
    const AddNumberingView(),
    const AddPaperView(),
    const AddPaperCuttingView(),
    const AddProfitView(),
  ];

  updateListeners() {
    notifyListeners();
  }
}
