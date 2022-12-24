import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/chats/members.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/screens/chats/user_chatlist.dart';

class createGroupChat extends StatefulWidget {
  const createGroupChat({Key? key, required this.boolKey}) : super(key: key);

  final bool boolKey;

  State<createGroupChat> createState() => _createGroupChatState();
}

class _createGroupChatState extends State<createGroupChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userChatList(),
                  ));
            },
            icon: Icon(LineAwesomeIcons.arrow_left)),
      ),
      body: membersList(boolKey: widget.boolKey),
    ); 
  }
}