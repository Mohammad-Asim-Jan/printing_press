
import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/firebase_services/splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashServices splashServices = SplashServices();
  late Map<String, dynamic>? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Spacer(flex: 5),
        const Text(
          /// designing the app name here
          'Printing Press',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        const Spacer(
          flex: 4,
        ),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Product by',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: kPrimeColor,
                  fontStyle: FontStyle.italic,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                ///todo: change the font
                'Qasim Jan Printers',
                style: TextStyle(
                  letterSpacing: 4,
                  wordSpacing: 3,
                  color: kPrimeColor,
                  fontSize: 21,
                  fontFamily: 'BebasNeue',
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
