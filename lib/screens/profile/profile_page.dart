import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late File _image;
  final picker = ImagePicker();
  bool photoExists = true;
  String photo1= CurrentCustomerPhoto.toString();
  String photo2 = 'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/files%2Ficon.jpg?alt=media&token=10f30e44-905f-40da-8ebc-93f69339ac6c';

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
                    image: NetworkImage(photoExists?photo1:photo2),
                    // image: NetworkImage("https://images.unsplash.com/photo-1547721064-da6cfb341d50"),
                  ),
                ),
                child: TextButton(
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: null,
                  ),
                  onPressed: () async {
                    getImage();
                    String url = await uploadImage(_image);
                    CurrentCustomerPhoto=url;
                  },
                ),
              ),
            ),
            FutureBuilder(
              future: customerAccountDetails(CurrentCustomerPhone!),
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
    ]);
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }
  Future<String> uploadImage(File file) async{
    UploadTask? uploadTask;
    const path = 'files/';
    final profileref = await storageref.child(path);
    uploadTask = profileref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }
}
