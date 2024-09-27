
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final  FirebaseAuth _auth = FirebaseAuth.instance;
  get auth => _auth;

  String uid() {
    return _auth.currentUser!.uid;
  }

  createAccount(String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

}