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
            ),
            const SizedBox(height: 70),
            Consumer<SignUpViewModel>(
              builder: (context, val, child) => Form(
                key: val.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextField(
                        controller: val.emailC,
                        iconData: Icons.email,
                        hint: 'Email',
                        textInputType: TextInputType.emailAddress,
                        validators: const [isEmailValid, isNotEmpty]),
                    CustomTextField(
                      controller: val.passwordC,
                      obscureText: val.obscureText1,
                      iconData: Icons.lock,
                      suffixIcon: IconButton(
                        onPressed: () {
                          val.swap1();
                        },
                        icon: Icon(val.obscureText1
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded),
                      ),
                      hint: 'Password',
                      validators: [
                        isNotEmpty,
                        (value) => hasMinLength(value),
                      ],
                    ),
                    CustomTextField(
                      controller: val.confirmPasswordC,
                      obscureText: val.obscureText2,
                      iconData: Icons.lock,
                      suffixIcon: IconButton(
                        onPressed: () {
                          val.swap2();
                        },
                        icon: Icon(val.obscureText2
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded),
                      ),
                      hint: 'Confirm password',
                      validators: [
                        isNotEmpty,
                        (value) => hasMinLength(value),
                        (value) => isPasswordMatch(value, val.passwordC.text),
                      ],
                    )
                  ],
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    color: kNew9a,
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
                        color: kNew4,
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
