import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/chats/create_groupchat.dart';
import 'package:lna/screens/chats/members.dart';
import 'package:lna/screens/chats/user_chatlist.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/screens/profile/profile_edit.dart';

class createChat extends StatefulWidget {
  const createChat(
      {Key? key,
      required this.chatN,
      required this.chatP,
      required this.chatMap})
      : super(key: key);

  final String chatN;
  final Map chatMap;
  final String chatP;

  State<createChat> createState() => _createChatState();
}

class _createChatState extends State<createChat> {
  bool boolGroupKey = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Friend or Create Group'),
        automaticallyImplyLeading: false,
        /*leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            },
            icon: Icon(LineAwesomeIcons.arrow_left)),*/
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DefaultButton(
                text: 'Create Group',
                press: () {
                  boolGroupKey = true;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => createGroupChat(
                            boolKey: boolGroupKey,
                            chatN: widget.chatN,
                            chatP: widget.chatP,
                            chatMap: widget.chatMap),
                      ));
                }),
            SizedBox(
              height: gHeight / 1000,
            ),
            membersList(
                boolKey: boolGroupKey,
                chatN: widget.chatN,
                chatP: widget.chatP,
                chatMap: widget.chatMap),
          ],
        ),
      ),
    );
  }
}
