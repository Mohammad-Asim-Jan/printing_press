import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/toast_message.dart';
import '../../views/orders/all_orders_view.dart';

class LogInViewModel with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

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

  logIn(BuildContext context) async {
    setLoading(true);

    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        debugPrint('loading became true.');
        try {
          await _auth
              .signInWithEmailAndPassword(
            email: emailC.text.trim(),
            password: passwordC.text.trim(),
          )
              .then((value) {
            setLoading(false);
            debugPrint('loading became false 1.');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AllOrdersView()));
          }).onError((error, stackTrace) {
            setLoading(false);
            Utils.showMessage(error.toString());
          });
        } catch (e) {
          setLoading(false);
          debugPrint('loading became false 2.');
          Utils.showMessage(e.toString());
        }
      } else {
        setLoading(false);
      }
    }
    setLoading(false);
  }
}
