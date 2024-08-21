import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/view_model/sign_out.dart';
import '../firebase_services/firebase_firestore_services.dart';
import '../utils/toast_message.dart';
import '../views/auth/log_in.dart';

class SignUpViewModel with ChangeNotifier {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  var emailC = TextEditingController();
  var passwordC = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: emailC.text.trim(),
          password: passwordC.text.trim(),
        );

        Utils.showMessage(_auth.currentUser!.email.toString());

        FirebaseFirestoreServices firestoreServices =
            FirebaseFirestoreServices(auth: _auth);
        firestoreServices.initialData();

        SignOut().signOut(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LogIn()));
      } catch (e) {
        Utils.showMessage(e.toString());
      }
    }
  }
}
