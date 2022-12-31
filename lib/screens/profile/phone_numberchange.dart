import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/screens/profile/profile_edit.dart';
import 'package:lna/screens/profile/splash/animated_splash_screen.dart';
import 'package:lna/utils/custom_snackbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class phoneNumberChange extends StatefulWidget {
  const phoneNumberChange({Key? key, required this.newPhone, required this.userK}) : super(key: key);

  final String newPhone;
  final String userK;

  State<phoneNumberChange> createState() => _phoneNumberChangeState();
}

class _phoneNumberChangeState extends State<phoneNumberChange> {
  final newPhoneController = TextEditingController();
  final smsCodeController = TextEditingController();

  bool isHiddenPassword = true;
  bool otpVisibility = false;
  bool phoneVisibility = true;
  bool registerVisibility = true;

  late DatabaseReference dbref;
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationID = "";
  
  void initState() {
    super.initState();
    newPhoneController.text = widget.newPhone;
    dbref = FirebaseDatabase.instance.ref().child('Users').child(widget.userK);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            },
            icon: Icon(LineAwesomeIcons.arrow_left)),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: gHeight / 40),
            buildNewPhoneFormField(),
            buildSMSCodeFormField(),
            SizedBox(height: gHeight / 40),
            DefaultButton(
              text: otpVisibility ? 'Verify' : 'Update', 
              press: () async{
                if (newPhoneController.text.length < 10 && newPhoneController.text.length > 0) {
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
                } else if (newPhoneController.text.length == 0) {
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
                  if (otpVisibility == true &&
                      registerVisibility == false &&
                      phoneVisibility == false) {
                    verifyOTP();
                  } else {
                    phoneNExists();
                  }
                }
              },
            ),
          ]
        )
      )
    );
  }

  TextFormField buildNewPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 10,
      controller: newPhoneController,
      showCursor: false,
      decoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
          child: Text('+90'),
        ),
        labelText: "New phone number",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Enter your new number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.phone_android,
          color: buttonColor,
        ),
      ),
    );
  }

  TextFormField buildSMSCodeFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: smsCodeController,
      showCursor: true,
      decoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "SMS Code",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Enter your previous sms code",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.message,
          color: buttonColor,
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+90" + newPhoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.currentUser!.updatePhoneNumber(credential).then((value) {
          print("New number has been saved");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomSnackBarContent(errorMessage: 'Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        registerVisibility = false;
        otpVisibility = true;
        phoneVisibility = false;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID, 
      smsCode: smsCodeController.text
    );
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
    } else {
      try {
        await auth.currentUser!.updatePhoneNumber(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreenPAnimated(),
          ),
        );
        Fluttertoast.showToast(
          msg: "Your number has been saved successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: buttonColor,
          textColor: Colors.white,
          fontSize: 16,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-verification-code') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomSnackBarContent(
                errorMessage:
                    "OTP number doens't match, correct it immediately."),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomSnackBarContent(
              errorMessage:
                  "OTP number doens't match, correct it immediately."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      }
    }
  }

  void phoneNExists() {
    if(widget.newPhone!=newPhoneController.text){
      dbref.update({
        'phone_number': newPhoneController
      });
      ch();
    }else{
      ch();
    }
  }
  void ch () async{
    List<String> phones = [];
    List<Customer> items = await customerListMaker();

    for (var element in items) {
      if (element.phone == newPhoneController.text) {
        continue;
      } else {
        phones.add(element.phone);
      }
    }
    if (phones.contains(newPhoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarContent(
              errorMessage: "The number already exists, try another number"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    } else {
      loginWithPhone();
    }
  }

}