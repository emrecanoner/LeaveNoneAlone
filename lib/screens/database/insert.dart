import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lna/screens/database/splash/animated_splash_screen.dart';
import 'package:lna/screens/database/terms_and_conditions.dart';
import 'package:lna/screens/sign_in/components/body.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/custom_snackbar.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SafeArea(
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
                  'Register Account',
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
                  "Complete your details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: gHeight / 10,
                ),
                SignUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final name = TextEditingController();
  final surname = TextEditingController();
  final age = TextEditingController();
  late SingleValueDropDownController city;
  final phoneN = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  late DatabaseReference dbRef;

  @override
  void initState() {
    city = SingleValueDropDownController();
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Users');
  }

  void dispose() {
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: gHeight / 40),
              buildNameFormField(),
              SizedBox(height: gHeight / 40),
              buildSurnameFormField(),
              SizedBox(height: gHeight / 40),
              buildCityDropdown(),
              SizedBox(height: gHeight / 40),
              buildAgeFormField(),
              SizedBox(height: gHeight / 40),
              buildPhoneNumberFormField(),
              SizedBox(height: gHeight / 40),
              TermsAndConditions(),
              SizedBox(height: gHeight / 20),
              DefaultButton(
                press: () async {
                  if (name.text.length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CustomSnackBarContent(
                            errorMessage:
                                "You didn't enter your name, write it immediately."),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  } else if (surname.text.length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CustomSnackBarContent(
                            errorMessage:
                                "You didn't enter your surname, write it immediately"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  } else if (selectedCity.length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CustomSnackBarContent(
                            errorMessage:
                                "You didn't select your city, select it immediately"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  } else if (age.text.length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CustomSnackBarContent(
                            errorMessage:
                                "You didn't enter your age, write it immediately"),
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
                  } else if (phoneN.text.length < 10 &&
                      phoneN.text.length > 0) {
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
                  } else {
                    userName = name.text;
                    List<String> phones = [];
                    List<Customer> items = await customerListMaker();

                    for (var element in items) {
                      phones.add(element.phone);
                    }
                    if (phones.contains(phoneN.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: CustomSnackBarContent(
                              errorMessage:
                                  "The number already exists, try another number"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      );
                    } else {
                      // String rndString = generateRandomString(19);
                      Map<String, String> users = {
                        'name': name.text,
                        'phone_number': phoneN.text,
                        'surname': surname.text,
                        'city': selectedCity,
                        'age': age.text,
                        'auth_uid': '',
                        'photoURL':'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/files%2Ficon.jpg?alt=media&token=10f30e44-905f-40da-8ebc-93f69339ac6c'
                      };

                      dbRef.push().set(users);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SplashScreenWAnimated(),
                        ),
                      );

                      Fluttertoast.showToast(
                        msg: "You are registered successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: buttonColor,
                        textColor: Colors.white,
                        fontSize: 16,
                      );
                    }
                  }
                },
                text: 'Register',
              ),
              SizedBox(height: gHeight / 50),
            ],
          ),
        ),
      ),
    );
  }
  // String generateRandomString(int length) {
  //   var rnd = new Random();
  //   var characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  //   var result = '';
  //   for (var i = 0; i < length; i++) {
  //     result += characters[rnd.nextInt(characters.length)];
  //   }
  //   return result;
  // }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
/*       validator: (value) {
        if (value!.isEmpty) {
          setState(() {
            errors.add("Please enter your phone number");
          });
        }
        return null;
      }, */
      controller: name,
      showCursor: true,
      decoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "Name",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.account_circle,
          color: buttonColor,
        ),
      ),
    );
  }

  TextFormField buildSurnameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
/*       validator: (value) {
        if (value!.isEmpty) {
          setState(() {
            errors.add("Please enter your phone number");
          });
        }
        return null;
      }, */
      controller: surname,
      showCursor: true,
      decoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "Surname",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Enter your surname",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.account_circle_outlined,
          color: buttonColor,
        ),
      ),
    );
  }

  DropDownTextField buildCityDropdown() {
    return DropDownTextField(
      controller: city,
      clearOption: true,
      enableSearch: true,
      dropDownIconProperty: IconProperty(color: buttonColor),
      clearIconProperty: IconProperty(color: buttonColor),
      searchShowCursor: true,
      searchDecoration: InputDecoration(
        labelText: "Search City",
        labelStyle: TextStyle(color: iconColor, fontSize: 13),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      textFieldDecoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "City",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Select your city",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value == null) {
          return "Required field";
        } else {
          selectedCity = value.toString();
          return null;
        }
      },
      dropDownItemCount: 6,
      dropDownList: const [
        DropDownValueModel(name: 'Adana', value: "Adana"),
        DropDownValueModel(name: 'Adıyaman', value: "Adıyaman"),
        DropDownValueModel(name: 'Afyonkarahisar', value: "Afyonkarahisar"),
        DropDownValueModel(name: 'Ağrı', value: "Ağrı"),
        DropDownValueModel(name: 'Aksaray', value: "Aksaray"),
        DropDownValueModel(name: 'Amasya', value: "Amasya"),
        DropDownValueModel(name: 'Ankara', value: "Ankara"),
        DropDownValueModel(name: 'Antalya', value: "Antalya"),
        DropDownValueModel(name: 'Ardahan', value: "Ardahan"),
        DropDownValueModel(name: 'Artvin', value: "Artvin"),
        DropDownValueModel(name: 'Aydın', value: "Aydın"),
        DropDownValueModel(name: 'Balıkesir', value: "Balıkesir"),
        DropDownValueModel(name: 'Bartın', value: "Bartın"),
        DropDownValueModel(name: 'Batman', value: "Batman"),
        DropDownValueModel(name: 'Bayburt', value: "Bayburt"),
        DropDownValueModel(name: 'Bilecik', value: "Bilecik"),
        DropDownValueModel(name: 'Bingöl', value: "Bingöl"),
        DropDownValueModel(name: 'Bitlis', value: "Bitlis"),
        DropDownValueModel(name: 'Bolu', value: "Bolu"),
        DropDownValueModel(name: 'Burdur', value: "Burdur"),
        DropDownValueModel(name: 'Bursa', value: "Bursa"),
        DropDownValueModel(name: 'Çanakkale', value: "Çanakkale"),
        DropDownValueModel(name: 'Çankırı', value: "Çankırı"),
        DropDownValueModel(name: 'Çorum', value: "Çorum"),
        DropDownValueModel(name: 'Denizli', value: "Denizli"),
        DropDownValueModel(name: 'Diyarbakır', value: "Diyarbakır"),
        DropDownValueModel(name: 'Düzce', value: "Düzce"),
        DropDownValueModel(name: 'Edirne', value: "Edirne"),
        DropDownValueModel(name: 'Elazığ', value: "Elazığ"),
        DropDownValueModel(name: 'Erzincan', value: "Erzincan"),
        DropDownValueModel(name: 'Erzurum', value: "Erzurum"),
        DropDownValueModel(name: 'Eskişehir', value: "Eskişehir"),
        DropDownValueModel(name: 'Gaziantep', value: "Gaziantep"),
        DropDownValueModel(name: 'Giresun', value: "Giresun"),
        DropDownValueModel(name: 'Gümüşhane', value: "Gümüşhane"),
        DropDownValueModel(name: 'Hakkâri', value: "Hakkâri"),
        DropDownValueModel(name: 'Hatay', value: "Hatay"),
        DropDownValueModel(name: 'Iğdır', value: "Iğdır"),
        DropDownValueModel(name: 'Isparta', value: "Isparta"),
        DropDownValueModel(name: 'İstanbul', value: "İstanbul"),
        DropDownValueModel(name: 'İzmir', value: "İzmir"),
        DropDownValueModel(name: 'Kahramanmaraş', value: "Kahramanmaraş"),
        DropDownValueModel(name: 'Karabük', value: "Karabük"),
        DropDownValueModel(name: 'Karaman', value: "Karaman"),
        DropDownValueModel(name: 'Kars', value: "Kars"),
        DropDownValueModel(name: 'Kastamonu', value: "Kastamonu"),
        DropDownValueModel(name: 'Kayseri', value: "Kayseri"),
        DropDownValueModel(name: 'Kilis', value: "Kilis"),
        DropDownValueModel(name: 'Kırıkkale', value: "Kırıkkale"),
        DropDownValueModel(name: 'Kırklareli', value: "Kırklareli"),
        DropDownValueModel(name: 'Kırşehir', value: "Kırşehir"),
        DropDownValueModel(name: 'Kocaeli', value: "Kocaeli"),
        DropDownValueModel(name: 'Konya', value: "Konya"),
        DropDownValueModel(name: 'Kütahya', value: "Kütahya"),
        DropDownValueModel(name: 'Malatya', value: "Malatya"),
        DropDownValueModel(name: 'Manisa', value: "Manisa"),
        DropDownValueModel(name: 'Mardin', value: "Mardin"),
        DropDownValueModel(name: 'Mersin', value: "Mersin"),
        DropDownValueModel(name: 'Muğla', value: "Muğla"),
        DropDownValueModel(name: 'Muş', value: "Muş"),
        DropDownValueModel(name: 'Nevşehir', value: "Nevşehir"),
        DropDownValueModel(name: 'Niğde', value: "Niğde"),
        DropDownValueModel(name: 'Ordu', value: "Ordu"),
        DropDownValueModel(name: 'Osmaniye', value: "Osmaniye"),
        DropDownValueModel(name: 'Rize', value: "Rize"),
        DropDownValueModel(name: 'Sakarya', value: "Sakarya"),
        DropDownValueModel(name: 'Samsun', value: "Samsun"),
        DropDownValueModel(name: 'Şanlıurfa', value: "Şanlıurfa"),
        DropDownValueModel(name: 'Siirt', value: "Siirt"),
        DropDownValueModel(name: 'Sinop', value: "Sinop"),
        DropDownValueModel(name: 'Sivas', value: "Sivas"),
        DropDownValueModel(name: 'Şırnak', value: "Şırnak"),
        DropDownValueModel(name: 'Tekirdağ', value: "Tekirdağ"),
        DropDownValueModel(name: 'Tokat', value: "Tokat"),
        DropDownValueModel(name: 'Trabzon', value: "Trabzon"),
        DropDownValueModel(name: 'Tunceli', value: "Tunceli"),
        DropDownValueModel(name: 'Uşak', value: "Uşak"),
        DropDownValueModel(name: 'Van', value: "Van"),
        DropDownValueModel(name: 'Yalova', value: "Yalova"),
        DropDownValueModel(name: 'Yozgat', value: "Yozgat"),
        DropDownValueModel(name: 'Zonguldak', value: "Zonguldak"),
      ],
      onChanged: (val) {
        if (val == "") {
          selectedCity = "";
        } else {
          selectedCity = val.value;
        }
      },
    );
  }

  TextFormField buildAgeFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
/*       validator: (value) {
        if (value!.isEmpty) {
          setState(() {
            errors.add("Please enter your phone number");
          });
        }
        return null;
      }, */
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 2,
      controller: age,
      showCursor: true,
      decoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "Age",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Enter your age",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.numbers_rounded,
          color: buttonColor,
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
}
