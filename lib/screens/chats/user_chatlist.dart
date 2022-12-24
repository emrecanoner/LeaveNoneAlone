import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/chats/user_chat.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/screens/chats/create_chat.dart';

class userChatList extends StatefulWidget {
  const userChatList({
    Key? key,
  }) : super(key: key);

  State<userChatList> createState() => _userChatListState();
}

class _userChatListState extends State<userChatList> {
  Query dbChatRef = FirebaseDatabase.instance.ref().child('Chats').child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference chatreference = FirebaseDatabase.instance.ref().child('Chats').child(FirebaseAuth.instance.currentUser!.uid);
  String? messageKey;
  bool chatExits = false;

  void initState(){
    super.initState();
    getChat();
  }

  void getChat() async{
    DataSnapshot snapshot = await chatreference.get();
    if(snapshot.exists){
      chatExits = true;
    }else{
      print('No chats');
    }
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
            DefaultButton(
              text: 'Create new chat', 
              press: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                  builder: (_) => createChat(),
                  )
                );
              }
            ),
            FirebaseAnimatedList(
              query: dbChatRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map chat = snapshot.value as Map;
                chat['key'] = snapshot.key;

                return chatsListItem(chat: chat);
              },
            ),
          ]
        ),
      ),
    );
  }
  Visibility chatsListItem({required Map chat}) {
    return Visibility(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: 110,
        color: Colors.amberAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat['chat_name'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => userChat(messageKey: chat['key'],),
                      )
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      visible: chatExits,
    );
  }
}