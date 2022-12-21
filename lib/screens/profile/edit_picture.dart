import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lna/screens/database/splash/animated_splash_screen.dart';
import 'package:lna/screens/sign_in/components/body.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/custom_snackbar.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:lna/screens/profile/splash/animated_splash_screen.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:base_x/base_x.dart';

class EditProfilePicture extends StatefulWidget {
  const EditProfilePicture({Key? key}) : super(key: key);

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Picture'),
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
                  'Choose Profile Picture',
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
                EditPicture(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditPicture extends StatefulWidget {
  const EditPicture({super.key});

  @override
  State<EditPicture> createState() => _EditPictureState();
}

class _EditPictureState extends State<EditPicture> {

  Uint8List? _image;
  String photo1 = FirebaseAuth.instance.currentUser!.photoURL.toString();
  String photo2 = 'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/files%2Ficon.jpg?alt=media&token=10f30e44-905f-40da-8ebc-93f69339ac6c';
  
  bool newPhotoExists = false;
  bool oldPhotoExists = true;

  Uint8List? _img;
  Uint8List _imgexample = new Uint8List(8);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: gHeight / 40),
              buildProfilePic(),
              buildChoosenProfilePic(),
              SizedBox(height: gHeight / 40),
              DefaultButton(
                text: 'Upload', 
                press: () async{
                  var i;
                  Uint8List? s = _image;
                  if(s!=null){
                    String url = await uploadImage(s); 
                    FirebaseAuth.instance.currentUser?.updatePhotoURL(url);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SplashScreenPAnimated(),
                      ),
                    );
                    Fluttertoast.showToast(
                      msg: "Photo Uploaded",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: buttonColor,
                      textColor: Colors.white,
                      fontSize: 16,
                    );
                  }
                }
              )
            ]
          ),
        ),
      ),
    );
  }

  Visibility buildProfilePic(){
    return Visibility(
      child: ClipOval(
        child: Container(
          width: 220.0,
          height: 220.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage((FirebaseAuth.instance.currentUser?.photoURL!=null)?photo1:photo2),
            ),
          ),
          child: TextButton(
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: null,
            ),
            onPressed: () {
              newPhotoExists = true;
              oldPhotoExists = false;
              getImage();
            }
          ),
        ),
      ),
      visible: oldPhotoExists,
    );
  }
    Visibility buildChoosenProfilePic(){
    return Visibility(
      child: ClipOval(
        child: Container(
          width: 220.0,
          height: 220.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage((_img!=null)?_img!:_imgexample),
            ),
          ),
          child: TextButton(
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: null,
            ),
            onPressed: () {
              newPhotoExists = true;
              oldPhotoExists = false;
              getImage();
            }
          ),
        ),
      ),
      visible: newPhotoExists,
    );
  }


  void getImage() async {
    Uint8List pickedFile = await pickImage(ImageSource.gallery);

    setState(() {
      _image = pickedFile;
      _img = pickedFile;
    });
  }
  Future<String> uploadImage(Uint8List file) async{
    final path = 'files/${FirebaseAuth.instance.currentUser?.uid}';
    Reference profileref = await storageref.child(path);
    UploadTask uploadTask = profileref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }
  pickImage(ImageSource source) async{
    final ImagePicker _imagepicker = ImagePicker();
    XFile? _file = await _imagepicker.pickImage(source: source);
    if(_file != null){
      return await _file.readAsBytes();
    }else{
      print('No image Selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarContent(
            errorMessage:"You didn't pick an image"
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

    } 
  }
}