import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';

final gWidth = Get.width;
final gHeight = Get.height;
String selectedCity = "";
String userName = "";
//

final Color buttonColor = Color(0xffffaa17);
final Color iconColor = Color(0xff7e899d);
final Color text1Color = Color.fromRGBO(255, 90, 90, 90);
const kPrimaryGradiantColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffffaa17), Color(0xff7e899d)]);
//

const kAnimationDuration = Duration(milliseconds: 200);
final DBref = FirebaseDatabase.instance.ref();
final storageref = FirebaseStorage.instance.ref();

Future<String> get_Curname(String? phN) async{
  List<Customer> it = await customerListMaker();
  String cur="";

  for (var p in it) {
    if(p.phone==phN){
      cur=p.name;
      break;
    }else{
      continue;
    }
  }
  return cur;
}

void updater() async{
  String curname = await get_Curname(FirebaseAuth.instance.currentUser?.phoneNumber);
  FirebaseAuth.instance.currentUser?.updateDisplayName(curname);
}


class Customer {
  final String uid;
  final String name;
  final String phone;
  final String city;
  final String age;
  final String surname;
  final String photoURL;

  Customer(this.uid,this.name, this.phone, this.city, this.age, this.surname,this.photoURL);
}

class Chat{
  final String chat_uid;
  final String user_id;
  final String chat_name;
  final List chat_people;

  Chat(this.chat_uid,this.user_id,this.chat_name,this.chat_people);
}

Future<String> getChatUIDDetails(String userUID) async{
  List<Chat> chatInfo = [];
  String chatUID = '';
  final snapshot = await DBref.child('Chats').child(FirebaseAuth.instance.currentUser!.uid).get();

  if(snapshot.exists){
    Map<dynamic, dynamic> data = snapshot.value as Map;
    data.forEach((key, value) {
      chatInfo.add(Chat(key,value['user_id'], value['chat_name'], value['chat_members']));
    });
    for(var element in chatInfo){
      if(element.user_id==userUID){
        chatUID=element.chat_uid;
        break;
      }else{
        continue;
      }
    }
    return chatUID;
  }else{
    return '';
  }
}

Future<List<Customer>> customerListMaker () async {
  List<Customer> customerList = [];
  final snapshot = await DBref.child('Users').get();

  if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map;
      data.forEach((key, value) {
        customerList.add(Customer(key,value['name'], value['phone_number'], value['city'],
            value['age'], value['surname'],value['photoURL']));
      });
      return customerList;
      
  }else{
    return [];
  }
}


Future<Map<dynamic, dynamic>> customerAccountDetails(String? phoneNum) async{
  List<Customer> customers = await customerListMaker();
  Map<dynamic, dynamic> signedCustomer = new HashMap();

  for(var element in customers){
    if(element.phone==phoneNum){
       signedCustomer = {
        'name': element.name,
        'phone_number': element.phone,
        'city': element.city,
        'age': element.age,
        'surname': element.surname,
        'photoURL': element.photoURL,
        'uid': element.uid,
      };
      break;
    }else{
      continue;
    }
  }
  return signedCustomer;
}




