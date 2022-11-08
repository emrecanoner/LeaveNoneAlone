import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lna/main.dart';
import 'package:lna/screens/register.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_oauth2/riverpod/riverpod_management.dart';
//import 'package:lna/screens/signup.dart';
import 'package:lna/utils/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isHiddenPassword = true;
  TextEditingController phoneN = TextEditingController();
  TextEditingController otp = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool otpVisibility = false;

  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        //onTap: () => FocusManagerinstance.primaryFocus?.unfocus(),
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: gWidth,
          height: gHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                width: gWidth,
                height: gHeight / 4,
                child: Image.asset("assets/images/lnabig.png"),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, right: 260),
                width: gWidth / 4,
                height: gHeight / 14,
                child: FittedBox(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xffffaa17),
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          //inputFormatters: [maskFormatter],
                          controller: phoneN,
                          readOnly: false,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          showCursor: false,
                          decoration: InputDecoration(
                              prefix: Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('+90'),
                              ),
                              prefixIcon: Icon(LineIcons.phone),
                              suffixIcon: null,
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: buttonColor, width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Visibility(
                child: Container(
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
                            controller: otp,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            obscureText: isHiddenPassword,
                            readOnly: false,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            showCursor: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(LineIcons.alternateUnlock),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isHiddenPassword = !isHiddenPassword;
                                      });
                                    },
                                    child: Icon(isHiddenPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: buttonColor, width: 2),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2),
                                ),
                                hintText: 'OTP',
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
                visible: otpVisibility,
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: gWidth,
                height: gHeight / 15,
                child: ElevatedButton(
                  onPressed: () {
                    if (otpVisibility) {
                      verifyOTP();
                    } else {
                      loginWithPhone();
                    }
                  },
                  child: Text(
                    otpVisibility ? 'Verify' : 'Login',
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
                ),
              ),
              /* SizedBox(height: 15),
              Container(
                width: gWidth,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 130,
                        height: 0.5,
                        color: iconColor,
                      ),
                      Text(
                        '  OR  ',
                        style: TextStyle(color: iconColor, fontSize: 20),
                      ),
                      Container(
                        width: 130,
                        height: 0.5,
                        color: iconColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: gWidth,
                height: gHeight / 15,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ));
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset("assets/images/lnablacktrans.png"),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "New To Leave None Alone? Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          buttonColor.withOpacity(0.5)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.black,
                      )),
                ),
              ), */
            ],
          ),
        ),
      ),
    ));
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+90" + phoneN.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otp.text);

    await auth.signInWithCredential(credential).then(
      (value) {
        print("You are logged in successfully");
        Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
      },
    ).whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(),
        ),
      );
    });
  }
}
