import 'dart:collection';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lna/screens/splash/splash_screen.dart';
import 'package:lna/utils/constant.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userF = FirebaseAuth.instance.currentUser;
  String? pNumber;
  var tfPhoneNumber = TextEditingController();

/*   void addPhoneNumber() {
    db.getConnection().then((conn) {
      String 
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: gWidth,
              height: gHeight / 15,
              child: Center(
                child: Text(
                  "Leave",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: buttonColor,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins-Regular'),
                ),
              ),
            ),
            Container(
              width: gWidth,
              height: gHeight / 15,
              child: Center(
                child: Text(
                  "None",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins-Regular'),
                ),
              ),
            ),
            Container(
              width: gWidth,
              height: gHeight / 15,
              child: Center(
                child: Text(
                  "Alone",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: buttonColor,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins-Regular'),
                ),
              ),
            ),
            SizedBox(height: 35),
            Container(
              width: double.infinity,
              height: gHeight / 15,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 50,
                      width: gWidth / 1.2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        //maxLength: 15,
                        inputFormatters: [maskFormatter],
                        //controller: ref.read(signUpRiverpod).username,
                        readOnly: false,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        showCursor: false,
                        decoration: InputDecoration(
                            prefixIcon: Icon(LineIcons.phone),
                            suffixIcon: null,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: buttonColor, width: 2.5),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w400)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: gWidth,
                height: gHeight / 15,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ));
                    });
                    //addPhoneNumber();
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Poppins-Regular'),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(buttonColor)),
                ))
          ]),
        ),
      ),
    );
  }
}
