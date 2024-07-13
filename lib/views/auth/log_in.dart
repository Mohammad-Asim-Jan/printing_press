import 'package:flutter/material.dart';
import 'package:printing_press/firebase_services/auth_services.dart';
import 'package:printing_press/views/auth/sign_up.dart';

import '../../colors/color_palette.dart';
import '../../components/round_button.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  AuthServices authServices = AuthServices();

  setLogin() {
    if (_formKey.currentState!.validate()) {
      /// todo: check either working or not
      authServices.logIn(emailC.text, passwordC.text, context);
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
            Text('Login',
                style: TextStyle(
                  color: kOne,
                  fontSize: 33,
                  wordSpacing: 2,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),),
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 155,
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
                  ],
                ),
              ),
            ),
            const Spacer(),
            RoundButton(
              title: 'Log In',
              onPress: () {
                setLogin();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?   ',
                  style: TextStyle(
                    fontSize: 16,
                    color: kOne,
                  ),
                ),
                RoundButton(
                  title: 'Sign Up',
                  onPress: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SignUp()));
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
