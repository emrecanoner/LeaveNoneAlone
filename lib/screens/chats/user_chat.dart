import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/screens/profile/profile_edit.dart';
import 'package:lna/screens/chats/user_chatlist.dart';

class userChat extends StatefulWidget {

  const userChat({Key? key, required this.messageKey}) : super(key: key);

  final String messageKey;

  State<userChat> createState() => _userChatState();
}

class _userChatState extends State<userChat> {
  String? chat_NAME;

  late DatabaseReference chatdbRef;
  late Query messageQueryRef;
  late DatabaseReference messagedbRef;

  final ChatTextController = TextEditingController();

  void initState() {
    super.initState();
    chatdbRef = FirebaseDatabase.instance.ref().child('Chats').child(FirebaseAuth.instance.currentUser!.uid);
    messageQueryRef = FirebaseDatabase.instance.ref().child('Chats').child('${FirebaseAuth.instance.currentUser!.uid}/${widget.messageKey}');
    getUserData();
  }

  void getUserData() async {
    messagedbRef = await chatdbRef.child(widget.messageKey);
    DataSnapshot chatsnapshot = await messagedbRef.get();

    Map chat_MAP = chatsnapshot.value as Map;
 
    chat_NAME = chat_MAP['chat_name'];
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${chat_NAME.toString()}'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => userChatList(),
                )
              );
            },
            icon: Icon(LineAwesomeIcons.arrow_left)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FirebaseAnimatedList(
              query: messageQueryRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
                  Map message = snapshot.value as Map;
                  message['key'] = snapshot.key;
                  return chatListItem(message: message);
              },
            ),
            buildChatFormField(),
            DefaultButton(
              text: 'Send', 
              press: (){
                Map Text_Chat = {
                  'sender': FirebaseAuth.instance.currentUser?.displayName,
                  'text': ChatTextController,
                  'timestamp': DateTime.now()
                };
                messagedbRef.push().set(Text_Chat).then((value) => 
                  setState(() {})
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget chatListItem({required Map message}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 110,
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            message['sender'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            message['text'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            message['timestamp'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
          ),
        ],
      ),
    );
  }
  TextFormField buildChatFormField(){
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: ChatTextController,
      showCursor: true,
      decoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "Chat",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Enter your message",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.account_circle,
          color: buttonColor,
        ),
      ),
    );
  }
}