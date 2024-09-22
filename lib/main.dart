import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/firebase_options.dart';
import 'package:printing_press/view_model/auth/log_in_view_model.dart';
import 'package:printing_press/view_model/auth/sign_up_view_model.dart';
import 'package:printing_press/view_model/orders/place_order_view_model.dart';
import 'package:printing_press/view_model/stock/add_stock_view_model.dart';
import 'package:printing_press/view_model/suppliers/add_supplier_view_model.dart';
import 'package:printing_press/view_model/suppliers/all_suppliers_view_model.dart';
import 'package:provider/provider.dart';
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
        ChangeNotifierProvider(create: (_) => LogInViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => PlaceOrderViewModel()),
        ChangeNotifierProvider(create: (_) => AddSupplierViewModel()),
        ChangeNotifierProvider(create: (_) => AllSuppliersViewModel()),
        ChangeNotifierProvider(create: (_) => AddStockViewModel()),
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
