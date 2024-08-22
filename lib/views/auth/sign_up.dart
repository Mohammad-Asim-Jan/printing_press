import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/views/auth/log_in.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth/sign_up_view_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

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
            Consumer<SignUpViewModel>(
              builder: (context, value, child) => SizedBox(
                height: 230,
                child: Form(
                  key: value.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextField(
                        controller: value.emailC,
                        textInputType: TextInputType.emailAddress,
                        iconData: Icons.email_outlined,
                        hint: 'Email',
                        validatorText: 'Please provide email',
                      ),
                      CustomTextField(
                        controller: value.passwordC,
                        textInputType: TextInputType.text,
                        iconData: Icons.lock_outline_rounded,
                        hint: 'Password',
                        validatorText: 'Please provide password',
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
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
                          } else if (value.passwordC.text != text) {
                            return 'Passwords don\'t match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Consumer<SignUpViewModel>(
              builder: (context, value, child) => RoundButton(
                title: 'Create Account',
                loading: value.loading,
                onPress: () {
                  value.signUp(context);
                },
              ),
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
