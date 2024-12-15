import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/views/auth/log_in_view.dart';
import 'package:printing_press/views/home/home_view.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    /// todo: if logged in, goto home-view else goto signup
    Firebase.initializeApp();

    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LogInView()));
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeView()));
      });
    }
  }
}
