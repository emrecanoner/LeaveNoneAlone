import 'dart:ui';

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
import 'package:lna/screens/chats/user_chat.dart';
import 'package:lna/screens/chats/user_chat.dart';
import 'package:lna/utils/custom_snackbar.dart';

class membersList extends StatefulWidget {
  const membersList(
      {Key? key,
      required this.boolKey,
      required this.chatN,
      required this.chatP,
      required this.chatMap})
      : super(key: key);

  final bool boolKey;
  final String chatN;
  final Map chatMap;
  final String chatP;

  State<membersList> createState() => _membersListState();
}

class _membersListState extends State<membersList> {
  DatabaseReference frienddbRef = FirebaseDatabase.instance
      .ref()
      .child('Friends')
      .child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference chatdbRef = FirebaseDatabase.instance
      .ref()
      .child('Chats')
      .child(FirebaseAuth.instance.currentUser!.uid);
  late DatabaseReference eventdref;
  String? friendname;
  String? friendphone;
  String? friendphoto;
  String? friendauth_id;
  List<String> group_members_selected = [];
  final GroupNameController = TextEditingController();
  List<Map> chat_MEM = [];
  String photo =
      'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/files%2Ficon.jpg?alt=media&token=10f30e44-905f-40da-8ebc-93f69339ac6c';

  void initState() {
    super.initState();
    eventdref = FirebaseDatabase.instance.ref().child('Events');
    getChat();
  }

  void getChat() async {
    DataSnapshot snapshot = await frienddbRef.get();
    if (snapshot.exists) {
      print('Friends exists');
    } else {
      print('No chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          SizedBox(height: gHeight / 40),
          FutureBuilder(
              future: getUserFriends(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return friendsListItem(context, snapshot);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          SizedBox(height: gHeight / 40),
          Visibility(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: buttonColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${group_members_selected.length}',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            visible: widget.boolKey,
          ),
          SizedBox(height: gHeight / 40),
          buildContinueButton(),
        ]),
      ),
    );
  }

  Visibility buildContinueButton() {
    return Visibility(
      child: DefaultButton(
          text: 'Continue',
          press: () async {
            if (group_members_selected.length <= 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: CustomSnackBarContent(
                      errorMessage: 'The group should be more than one person'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              );
            } else {
              Map CU = {
                'member_name': FirebaseAuth.instance.currentUser!.displayName,
                'member_phone': FirebaseAuth.instance.currentUser!.phoneNumber
                    ?.substring(3),
                'member_photo': FirebaseAuth.instance.currentUser!.photoURL,
                'member_authid': FirebaseAuth.instance.currentUser!.uid,
              };
              chat_MEM.add(CU);
              Map<dynamic, dynamic> group_chat = {
                'chat_name': widget.chatN,
                'chat_members': chat_MEM,
                'chat_photo': widget.chatP,
                'user_uid': FirebaseAuth.instance.currentUser?.uid.toString(),
              };
              chatdbRef.push().set(group_chat);
              eventdref.push().set(widget.chatMap);
              String group_chat_uid = await getChatUID(
                  widget.chatN, FirebaseAuth.instance.currentUser!.uid);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => userChat(messageKey: group_chat_uid),
                  ));
            }
          }),
      visible: widget.boolKey,
    );
  }

  Widget friendsListItem(context, snapshot) {
    List<Friends> friends = snapshot.data as List<Friends>;
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (BuildContext context, int index) {
        Friends friend = friends[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              friend.friend_photo,
              height: gHeight / 18,
              width: gWidth / 9,
            ),
          ),
          title: Text(friend.friend_name),
          subtitle: Text('+90${friend.friend_phone}'),
          onTap: () async {
            if (widget.boolKey) {
              friendname = friend.friend_name;
              friendphoto = friend.friend_photo;
              friendauth_id = friend.friend_auth_uid;
              addMembersForChat();
            } else {
              String userid = FirebaseAuth.instance.currentUser!.uid;
              String single_chat_id = await getChatUID(
                  widget.chatN, FirebaseAuth.instance.currentUser!.uid);
              if (single_chat_id == '') {
                Map GroupUserDetail = {
                  'member_name': friend.friend_name,
                  'member_phone': friend.friend_phone,
                  'member_photo': friend.friend_photo,
                  'member_authid': friend.friend_auth_uid,
                };
                Map CU = {
                  'member_name': FirebaseAuth.instance.currentUser!.displayName,
                  'member_phone': FirebaseAuth.instance.currentUser!.phoneNumber
                      ?.substring(3),
                  'member_photo': FirebaseAuth.instance.currentUser!.photoURL,
                  'member_authid': FirebaseAuth.instance.currentUser!.uid,
                };

                chat_MEM.add(GroupUserDetail);
                chat_MEM.add(CU);

                Map<dynamic, dynamic> single_chat = {
                  'chat_members': chat_MEM,
                  'chat_name': widget.chatN,
                  'chat_photo': widget.chatP,
                  'user_uid': friend.friend_auth_uid,
                };
                chatdbRef.push().set(single_chat);
                eventdref.push().set(widget.chatMap);
                String new_single_chat_uid = await getChatUID(
                    widget.chatN, FirebaseAuth.instance.currentUser!.uid);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => userChat(messageKey: new_single_chat_uid),
                    ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => userChat(messageKey: single_chat_id),
                    ));
              }
            }
          },
          // trailing: Checkbox(
          //   value: snapshot.data[index].selected,
          //   onChanged: (bool? value) {
          //     setState(() {
          //       snapshot.data[index].selected = value;
          //       if (value!) {
          //         group_members_selected.add(friend.friend_name);
          //       } else {
          //         group_members_selected.remove(friend.friend_name);
          //       }
          //     });
          //   },
          // ),
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  void addMembersForChat() {
    setState(() {
      Map GroupUserDetail = {
        'member_name': friendname,
        'member_phone': friendphone,
        'member_photo': friendphoto,
        'member_authid': friendauth_id
      };
      if (group_members_selected.contains(friendname.toString())) {
        group_members_selected.remove(friendname.toString());
        chat_MEM.remove(GroupUserDetail);
      } else {
        group_members_selected.add(friendname.toString());
        chat_MEM.add(GroupUserDetail);
      }
    });
  }
}
