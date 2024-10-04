import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/firebase_options.dart';
import 'package:printing_press/view_model/cashbook/cashbook_view_model.dart';
import 'package:printing_press/view_model/home/home_view_model.dart';
import 'package:printing_press/view_model/auth/log_in_view_model.dart';
import 'package:printing_press/view_model/auth/sign_up_view_model.dart';
import 'package:printing_press/view_model/orders/place_order_view_model.dart';
import 'package:printing_press/view_model/payment/payment_view_model.dart';
import 'package:printing_press/view_model/rate_list/binding/binding_view_model.dart';
import 'package:printing_press/view_model/rate_list/paper_cutting/add_paper_cutting_view_model.dart';
import 'package:printing_press/view_model/rate_list/rate_list_view_model.dart';
import 'package:printing_press/view_model/stock/add_stock_view_model.dart';
import 'package:printing_press/view_model/stock/all_stock_view_model.dart';
import 'package:printing_press/view_model/suppliers/add_supplier_view_model.dart';
import 'package:printing_press/view_model/suppliers/all_suppliers_view_model.dart';
import 'package:printing_press/view_model/suppliers/supplier_orders_history_view_model.dart';
import 'package:provider/provider.dart';
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
        ChangeNotifierProvider(create: (_) => LogInViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => PlaceOrderViewModel()),
        ChangeNotifierProvider(create: (_) => AllSuppliersViewModel()),
        ChangeNotifierProvider(create: (_) => AddSupplierViewModel()),
        ChangeNotifierProvider(create: (_) => AllStockViewModel()),
        ChangeNotifierProvider(create: (_) => AddStockViewModel()),
        ChangeNotifierProvider(create: (_) => SupplierOrdersHistoryViewModel()),
        ChangeNotifierProvider(create: (_) => RateListViewModel()),
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
      ],
      child: MaterialApp(
        theme: ThemeData(
          // colorSchemeSeed: kSecColor,
          colorScheme: ColorScheme.fromSeed(seedColor: kTwo),
          // primarySwatch: Colors.green,
          appBarTheme: AppBarTheme(
            toolbarHeight: 45,
            titleTextStyle: const TextStyle(
              fontSize: 24,
              wordSpacing: 2,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
            backgroundColor: kOne,
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: kSecColor,
          // useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Printing Press',
        home: const SplashView(),
      ),
    );
  }
}
