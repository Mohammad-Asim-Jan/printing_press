import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/firebase_options.dart';

import 'views/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final auth = FirebaseAuth.instanceFor(app: app);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              fontWeight: FontWeight.bold,),
          centerTitle: true,
          backgroundColor: kOne,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: kSecColor,
        // useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const SplashView(),
    );
  }
}