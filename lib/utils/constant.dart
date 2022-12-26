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

class Friends{
  final String friend_uid;
  final String friend_name;
  final String friend_phone;

  Friends(this.friend_uid,this.friend_name,this.friend_phone);
}

Future<List<Friends>> getUserFriends() async{
  List<Friends> friendsInfo = [];
  final snapshot = await DBref.child('Friends').child(FirebaseAuth.instance.currentUser!.uid).get();

  try{
    if(snapshot.exists){
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        friendsInfo.add(Friends(key,value['friend_name'],value['friend_phone']));
      });
      return friendsInfo;
    }else{
      return [];
    }
  }on TypeError catch (e){
    print('friends: ${e.toString()}');
    return[];
  }catch (e){
    print('friends: ${e.toString()}');
    return[];
  }
}
class Chat{
  final String chat_uid;
  final String chat_name;
  final String user_id;
  
  Chat(this.chat_uid,this.chat_name,this.user_id);
}
Future<String> getChatUID(String userUID) async{
  List<Chat> chat = await getUserChats();
  String chatUID = '';
  try{
    for(var element in chat){
      if(element.user_id==userUID){
        chatUID=element.chat_uid;
        break;
      }else{
        continue;
      }
    }
    return chatUID;
  }on TypeError catch (e){
    print('chatUID: ${e.toString()}');
    return '';
  }catch (e){
    print('chatUID: ${e.toString()}');
    return '';
  }
}

Future<List<Chat>> getUserChats() async{
  List<Chat> chatInfo = [];
  final snapshot = await DBref.child('Chats').child(FirebaseAuth.instance.currentUser!.uid).get();

  try{
    if(snapshot.exists){
      Map<dynamic, dynamic> data = snapshot.value as Map;
      data.forEach((key, value) {
        chatInfo.add(Chat(key, value['chat_name'], value['user_uid']));
      });
      return chatInfo;
    }else{
      return [];
    }
  }on TypeError catch (e){
    if(e.toString() == "type 'Null' is not a subtype of type 'Uint8list'"){
      print('chats: ${e.toString()}');
      return [];
    }
    return [];
  } catch (e){
    print('chats: ${e.toString()}');
    return [];
  }
}


class Message{
  final String message_sender;
  final String message_text;
  final String message_timestamp;

  Message(this.message_sender,this.message_text,this.message_timestamp);
}

Future<List<Message>> getUserMessages(String chatKey) async {
  List<Message> messageInfo = [];
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    return [];
  }
  final chatRef = FirebaseDatabase.instance.ref().child('Chats').child(currentUser.uid).child(chatKey);
  final snapshot = await chatRef.get();

  try{
    if (snapshot.exists) {
      Map<dynamic, dynamic> chatData = snapshot.value as Map;

      // Iterate through the chat data
      for (var entry in chatData.entries) {
        var chatKeys = entry.key;
        // Get the message data
        if(chatKeys=='user_uid'||chatKeys=='chat_name'||chatKeys=='chat_members'){
          continue;
          // Do something with the message data
        }else{
          Map<dynamic, dynamic> messageData = entry.value;
          messageInfo.add(Message(messageData['sender'], messageData['text'], messageData['timestamp']));
        }
      }
      messageInfo.sort((a, b) => a.message_timestamp.compareTo(b.message_timestamp));
      return messageInfo;
    } else {
      return [];
    }
  }on TypeError catch (e){
    print('message: ${e.toString()}');
    return [];
  }catch (e){
    print('message: ${e.toString()}');
    return [];
  }
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


Future<List<Customer>> customerListMaker () async {
  List<Customer> customerList = [];
  final snapshot = await DBref.child('Users').get();

  try{
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
  }on TypeError catch (e){
    print('customerlist: ${e.toString()}');
    return [];
  }catch (e){
    print('customerlist: ${e.toString()}');
    return[];
  }
}


Future<Map<dynamic, dynamic>> customerAccountDetails(String? phoneNum) async{
  List<Customer> customers = await customerListMaker();
  Map<dynamic, dynamic> signedCustomer = new HashMap();

  try{
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
  }on TypeError catch (e){
    print('customerlist: ${e.toString()}');
    return {};
  }catch (e){
    print('customerlist: ${e.toString()}');
    return{};
  }
}
Future<String> get_Curname(String? phN) async{
  List<Customer> it = await customerListMaker();
  String cur="";

  try{
    for (var p in it) {
      if(p.phone==phN.toString()){
        cur=p.name;
        break;
      }else{
        continue;
      }
    }
    return cur;
  }on TypeError catch(e){
    print('getcurname: ${e.toString()}');
    return '';
  }catch (e){
    print('getcurname: ${e.toString()}');
    return '';
  }
}

void updater() async{
  try{
    Map CurrUser = await customerAccountDetails(FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3));
    String curname = CurrUser['name'];
    String curphoto = CurrUser['photoURL'];
    FirebaseAuth.instance.currentUser?.updateDisplayName(curname);
    FirebaseAuth.instance.currentUser?.updatePhotoURL(curphoto);
  }on TypeError catch (e){
    print('updater: ${e.toString()}');
  }catch (e){
    print('updater: ${e.toString()}');
  }
}



