import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lna/screens/sign_out/splash/animated_splash_screen.dart';
import 'package:lna/utils/constant.dart';

Widget? AnimatedSignOut(context) {
  Fluttertoast.showToast(
    msg: "You are logged out successfully",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: buttonColor,
    textColor: Colors.white,
    fontSize: 16,
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SplashScreenWAnimated(),
    ),
  );
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    return await auth.signOut();
  }
}
