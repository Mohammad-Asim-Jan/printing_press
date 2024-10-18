import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing_press/views/home/home_view.dart';
import '../../utils/toast_message.dart';

class LogInViewModel with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  bool _obscureText = true;
  get obscureText => _obscureText;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  get auth => _auth;

  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  late String email;
  late String password;

  logIn(BuildContext context) async {
    setLoading(true);
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        debugPrint('loading became true.');
        email = emailC.text.trim();
        password = passwordC.text.trim();
        // try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          setLoading(false);
          debugPrint('loading became false 1.');
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeView()));
        }).onError((error, stackTrace) {
          setLoading(false);
          Utils.showMessage(error.toString());
        });
        // } catch (e) {
        //   setLoading(false);
        //   debugPrint('loading became false 2.');
        //   Utils.showMessage(e.toString());
        // }
      } else {
        setLoading(false);
      }
    }
    setLoading(false);
  }

  swap() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
