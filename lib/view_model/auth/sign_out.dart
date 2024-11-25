import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../colors/color_palette.dart';
import '../../utils/toast_message.dart';
import '../../views/auth/log_in_view.dart';

class SignOut {
  FirebaseAuth auth = FirebaseAuth.instance;

  void logOut(BuildContext context) async {
    try {
      await auth.signOut();
      Utils.showMessage('Successfully Log out!');

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogInView()));
    } on FirebaseAuthException catch (e) {
      Utils.showMessage(e.toString());
    }
  }

  confirmLogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kTwo,
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          title: const Text("Confirm Log out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                logOut(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
