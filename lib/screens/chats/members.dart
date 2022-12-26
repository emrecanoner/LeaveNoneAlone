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
  const membersList({Key? key, required this.boolKey}) : super(key: key);

  final bool boolKey;

  State<membersList> createState() => _membersListState();
}

class _membersListState extends State<membersList> {
  DatabaseReference frienddbRef = FirebaseDatabase.instance.ref().child('Friends').child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference chatdbRef = FirebaseDatabase.instance.ref().child('Chats').child(FirebaseAuth.instance.currentUser!.uid);  
  String? friendname;
  List<String> group_members_selected = [];
  final GroupNameController = TextEditingController();

  void initState(){
    super.initState();
    getChat();
  }

  void getChat() async{
    DataSnapshot snapshot = await frienddbRef.get();
    if(snapshot.exists){
      print('Friends exists');
    }else{
      print('No chats');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildGroupNameFormField(),
            FutureBuilder(
              future: getUserFriends(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return friendsListItem(context, snapshot);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
            ),
            buildContinueButton(),
            Text('${group_members_selected.length}'),
          ]
        ),
      ),
    );
  }

  Visibility buildGroupNameFormField(){
    return Visibility(
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: GroupNameController,
        showCursor: true,
        decoration: InputDecoration(
          prefix: Padding(
            padding: EdgeInsets.all(4),
          ),
          labelText: "Group Name",
          labelStyle: TextStyle(color: iconColor),
          hintText: "Enter your group name",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(
            Icons.account_circle,
            color: buttonColor,
          ),
        ),
      ),
      visible: widget.boolKey,
    );
  }

  Visibility buildContinueButton(){
    return Visibility(
      child: DefaultButton(
        text: 'Continue', 
        press: () async{
          if(GroupNameController.text.length==0){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomSnackBarContent(
                  errorMessage:
                    "You didn't enter your group name, write it immediately."),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            );
          }if(group_members_selected.length<=1){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomSnackBarContent(
                  errorMessage:
                    'The group should be more than one person'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            );
          }else{
            Map<dynamic,dynamic> group_chat = {
              'user_uid': FirebaseAuth.instance.currentUser?.uid.toString(),
              'chat_name': GroupNameController.text,
              'chat_members': group_members_selected
            };
            chatdbRef.push().set(group_chat);
            String group_chat_uid = await getChatUID(FirebaseAuth.instance.currentUser!.uid);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => userChat(messageKey: group_chat_uid),
              )
            );
          }
        }
      ),
      visible: widget.boolKey,
    );
  }

  Widget friendsListItem(context, snapshot) {
    List<Friends> friends = snapshot.data as List<Friends>;
    return ListView.builder(
        itemCount: friends.length,
        itemBuilder: (BuildContext context, int index){
          Friends friend = friends[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.yellow,
            ),
            title: Text(friend.friend_name),
            subtitle: Text(friend.friend_phone),
            onTap: () async{
              if(widget.boolKey){
                friendname = friend.friend_name;
                addMembersForChat();
              }else{
                String userid = FirebaseAuth.instance.currentUser!.uid;
                String single_chat_uid = await getChatUID(userid);
                if(single_chat_uid==''){
                  group_members_selected.add(friend.friend_name);
                  Map<dynamic,dynamic> single_chat = {
                    'chat_members': group_members_selected,
                    'chat_name': friend.friend_name,
                    'user_uid': userid,
                  };
                  chatdbRef.push().set(single_chat);
                  String new_single_chat_uid = await getChatUID(userid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => userChat(messageKey: new_single_chat_uid),
                    )
                  );
                }else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => userChat(messageKey: single_chat_uid),
                    )
                  );
                }
              }
            },
            trailing: Checkbox(
              value: snapshot.data[index].selected,
              onChanged: (bool? value) {
                setState(() {
                  snapshot.data[index].selected = value;
                  if (value!) {
                    group_members_selected.add(friend.friend_name);
                  } else {
                    group_members_selected.remove(friend.friend_name);
                  }
                });
              },
            ),
          );
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
    );
  }
  
 

  void addMembersForChat(){
    setState(() {
      if (group_members_selected.contains(friendname.toString())) {
        group_members_selected.remove(friendname.toString());
      } else {
        group_members_selected.add(friendname.toString());
      }
    });
  }
}