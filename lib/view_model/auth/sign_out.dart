import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/toast_message.dart';
import '../../views/auth/log_in.dart';

class SignOut {
  FirebaseAuth auth = FirebaseAuth.instance;

  void signOut(BuildContext context) async {
    try {
      await auth.signOut();
      Utils.showMessage('Successfully Log out!');

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogIn()));
    } on FirebaseAuthException catch (e) {
      Utils.showMessage(e.toString());
    }
  }
}
