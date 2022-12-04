import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lna/screens/sign_in/components/body.dart';
import 'package:lna/screens/splash/components/default_button.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/components/custom_snackbar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
 
  @override
  State<Register> createState() => _RegisterState();
}
 
class _RegisterState extends State<Register> {
  
  final  username = TextEditingController();
  final  phoneN= TextEditingController();
 
  late DatabaseReference dbRef;
 
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Users');
  }
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: gHeight / 50),
              Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: gHeight / 1500),
              Text(
                "Fill in your name and number",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100),
              TextField(
                controller: username,
                keyboardType: TextInputType.text,
                showCursor: false,
                decoration: InputDecoration(
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  labelText: "User Name",
                  labelStyle: TextStyle(color: iconColor),
                  hintText: "Enter your name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(
                    Icons.account_circle,
                    color: buttonColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: phoneN,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                showCursor: false,
                decoration: InputDecoration(
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+90'),
                  ),
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: iconColor),
                  hintText: "Enter your phone",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(
                    Icons.phone_android,
                    color: buttonColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DefaultButton(
                press: () {
                  if(phoneN.text.length<10){
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
                  }else if(username.text.length==0){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CustomSnackBarContent(
                            errorMessage:
                                'Fill in username'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );   
                  }else{
                    Map<String, String> users = {
                      'user_name': username.text,
                      'phone_number': phoneN.text,
                    };
  
                    dbRef.push().set(users);

                    Navigator.pop(context);
                  }  
                },
                text: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}