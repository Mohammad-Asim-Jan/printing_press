import 'package:flutter/material.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/view_model/home/home_view_model.dart';
import 'package:printing_press/views/cashbook/cash_book_view.dart';
import 'package:printing_press/views/employees/all_employees_view.dart';
import 'package:printing_press/views/orders/all_orders_view.dart';
import 'package:printing_press/views/rate_list/rate_list_view.dart';
import 'package:printing_press/views/stock/all_stock_view.dart';
import 'package:printing_press/views/suppliers/all_suppliers_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Customer Orders',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllOrdersView(),
                  ));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Cashbook',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CashBookView(),
                  ));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Employees',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllEmployeesView(),
                  ));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Suppliers',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllSuppliersView(),
                  ));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Stock',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllStockView(),
                  ));
                }),
            const SizedBox(
              height: 10,
            ),
            // RoundButton(
            //     title: 'Khata',
            //     onPress: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const KhataView(),
            //       ));
            //     }),const SizedBox(
            //   height: 10,
            // ),
            RoundButton(
                title: 'Rate list',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RateListView(),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}
