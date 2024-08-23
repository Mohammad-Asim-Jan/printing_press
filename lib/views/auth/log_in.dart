import 'package:flutter/material.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/view_model/auth/log_in_view_model.dart';
import 'package:printing_press/views/auth/sign_up.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import '../../components/round_button.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late LogInViewModel logInViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logInViewModel = Provider.of<LogInViewModel>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Login',
              style: TextStyle(
                color: kOne,
                fontSize: 33,
                wordSpacing: 2,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
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
                      iconData: Icons.email_outlined,
                      hint: 'Email',
                      validatorText: 'Please provide email',
                    ),
                    CustomTextField(
                      controller: logInViewModel.passwordC,
                      textInputType: TextInputType.emailAddress,
                      iconData: Icons.lock_outline_rounded,
                      hint: 'Password',
                      validatorText: 'Please provide password',
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
