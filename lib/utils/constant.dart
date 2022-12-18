import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

final CurrentCustomer = FirebaseAuth.instance.currentUser;
String? num = CurrentCustomer?.phoneNumber?.substring(3);
String? photo = CurrentCustomer?.photoURL;

class Customer {
  final String name;
  final String phone;
  final String city;
  final String age;
  final String surname;

  Customer(this.name, this.phone, this.city, this.age, this.surname);
}

Future<List<Customer>> customerListMaker () async {
  final ref = FirebaseDatabase.instance.ref();
  List<Customer> customerList = [];
  final snapshot = await ref.child('Users').get();

  if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map;
      data.forEach((key, value) {
        customerList.add(Customer(value['name'], value['phone_number'], value['city'],
            value['age'], value['surname']));
      });
      return customerList;
      
  }else{
    return [];
  }
}


Future<Map<dynamic, dynamic>> customerAccountDetails(String phoneNum) async{
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
      };
      break;
    }else{
      continue;
    }
  }
  return signedCustomer;
}



