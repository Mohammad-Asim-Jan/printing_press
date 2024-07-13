import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:printing_press/views/orders/all_orders_view.dart';
import 'package:printing_press/views/auth/log_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get auth => _auth;

  signUp(String email, String password, BuildContext context) async {
    await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      Fluttertoast.showToast(msg: value.user!.email.toString());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogIn()));
      return null;
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
      return null;
    });
  }

  logIn(String email, String password, BuildContext context) async {
    await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      Fluttertoast.showToast(msg: value.user!.email.toString());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AllOrdersView()));
      return null;
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
      return null;
    });
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(msg: 'Successfully Log out!');
      return true;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
    // await auth.signOut().then((value) => () {
    //           Navigator.of(context)
    //               .pushReplacement(MaterialPageRoute(builder: (context) {
    //             return const LogIn();
    //           }));
    //         })
    //     .onError((error, stackTrace) => () {
    //           Fluttertoast.showToast(msg: error.toString());
    //           return;
    //         });
  }

  navigate(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogIn()));
  }
}
