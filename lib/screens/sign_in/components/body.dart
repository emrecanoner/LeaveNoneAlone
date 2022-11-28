import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lna/components/form_error.dart';
import 'package:lna/screens/otp_verify_screen.dart';
import 'package:lna/screens/splash/components/default_button.dart';
import 'package:lna/utils/constant.dart';

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
  final formKey = GlobalKey<FormState>();
  final List<String> errors = ["Demo Error"];
  bool isHiddenPassword = true;
  bool otpVisibility = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationID = "";
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildPhoneNumberFormField(),
          SizedBox(height: gHeight / 40),
          buildOTPFormField(),
          // FormErrors(errors: errors),
          SizedBox(height: gHeight / 20),
          DefaultButton(
            press: () {
              if (otpVisibility) {
                verifyOTP();
              } else {
                loginWithPhone();
              }
            },
            text: otpVisibility ? 'Verify' : 'Login',
          )
        ],
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

  Visibility buildOTPFormField() {
    return Visibility(
      child: Container(
        child: TextFormField(
          keyboardType: TextInputType.number,
/*           validator: (value) {
            if (value!.isEmpty) {
              setState(() {
                errors.add("Please enter your OTP code");
              });
            }
            return null;
          }, */
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
          backgroundColor: buttonColor,
          textColor: Colors.white,
          fontSize: 16,
        );
      },
    ).whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerifyScreen(),
        ),
      );
    });
  }
}
