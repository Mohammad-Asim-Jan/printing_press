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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Spacer(flex: 5),
            Text(
              'PRINTING PRESS SOLUTIONS',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 3,
                wordSpacing: 4,
                color: kPrimeColor,
                fontFamily: 'FredokaOne',
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text('Track Orders | Manage Finances | Optimize Workflow',
                style: kDescriptionTextStyle.copyWith(height: 1.2, fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
            const Spacer(flex: 6),
            Divider(
              color: kPrimeColor,
              endIndent: 60,
              indent: 60,
              thickness: 0.7,
              height: 0,
            ),
            const SizedBox(height: 10),
            Text(
              'Product by',
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: kPrimeColor,
                fontStyle: FontStyle.italic,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              ///todo: change the font
              'Qasim Jan Printers',
              style: TextStyle(
                letterSpacing: 2,
                wordSpacing: 3,
                color: kPrimeColor,
                fontSize: 18,
                fontFamily: 'GreatVibes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
