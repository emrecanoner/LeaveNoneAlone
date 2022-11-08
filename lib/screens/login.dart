import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
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

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isHiddenPassword = true;
  //TextEditingController phoneN = TextEditingController();
  //TextEditingController password = TextEditingController();

/*   Future login() async {
    var url = 'https://10.0.2.2/lna/login.php';

    var response = await http.post(Uri.parse(url),
        headers: {"ContentType": "application/json"},
        body: jsonEncode({
          "phoneNumber": phoneN.text,
          "password": password.text,
        }));

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);
      if (data == 'Success') {
        Fluttertoast.showToast(
          msg: 'Login Successful',
          backgroundColor: Color(0xffFFAA17),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Phone number or password invalid',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      print("Error");
    }
  }

  fetchData() async {
    var url = Uri.https('10.0.2.2', 'lna/login.php');
    var res = await http.post(url,
        body: jsonEncode({
          "phoneNumber": phoneN.text,
          "password": password.text,
        }));
    var responseCode = res.statusCode;
    if (responseCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    }
  } */

  String? errormsg;
  bool? error, showprogress;
  String? phoneNumber, pass;

  var phoneN = TextEditingController();
  var password = TextEditingController();

  startLogin() async {
    var url = Uri.https('10.0.2.2', 'lna/login.php'); //api url
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP
    print(phoneNumber);

    var response = await http.post(url, body: {
      'phoneNumber': phoneNumber, //get the username text
      'password': pass //get password text
    });

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["error"]) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        if (jsondata["success"]) {
          setState(() {
            error = false;
            showprogress = false;
          });
          //save the data returned from server
          //and navigate to home page
          String id = jsondata["id"];
          //user shared preference to save data
        } else {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Something went wrong.";
        }
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error during connecting to server.";
      });
    }
  }

  void initState() {
    phoneN;
    password;
    errormsg = "";
    error = false;
    showprogress = false;

    //_username.text = "defaulttext";
    //_password.text = "defaultpassword";
    super.initState();
  }

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
                          keyboardType: TextInputType.number,
                          //maxLength: 15,
                          //inputFormatters: [maskFormatter],
                          controller: phoneN,
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
                          controller: password,
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
                              hintText: 'Password',
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
                    startLogin();
                  },
                  child: Text(
                    'Login',
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
              SizedBox(height: 15),
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
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
