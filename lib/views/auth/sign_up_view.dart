import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/views/auth/log_in_view.dart';
import 'package:provider/provider.dart';
import '../../view_model/auth/sign_up_view_model.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'SIGN UP',
              style: TextStyle(
                color: kNew4,
                // color: kOne,
                fontSize: 33,
                fontFamily: 'FredokaOne',
                wordSpacing: 2,
                letterSpacing: 6,
                // fontWeight: FontWeight.bold,
              ),
              // style: TextStyle(
              //     color: kNew4,
              //     // color: kOne,
              //     fontSize: 33,
              //     wordSpacing: 2,
              //     letterSpacing: 3,
              //     fontWeight: FontWeight.bold)
            ),
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
                          iconData: Icons.email,
                          hint: 'Email',
                          textInputType: TextInputType.emailAddress,
                          validators: const [isEmailValid, isNotEmpty]),
                      TextFormField(
                        controller: value.passwordC,
                        cursorColor: kPrimeColor,
                        obscureText: value.obscureText1,
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              value.swap1();
                            },
                            icon: Icon(value.obscureText1
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: kNew8,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: kNew8,
                              ),
                            )
                        ),
                        validator: (text) {
                          if (text == '' || text == null) {
                            return 'Please provide password';
                          } else if (text.length < 6) {
                            return 'Password minimum length is 6';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        cursorColor: kPrimeColor,
                        obscureText: value.obscureText2,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 24,
                          ),
                          hintText: 'Confirm password',
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              value.swap2();
                            },
                            icon: Icon(value.obscureText2
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded),
                          ),
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: kNew8,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: kNew8,
                              ),
                            )
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
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    color: kOne,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LogInView()));
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: kNew9a,
                        fontFamily: 'FredokaOne',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
