import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/firebase_services/splash_services.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';

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
          Text(
            /// todo: designing the app name here
            'Printing Press',
            style: TextStyle(
              color: kPrimeColor,
              fontFamily: 'FredokaOne',
              fontSize: 40,
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          Text('Track Orders | Manage Finances | Optimize Workflow',
              style: kDescriptionTextStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const Spacer(
            flex: 5,
          ),
          Divider(
            color: kPrimeColor,
            endIndent: 30,
            indent: 30,
            thickness: 0.7,
            height: 0,
          ),
          SizedBox(
            height: 90,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Product by',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Iowan',
                    color: kPrimeColor,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
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
                    wordSpacing: 2,
                    color: kPrimeColor,
                    fontSize: 24,
                    fontFamily: 'GreatVibes',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
