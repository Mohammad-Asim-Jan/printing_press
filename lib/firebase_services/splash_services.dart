import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/views/orders/all_orders_view.dart';
import 'package:printing_press/views/auth/log_in.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    /// todo: if logged in, goto home-view else goto signup
    Firebase.initializeApp();

    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LogIn()));
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AllOrdersView()));
      });
    }
  }
}
