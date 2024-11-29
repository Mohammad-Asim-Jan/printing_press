import 'package:flutter/material.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/utils/validation_functions.dart';
import 'package:printing_press/view_model/auth/log_in_view_model.dart';
import 'package:printing_press/views/auth/sign_up_view.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import '../../components/round_button.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  late LogInViewModel logInViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logInViewModel = Provider.of<LogInViewModel>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'LOGIN',
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
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 155,
              child: Form(
                key: logInViewModel.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextField(
                        controller: logInViewModel.emailC,
                        textInputType: TextInputType.emailAddress,
                        iconData: Icons.email,
                        hint: 'Email',
                        validators: [isEmailValid, isNotEmpty]),
                    Consumer<LogInViewModel>(
                      builder: (context, value, child) {
                        return TextFormField(
                          controller: logInViewModel.passwordC,
                          cursorColor: kPrimeColor,
                          obscureText: value.obscureText,
                          keyboardType: TextInputType.emailAddress,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  value.swap();
                                },
                                icon: Icon(value.obscureText
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
                              )),
                          validator: (text) {
                            if (text == '' || text == null) {
                              return 'Please provide password';
                            } else if (text.length < 6) {
                              return 'Password minimum length is 6';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Consumer<LogInViewModel>(
              builder: (context, value, child) => RoundButton(
                title: 'Log In',
                loading: value.loading,
                onPress: () {
                  value.logIn(context);
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
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: kOne,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SignUpView()));
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Sign Up',
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
