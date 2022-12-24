import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lna/screens/database/splash/animated_splash_screen.dart';
import 'package:lna/screens/friends/user_Account.dart';
import 'package:lna/screens/sign_in/components/body.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/custom_snackbar.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class searchLNAUser extends StatefulWidget {
  const searchLNAUser({Key? key}) : super(key: key);

  @override
  State<searchLNAUser> createState() => _searchLNAUserState();
}

class _searchLNAUserState extends State<searchLNAUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add friend'),
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
                  'Search LNA User by Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: gHeight / 1500,
                ),
                searchLNAUserBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class searchLNAUserBar extends StatefulWidget {
  const searchLNAUserBar({super.key});

  @override
  State<searchLNAUserBar> createState() => _searchLNAUserBarState();
}

class _searchLNAUserBarState extends State<searchLNAUserBar> {
  bool searchlistExist = false;
  final userLNA_name = TextEditingController();
  Map<String, String> searchedusersLNA = {};
  List<String> searchedNames = [];

  late DatabaseReference userdbRef;

  @override
  void initState() {
    super.initState();
    userdbRef = FirebaseDatabase.instance.ref().child('Users');
  }

  void dispose() {
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
              buildFriendNameFormField(),
              SizedBox(height: gHeight / 40),
              DefaultButton(
                text: 'Search', 
                press: () async{

                  List<Customer> items = await customerListMaker();
                  
                  for(var element in items){
                    if(userLNA_name.text.contains(element.name)||
                    userLNA_name.text.contains(element.surname)){
                      searchedusersLNA={
                        element.name: element.phone
                      };
                    }
                  }
                  setState(() {
                    searchlistExist = true;
                    searchedNames = searchedusersLNA.keys.toList();
                  });
                }
              ),
              buildUSERSLNAList(),
              SizedBox(height: gHeight / 40),
            ]
          ),
        ),
      ),
    );
  }

  TextFormField buildFriendNameFormField(){
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: userLNA_name,
      showCursor: true,
      decoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "User LNA Name",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Enter your User LNA name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.account_circle,
          color: buttonColor,
        ),
      ),
    );
  }

  Visibility buildUSERSLNAList(){
    return Visibility(
      child: ListView.builder(
        itemCount: searchedusersLNA.length,
        itemBuilder: (context,index){
          String key = searchedNames[index];
          String value = searchedusersLNA[key].toString();
          return DefaultButton(
            press: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => userAccount(phoneKey: value),
                )
              );
            },
            text: key,
          );
        },
      ),
      visible: searchlistExist,
    );
  }

}