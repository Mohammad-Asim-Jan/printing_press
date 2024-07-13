import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/firebase_services/auth_services.dart';
import 'package:printing_press/views/auth/log_in.dart';
import '../../firebase_services/firebase_firestore_services.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  var emailC = TextEditingController();
  var passwordC = TextEditingController();


  setSignUp() {
    if (_formKey.currentState!.validate()) {
      try {
        /// todo: firebase sign up
        AuthServices authServices = AuthServices();
        authServices.signUp(emailC.text.toString(), passwordC.text.toString(), context);
        debugPrint('Sign Up Page User Created!');

        /// todo: firestore
        final FirebaseAuth auth = authServices.auth;
        Timer(const Duration(seconds: 2), () {
          FirebaseFirestoreServices firestoreServices = FirebaseFirestoreServices(auth: auth);
          firestoreServices.initialData();
          authServices.signOut();
        });

      } on FirebaseException catch (e) {

        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      return;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text('Sign up',
                style: TextStyle(
                    color: kOne,
                    fontSize: 33,
                    wordSpacing: 2,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 230,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: kPrimeColor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        hintText: 'Email',
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2,
                            color: kPrimeColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: kSecColor,
                          ),
                        ),
                      ),
                      validator: (text) {
                        if (text == '' || text == null) {
                          return 'Please provide email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordC,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: kPrimeColor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 24,
                        ),
                        hintText: 'Password',
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2,
                            color: kPrimeColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: kSecColor,
                          ),
                        ),
                      ),
                      validator: (text) {
                        if (text == '' || text == null) {
                          return 'Please provide password';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: kPrimeColor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 24,
                        ),
                        hintText: 'Confirm password',
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2,
                            color: kPrimeColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: kSecColor,
                          ),
                        ),
                      ),
                      validator: (text) {
                        if (text == '' || text == null) {
                          return 'Please provide password';
                        } else if (passwordC.text != text) {
                          return 'Passwords don\'t match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            RoundButton(
              title: 'Create Account',
              onPress: () {
                setSignUp();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?   ',
                  style: TextStyle(
                    fontSize: 16,
                    color: kOne,
                  ),
                ),
                RoundButton(
                  title: 'Login',
                  onPress: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LogIn()));
                  },
                  unFill: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
