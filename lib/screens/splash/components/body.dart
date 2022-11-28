import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lna/screens/sign_in/sign_in_screen.dart';
import 'package:lna/screens/splash/components/default_button.dart';
import 'package:lna/screens/splash/components/splash_content.dart';
import 'package:lna/screens/login.dart';
import 'package:lna/screens/register.dart';
import 'package:lna/screens/splash/splash_screen.dart';
import 'package:lna/utils/constant.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to LNA, Let's socialize!",
      "image": "assets/images/splash1.jpg"
    },
    {"text": "Meet up!", "image": "assets/images/splash2.jpg"},
    {"text": "Have fun!", "image": "assets/images/splash3.jpg"}
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      child: Column(children: [
        Expanded(
          flex: 3,
          child: PageView.builder(
            onPageChanged: ((value) {
              setState(() {
                currentPage = value;
              });
            }),
            itemCount: splashData.length,
            itemBuilder: (context, index) => SplashContent(
              text: splashData[index]["text"],
              image: splashData[index]["image"],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: gWidth / 14),
            child: Column(children: [
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  splashData.length,
                  (index) => buildDot(index: index),
                ),
              ),
              Spacer(flex: 3),
              DefaultButton(
                text: "Continue",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ));
                },
              ),
              Spacer(),
            ]),
          ),
        ),
      ]),
    ));
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? buttonColor : iconColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
