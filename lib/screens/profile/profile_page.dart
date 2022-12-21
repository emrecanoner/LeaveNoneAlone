import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/screens/profile/profile_edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? authcurrent = FirebaseAuth.instance.currentUser?.phoneNumber?.substring(3);
  String photo1 = FirebaseAuth.instance.currentUser!.photoURL.toString();
  String photo2 = 'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/files%2Ficon.jpg?alt=media&token=10f30e44-905f-40da-8ebc-93f69339ac6c';
  
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipOval(
              child: Container(
                width: 220.0,
                height: 220.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage((FirebaseAuth.instance.currentUser?.photoURL!=null)?photo1:photo2),
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: customerAccountDetails(authcurrent!),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  return displayUserInformation(context, snapshot);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    Map signedInCustomer = snapshot.data as Map;

    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          " Name: ${signedInCustomer['name']}",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          " Surname: ${signedInCustomer['surname']}",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          " City: ${signedInCustomer['city']}",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          " Age: ${signedInCustomer['age']}",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          " Phonenumber: ${'+90' + signedInCustomer['phone_number']}",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultButton(
          press: (){
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (_) => Update(userK: signedInCustomer['uid'])
              )
            );
          },
          text: 'Edit Profile',
        ),
      ),
    ]);
  }

  
}
