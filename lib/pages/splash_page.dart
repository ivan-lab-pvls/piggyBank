import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:financial_piggy_bank/main.dart';
import 'package:financial_piggy_bank/pages/home_page.dart';
import 'package:financial_piggy_bank/pages/onBoarding_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  //   Future.delayed(
  //     const Duration(seconds: 2),
  //     () {
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (_) => const MyHomePage(
  //                 title: 'Food',
  //               )));
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //       overlays: SystemUiOverlay.values);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xFF171030),
      duration: 1000,
      splashIconSize: double.infinity,
      splash: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: const Color(0xFF28233E),
                  borderRadius: BorderRadius.circular(21)),
              child: Image.asset(
                'assets/splash_icon.png',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 27),
              child: Text(
                'Financial Piggy Bank',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'HK Grotesk',
                    fontSize: 20,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
      nextScreen: initScreen == 0 || initScreen == null
          ? const OnBoardingPage()
          : const MyHomePage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
