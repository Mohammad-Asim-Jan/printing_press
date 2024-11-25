import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/firebase_options.dart';
import 'package:printing_press/view_model/cashbook/cashbook_view_model.dart';
import 'package:printing_press/view_model/home/home_view_model.dart';
import 'package:printing_press/view_model/auth/log_in_view_model.dart';
import 'package:printing_press/view_model/auth/sign_up_view_model.dart';
import 'package:printing_press/view_model/orders/all_orders_view_model.dart';
import 'package:printing_press/view_model/orders/place_customize_order_view_model.dart';
import 'package:printing_press/view_model/payment/payment_view_model.dart';
import 'package:printing_press/view_model/rate_list/binding/binding_view_model.dart';
import 'package:printing_press/view_model/rate_list/machine/add_machine_view_model.dart';
import 'package:printing_press/view_model/rate_list/machine/machine_view_model.dart';
import 'package:printing_press/view_model/rate_list/news_paper/add_news_paper_view_model.dart';
import 'package:printing_press/view_model/rate_list/news_paper/news_paper_view_model.dart';
import 'package:printing_press/view_model/rate_list/paper/add_paper_view_model.dart';
import 'package:printing_press/view_model/rate_list/paper/paper_view_model.dart';
import 'package:printing_press/view_model/rate_list/paper_cutting/add_paper_cutting_view_model.dart';
import 'package:printing_press/view_model/rate_list/profit/add_profit_view_model.dart';
import 'package:printing_press/view_model/rate_list/profit/profit_view_model.dart';
import 'package:printing_press/view_model/stock/add_stock_view_model.dart';
import 'package:printing_press/view_model/stock/all_stock_view_model.dart';
import 'package:printing_press/view_model/stock/stock_details_view_model.dart';
import 'package:printing_press/view_model/suppliers/add_supplier_view_model.dart';
import 'package:printing_press/view_model/suppliers/all_suppliers_view_model.dart';
import 'package:printing_press/view_model/suppliers/supplier_orders_history_view_model.dart';
import 'package:provider/provider.dart';
import 'view_model/cashbook/add_cashbook_entry_view_model.dart';
import 'view_model/orders/place_stock_order_view_model.dart';
import 'view_model/rate_list/binding/add_binding_view_model.dart';
import 'view_model/rate_list/design/add_design_view_model.dart';
import 'view_model/rate_list/design/design_view_model.dart';
import 'view_model/rate_list/numbering/add_numbering_view_model.dart';
import 'view_model/rate_list/numbering/numbering_view_model.dart';
import 'view_model/rate_list/paper_cutting/paper_cutting_view_model.dart';
import 'views/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final auth = FirebaseAuth.instanceFor(app: app);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => AllOrdersViewModel()),
        ChangeNotifierProvider(create: (_) => LogInViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => PlaceCustomizeOrderViewModel()),
        ChangeNotifierProvider(create: (_) => PlaceStockOrderViewModel()),
        ChangeNotifierProvider(create: (_) => AllSuppliersViewModel()),
        ChangeNotifierProvider(create: (_) => AddSupplierViewModel()),
        ChangeNotifierProvider(create: (_) => AllStockViewModel()),
        ChangeNotifierProvider(create: (_) => AddStockViewModel()),
        ChangeNotifierProvider(create: (_) => StockDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => SupplierOrdersHistoryViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ChangeNotifierProvider(create: (_) => CashbookViewModel()),
        ChangeNotifierProvider(create: (_) => AddBindingViewModel()),
        ChangeNotifierProvider(create: (_) => BindingViewModel()),
        ChangeNotifierProvider(create: (_) => DesignViewModel()),
        ChangeNotifierProvider(create: (_) => AddDesignViewModel()),
        ChangeNotifierProvider(create: (_) => AddNumberingViewModel()),
        ChangeNotifierProvider(create: (_) => NumberingViewModel()),
        ChangeNotifierProvider(create: (_) => AddPaperCuttingViewModel()),
        ChangeNotifierProvider(create: (_) => PaperCuttingViewModel()),
        ChangeNotifierProvider(create: (_) => AddMachineViewModel()),
        ChangeNotifierProvider(create: (_) => MachineViewModel()),
        ChangeNotifierProvider(create: (_) => AddNewsPaperViewModel()),
        ChangeNotifierProvider(create: (_) => NewsPaperViewModel()),
        ChangeNotifierProvider(create: (_) => AddPaperViewModel()),
        ChangeNotifierProvider(create: (_) => PaperViewModel()),
        ChangeNotifierProvider(create: (_) => AddProfitViewModel()),
        ChangeNotifierProvider(create: (_) => ProfitViewModel()),
        ChangeNotifierProvider(create: (_) => AddCashbookEntryViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          // colorSchemeSeed: kSecColor,
          colorScheme: ColorScheme.fromSeed(seedColor: kTwo),
          // primarySwatch: Colors.green,
          appBarTheme: AppBarTheme(
            toolbarHeight: 45,
            titleTextStyle: TextStyle(
              color: kNew4,
              fontSize: 24,
              // wordSpacing: 2,
              letterSpacing: 1,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
            // backgroundColor: kPrimeColor,
            backgroundColor: kTwo,
            foregroundColor: kNew4,
          ),
          scaffoldBackgroundColor: kTwo,
          // useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Printing Press',
        home: const SplashView(),
      ),
    );
  }
}
