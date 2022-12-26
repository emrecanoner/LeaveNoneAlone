import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/chats/user_chatlist.dart';
import 'package:lna/screens/database/splash/animated_splash_screen.dart';
import 'package:lna/screens/friends/user_Account.dart';
import 'package:lna/screens/sign_in/components/body.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/custom_snackbar.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:lna/screens/home/home_page.dart';

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
    return Scaffold(
      appBar: AppBar(
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
        height: 500,
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
              FloatingActionButton(
                child: Icon(Icons.message_sharp),
                backgroundColor: Color(0xffffaa17),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                    builder: (_) => userChatList(),
                    )
                  );
                },
              )
            ]
          ),
        ),
      )
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
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
      visible: searchlistExist,
    );
  }

}