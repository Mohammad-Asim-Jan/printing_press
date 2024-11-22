import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/view_model/home/home_view_model.dart';
import 'package:printing_press/views/cashbook/cashbook_view.dart';
import 'package:printing_press/views/orders/all_orders_view.dart';
import 'package:printing_press/views/orders/place_order_view.dart';
import 'package:printing_press/views/rate_list/rate_list_view.dart';
import 'package:printing_press/views/stock/all_stock_view.dart';
import 'package:printing_press/views/suppliers/all_suppliers_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel homeViewModel;

  @override
  void initState() {
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<HomeViewModel>(
          builder: (BuildContext context, HomeViewModel value, Widget? child) {
        if (value.index == 4) {
          return const SizedBox.shrink();
        } else {
          return FloatingActionButton(
            backgroundColor: kSecColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => value.floatingButtonNavigation()));
            },
            child: Text(
              'Add +',
              style: TextStyle(color: kThirdColor),
            ),
          );
        }
      }),
      bottomNavigationBar: Consumer<HomeViewModel>(
        builder: (context, value, child) => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.people_alt_outlined),
                icon: Icon(Icons.people_alt),
                label: 'Orders'),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.account_balance_wallet_outlined),
                icon: Icon(Icons.account_balance_wallet),
                label: 'CashBook'),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.add_business_outlined),
                icon: Icon(
                  Icons.add_business,
                ),
                label: 'Suppliers'),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.inventory_2_outlined),
                icon: Icon(Icons.inventory_2),
                label: 'Stock'),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.view_list_outlined),
                icon: Icon(Icons.view_list),
                label: 'Rate-list'),
          ],
          showUnselectedLabels: true,
          unselectedItemColor: kNew9,
          type: BottomNavigationBarType.shifting,
          currentIndex: homeViewModel.index,
          onTap: (index) => homeViewModel.updateIndex(index),
          selectedItemColor: kNew12,
          selectedFontSize: 15,
        ),
      ),
      appBar: AppBar(
          title: Consumer<HomeViewModel>(
              builder: (context, value, child) =>
                  Text(homeViewModel.appBarText()))),
      body: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: Text('No be continued...'),
            )
          ],
        ),
      ),
    );
  }
}

// drawer: Drawer(
//   // Shape of the drawer (rounded corners in this case)
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.only(topRight: Radius.circular(56)),
//   ),
//   // Custom width of the drawer
//   // width: 250.0,
//
//   // Custom background color
//   backgroundColor: kTwo,
//   // Colors.blueGrey[500],
//
//   // Clip behavior determines whether the contents are clipped at the edges
//   clipBehavior: Clip.antiAlias,
//
//   // The drawer content, typically a ListView of menu items
//   child: ListView(
//     padding: EdgeInsets.zero,
//     children: [
//       // Drawer Header: You can customize it as you wish
//       // const DrawerHeader(
//       //   decoration: BoxDecoration(
//       //     color: Colors.blueGrey
//       //     // Theme.of(context).colorScheme.secondary
//       //   ),
//       //   child: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       Icon(
//       //         Icons.account_circle,
//       //         color: Colors.white,
//       //         size: 50,
//       //       ),
//       //       SizedBox(height: 10),
//       //       Text(
//       //         'John Doe',
//       //         style: TextStyle(
//       //           color: Colors.white,
//       //           fontSize: 20,
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       // ListTile 1
//
//       SizedBox(
//         height: 50,
//       ),
//       ListTile(
//         leading: Icon(Icons.home),
//         title: Text('Home'),
//         onTap: () {
//           // Handle navigation
//         },
//       ),
//       // ListTile 2
//       ListTile(
//         leading: Icon(Icons.settings),
//         title: Text('Settings'),
//         onTap: () {
//           // Handle navigation
//         },
//       ),
//       // ListTile 3
//       ListTile(
//         leading: Icon(Icons.logout),
//         title: Text('Logout'),
//         onTap: () {
//           // Handle navigation
//         },
//       ),
//     ],
//   ),
// ),
// drawer: NavigationDrawer(
//   backgroundColor: kTwo,
//   children: [],
// ),

// const SizedBox(
//   height: 10,
// ),
// RoundButton(
//     title: 'Employees',
//     onPress: () {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const AllEmployeesView(),
//       ));
//     }),

// const SizedBox(
//   height: 10
// ),
// RoundButton(
//     title: 'Khata',
//     onPress: () {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const KhataView(),
//       ));
//     }),
