import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/view_model/home/home_view_model.dart';
import 'package:provider/provider.dart';
import '../../view_model/auth/sign_out.dart';
import '../rate_list/rate_list_view.dart';

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
      endDrawer: context.watch<HomeViewModel>().index == 4
          ? Drawer(
              backgroundColor: Colors.yellow.shade50,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SafeArea(
                      child: ListTile(
                        titleTextStyle:
                            Theme.of(context).appBarTheme.titleTextStyle,
                        title: const Center(child: Text('Rate List')),
                      ),
                    ),
                    Divider(
                      thickness: 2.5,
                      color: kNew4,
                      indent: 10,
                      endIndent: 10,
                    ),
                    const Expanded(child: RateListView()),

                    const Divider(
                      height: 30,
                      indent: 80,
                      endIndent: 80,
                    ),
                    GestureDetector(
                      onTap: () async {
                        SignOut().confirmLogOut(context);
                      },
                      child: Card(
                        shadowColor: Colors.blueGrey,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.red.shade400,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Center(
                                      child: Text(
                                'Log Out\t\t\t\t\t',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ))),
                              Icon(Icons.logout_rounded, color: Colors.white70)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Consumer<HomeViewModel>(
          builder: (BuildContext context, HomeViewModel value, Widget? child) =>
              FloatingActionButton.extended(
                splashColor: kNew10,
                foregroundColor: kTwo,
                backgroundColor: kNew7,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => value.floatingButtonNavigation()));
                },
                label: Text(value.getFloatingBtnLabel()),
                // child: const Text(
                //   'Add New +',
                //   // style: TextStyle(color: kThirdColor),
                // ),
              )),
      bottomNavigationBar: Consumer<HomeViewModel>(
        builder: (context, value, child) => BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                backgroundColor: kThirdColor,
                activeIcon: const Icon(Icons.people_alt),
                icon: const Icon(Icons.people_alt_outlined),
                label: 'Orders'),
            BottomNavigationBarItem(
                backgroundColor: kThirdColor,
                activeIcon: const Icon(Icons.account_balance_wallet),
                icon: const Icon(Icons.account_balance_wallet_outlined),
                label: 'CashBook'),
            BottomNavigationBarItem(
                backgroundColor: kThirdColor,
                activeIcon: const Icon(Icons.add_business),
                icon: const Icon(Icons.add_business_outlined),
                label: 'Suppliers'),
            BottomNavigationBarItem(
                backgroundColor: kThirdColor,
                activeIcon: const Icon(Icons.inventory_2),
                icon: const Icon(Icons.inventory_2_outlined),
                label: 'Stock'),
            BottomNavigationBarItem(
                backgroundColor: kThirdColor,
                activeIcon: const Icon(Icons.view_list),
                icon: const Icon(Icons.view_list_outlined),
                label: 'Rate-list'),
          ],
          showUnselectedLabels: true,
          unselectedItemColor: kNew9a,
          type: BottomNavigationBarType.shifting,
          currentIndex: homeViewModel.index,
          onTap: (index) => homeViewModel.updateIndex(index),
          selectedItemColor: Colors.white,
          // backgroundColor: kThirdColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      appBar: AppBar(
          title: Consumer<HomeViewModel>(
              builder: (context, value, child) =>
                  Text(homeViewModel.getAppBarText()))),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<HomeViewModel>(
              builder: (context, value, child) => value.getMainView())),
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

// SwitchListTile(value: true, onChanged: (val) {}),
// ExpansionTile(
//   leading: Icon(Icons.settings),
//   title: Text('Settings'),
//   children: [
//     ListTile(
//       leading: Icon(Icons.color_lens),
//       title: Text('Change Theme'),
//       onTap: () {
//         // Change theme
//       },
//     ),
//     ListTile(
//       leading: Icon(Icons.language),
//       title: Text('Language Settings'),
//       onTap: () {
//         // Change language
//       },
//     ),
//   ],
// ),
// const Spacer(flex: 1,),
