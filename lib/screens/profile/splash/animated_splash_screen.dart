import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lna/main.dart';
import 'package:lna/screens/profile/profile_page.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreenPAnimated extends StatelessWidget {
  const SplashScreenPAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset("assets/jsonFiles/happyman.json"),
      splashIconSize: gHeight / 4,
      backgroundColor: Colors.white,
      nextScreen: ProfilePage(),
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}