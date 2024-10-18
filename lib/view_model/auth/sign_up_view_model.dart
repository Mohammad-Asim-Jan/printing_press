import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/view_model/auth/sign_out.dart';
import '../../firebase_services/firebase_firestore_services.dart';
import '../../utils/toast_message.dart';

class SignUpViewModel with ChangeNotifier {
  bool _loading = false;

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  get obscureText1 => _obscureText1;

  get obscureText2 => _obscureText2;

  get loading => _loading;

  final _formKey = GlobalKey<FormState>();

  get formKey => _formKey;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  late String email;
  late String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  signUp(BuildContext context) async {
    setLoading(true);
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        email = emailC.text.trim();
        password = passwordC.text.trim();

        // try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Utils.showMessage(_auth.currentUser!.email.toString());
          // FirebaseFirestoreServices firestoreServices =
          //     FirebaseFirestoreServices(auth: _auth);
          // firestoreServices.initialData();
          SignOut().signOut(context);
          setLoading(false);
        }).onError((error, stackTrace) {
          Utils.showMessage(error.toString());
          setLoading(false);
        });
        // } catch (e) {
        //   Utils.showMessage(e.toString());
        //   setLoading(false);
        // }
      } else {
        setLoading(false);
      }
    } else {
      Utils.showMessage('Error Occurred!');
      setLoading(false);
    }
  }

  swap1() {
    _obscureText1 = !_obscureText1;
    notifyListeners();
  }

  swap2() {
    _obscureText2 = !_obscureText2;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailC.dispose();
    passwordC.dispose();
  }
}
