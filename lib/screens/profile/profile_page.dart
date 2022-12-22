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
  String? authcurrent =
      FirebaseAuth.instance.currentUser?.phoneNumber?.substring(3);
  String photo1 = FirebaseAuth.instance.currentUser!.photoURL.toString();
  String photo2 =
      'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/files%2Ficon.jpg?alt=media&token=10f30e44-905f-40da-8ebc-93f69339ac6c';

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
      body:

          /*SingleChildScrollView(
        child: Container(
          height: gHeight / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[*/
          /* Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: buttonColor),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      ((FirebaseAuth.instance.currentUser?.photoURL != null)
                          ? photo1
                          : photo2),
                      height: gHeight / 6,
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                      ),
                      color: buttonColor,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  )), */
          FutureBuilder(
        future: customerAccountDetails(authcurrent!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return displayUserInformation(context, snapshot);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    Map signedInCustomer = snapshot.data as Map;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  /*decoration: BoxDecoration(
                    border: Border.all(width: 3, color: buttonColor),
                    borderRadius: BorderRadius.circular(100),
                  ),*/
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      ((FirebaseAuth.instance.currentUser?.photoURL != null)
                          ? photo1
                          : photo2),
                      height: gHeight / 6,
                    ),
                  ),
                ),
                /*Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
                        ),
                        color: buttonColor,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )),*/
              ],
            ),
          ),
          SizedBox(height: 50),
          TextField(
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3, left: 10),
                labelText: "Name",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "${signedInCustomer['name']}",
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          SizedBox(height: 15),
          TextField(
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3, left: 10),
                labelText: "Surname",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "${signedInCustomer['surname']}",
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          SizedBox(height: 15),
          TextField(
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3, left: 10),
                labelText: "Age",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "${signedInCustomer['age']}",
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          SizedBox(height: 15),
          TextField(
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3, left: 10),
                labelText: "City",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "${signedInCustomer['city']}",
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          SizedBox(height: 15),
          TextField(
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3, left: 10),
                labelText: "Phone Number",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "+90${signedInCustomer['phone_number']}",
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          SizedBox(height: 80),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(gHeight / 3, 35),
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: Text(
                "UPDATE",
                style: TextStyle(
                    fontSize: 14, color: Colors.white, letterSpacing: 2.2),
              )),

          /* Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: buttonColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                        fontSize: 14, color: buttonColor, letterSpacing: 2.2),
                  ),
                ),
              ),
              SizedBox(width: 30),
              Container(
                width: 150,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: buttonColor,
                      side: BorderSide(width: 1.0, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          letterSpacing: 2.2),
                    )),
              )
            ],
          ) */
        ],
      ),
    );
  }
}

    /*return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: buttonColor),
              borderRadius: BorderRadius.circular(100),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  ((FirebaseAuth.instance.currentUser?.photoURL != null)
                      ? photo1
                      : photo2),
                  height: gHeight / 6,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Colors.white,
                  ),
                  color: buttonColor,
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              )),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            child: Text(
              "Name: ${signedInCustomer['name']}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            child: Text(
              "Surname: ${signedInCustomer['surname']}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            child: Text(
              "City: ${signedInCustomer['city']}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            child: Text(
              "Age: ${signedInCustomer['age']}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            child: Text(
              "Phonenumber: ${'+90' + signedInCustomer['phone_number']}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          /* Text(
            " Name: ${signedInCustomer['name']}",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
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
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              " Age: ${signedInCustomer['age']}",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              " Phonenumber: ${'+90' + signedInCustomer['phone_number']}",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
          ), */
          //SizedBox(height: gHeight / 6),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultButton(
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            Update(userK: signedInCustomer['uid'])));
              },
              text: ('Edit Profile'),
            ),
          ),
        ]);
  }
}*/
