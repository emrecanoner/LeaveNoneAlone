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
  const createChat({super.key});

  State<createChat> createState() => _createChatState();
}

class _createChatState extends State<createChat> {
  
  bool boolGroupKey = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
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
            DefaultButton(
              text: 'Create Group', 
              press: (){
                boolGroupKey = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (_) => createGroupChat(boolKey: boolGroupKey),
                  )
                );
              }
            ),
            const SizedBox(
              height: 5,
            ),
            membersList(boolKey: boolGroupKey),
          ],
        ),
      ),
    );
  }
}