import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lna/components/custom_snackbar.dart';
import 'package:lna/components/form_error.dart';
import 'package:lna/screens/otp_verify_screen.dart';
import 'package:lna/screens/splash/animated_splash_screen.dart';
import 'package:lna/screens/splash/components/default_button.dart';
import 'package:lna/utils/constant.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lna/screens/database/insert.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gWidth / 25),
          child: Column(
            children: [
              SizedBox(
                height: gHeight / 50,
              ),
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: gHeight / 1500,
              ),
              Text(
                "Sign in with your phone number",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: gHeight / 10,
              ),
              SignForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  TextEditingController phoneN = TextEditingController();
  TextEditingController otp = TextEditingController();
  //final formKey = GlobalKey<FormState>();
  final List<String> errors = ["Demo Error"];
  bool isHiddenPassword = true;
  bool otpVisibility = false;
  bool registerVisibility = true;
  
  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationID = "";
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: gHeight / 40),
              buildPhoneNumberFormField(),
              SizedBox(height: gHeight / 40),
              buildOTPFormField(),
              // FormErrors(errors: errors),
              SizedBox(height: gHeight / 20),
              DefaultButton(
                press: () {
                  if (phoneN.text.length < 10 && phoneN.text.length > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CustomSnackBarContent(
                            errorMessage:
                                'You entered a missing number, correct it immediately.'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  } else if (phoneN.text.length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CustomSnackBarContent(
                            errorMessage:
                                "You didn't enter a number, write it immediately."),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  } else {
                    if (otpVisibility==true&&registerVisibility==false) {
                      verifyOTP();
                    } else {
                      phoneNExists();
                    }
                  }
                },
                text: otpVisibility ? 'Verify' : 'Login',
              ),
              SizedBox(height: gHeight / 40),
              RegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
/*       validator: (value) {
        if (value!.isEmpty) {
          setState(() {
            errors.add("Please enter your phone number");
          });
        }
        return null;
      }, */
      maxLength: 10,
      controller: phoneN,
      showCursor: false,
      decoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
          child: Text('+90'),
        ),
        labelText: "phone Number",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Enter your phone",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.phone_android,
          color: buttonColor,
        ),
      ),
    );
  }
  Visibility RegisterButton(){
    return Visibility(
      child: DefaultButton(
        text: 'Register',
        press: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Register(),
            ),
          ).then((value) => phoneN.clear());
        }
      ),
      visible: registerVisibility,
    );
  }

  Visibility buildOTPFormField() {
    return Visibility(
      child: Container(
        child: TextFormField(
          keyboardType: TextInputType.number,
          maxLength: 6,
          /*validator: (value) {
            if (value!.isEmpty) {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CustomSnackBarContent(
                        errorMessage:
                            'You entered a missing OTP, correct it immediately.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                );
              });
            }
            return null;
          },*/
          controller: otp,
          showCursor: false,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.code,
              color: buttonColor,
            ),
            /* suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isHiddenPassword = !isHiddenPassword;
                  });
                },
                child: Icon(isHiddenPassword
                    ? Icons.visibility_off
                    : Icons.visibility)), */
            labelText: "OTP",
            labelStyle: TextStyle(color: iconColor),
            hintText: "Enter your OTP",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ),
      visible: otpVisibility,
    );
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
        /*if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomSnackBarContent(
                errorMessage:
                    'You entered a invalid number, correct it immediately.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }*/
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        registerVisibility = false;
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
    if (credential.smsCode.toString().length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomSnackBarContent(
            errorMessage: 'You must enter OTP number, write it immediately.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else if (credential.smsCode.toString().length < 6 &&
        credential.smsCode.toString().length > 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomSnackBarContent(
            errorMessage:
                'You entered missing OTP number, correct it immediately.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else if (credential.smsCode.toString() != otp.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomSnackBarContent(
            errorMessage: "OTP number doens't match, correct it immediately."),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else {
      await auth.signInWithCredential(credential).then(
        (value) {
          print("You are logged in successfully");
          Fluttertoast.showToast(
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: buttonColor,
            textColor: Colors.white,
            fontSize: 16,
          );
        },
      ).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreenWAnimated(),
          ),
        );
      });
    }
  }

  void phoneNExists() async{
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Users').get();
    

    if(snapshot.exists){
      List<User> items = [];
      Map<dynamic,dynamic> data = snapshot.value as Map;

      data.forEach((key, value) {
        items.add(User(value['user_name'],value['phone_number']));
      });

      for (var element in items) {
        if(element.phone==phoneN.text){
          loginWithPhone();
          break;
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomSnackBarContent(
              errorMessage:
                "Number doesn't exist. Try to register"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
        }
      }
    }else{
      print('no data');
    }
  }
}

class User {
  final String name;
  final String phone;

  User(this.name, this.phone);
}
