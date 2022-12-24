import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lna/main.dart';
import 'package:lna/screens/friends/search_Users_list.dart';
import 'package:lna/utils/constant.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreenFAnimated extends StatelessWidget {
  const SplashScreenFAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset("assets/jsonFiles/happyman.json"),
      splashIconSize: gHeight / 4,
      backgroundColor: Colors.white,
      nextScreen: searchLNAUserBar(),
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}