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
  late String chat_NAME;

  late DatabaseReference chatdbRef;
  DatabaseReference ChtdbRef = FirebaseDatabase.instance.ref().child('Chats');

  final ChatTextController = TextEditingController();

  String photo =
      'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/files%2Ficon.jpg?alt=media&token=10f30e44-905f-40da-8ebc-93f69339ac6c';

  void initState() {
    super.initState();
    chatdbRef = FirebaseDatabase.instance
        .ref()
        .child('Chats')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(widget.messageKey);
  }

  Future<Map> getUserData() async {
    final chatsnapshot = await chatdbRef.get();

    if (chatsnapshot.exists) {
      Map chat_MAP = chatsnapshot.value as Map;
      Map chat_details = {
        'chat_NAME': chat_MAP['chat_name'],
        //'chat_PHOTO': chat_MAP['chat_photo']
      };

      return chat_details;
    } else {
      print('no chat_name');
      return {};
    }
  }

  Widget ChatTitle(context, snapshot) {
    Map chTitle = snapshot.data as Map;
    return Column(
      children: <Widget>[
        /*ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            chTitle['chat_PHOTO'],
            height: gHeight / 18,
            width: gWidth / 9,
          ),
        ),*/
        Text('${chTitle['chat_NAME']}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: getUserData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ChatTitle(context, snapshot);
            } else {
              return Text('Loading...');
            }
          },
        ),
        leading: IconButton(
            onPressed: () {
              Messageback();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            },
            icon: Icon(LineAwesomeIcons.arrow_left)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                  future: getUserMessages(widget.messageKey),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return chatListItem(context, snapshot);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            buildChatFormField(),
            DefaultButton(
                text: 'Send',
                press: () async {
                  String formattedTime =
                      "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
                  String formattedDateTime =
                      "${DateTime.now().day}/${DateTime.now().month} ${formattedTime}";
                  Map Text_Chat = {
                    'sender': FirebaseAuth.instance.currentUser?.displayName,
                    'text': ChatTextController.text,
                    'timestamp': formattedDateTime,
                    'sender_image': FirebaseAuth.instance.currentUser?.photoURL,
                  };
                  chatdbRef.push().set(Text_Chat);
                  final snap = await chatdbRef.get();
                  if (snap.exists) {
                    Map<Object?, Object?> data =
                        snap.value as Map<Object?, Object?>;
                    data.forEach((key, value) {
                      if (key == 'chat_members') {
                        if (value is List) {
                          List<Object?> objList = value as List<Object?>;
                          objList.forEach((obj) {
                            if (obj is Map) {
                              Map map = obj as Map;
                              map.forEach((key, value) async {
                                if (key == 'member_authid') {
                                  if (value !=
                                      FirebaseAuth.instance.currentUser!.uid) {
                                    String valueKey = value;
                                    var DestRef = FirebaseDatabase.instance
                                        .ref()
                                        .child('Chats')
                                        .child(valueKey)
                                        .child(widget.messageKey);
                                    DataSnapshot sappy = await chatdbRef.get();
                                    await DestRef.set(sappy.value);
                                  }
                                }
                              });
                            }
                          });
                        } else {
                          // value is not a Map, so do something else
                          // ...
                        }
                      }
                    });
                  } else {
                    print('no data');
                  }
                  setState(() {
                    ChatTextController.clear();
                  });
                }),
            SizedBox(height: gHeight / 150)
          ],
        ),
      ),
    );
  }

  void Messageback() async {
    final snap = await chatdbRef.get();
    if (snap.exists) {
      Map<Object?, Object?> data = snap.value as Map<Object?, Object?>;
      data.forEach((key, value) {
        if (key == 'chat_members') {
          if (value is List) {
            List<Object?> objList = value as List<Object?>;
            objList.forEach((obj) {
              if (obj is Map) {
                Map map = obj as Map;
                map.forEach((key, value) async {
                  if (key == 'member_authid') {
                    if (value != FirebaseAuth.instance.currentUser!.uid) {
                      String valueKey = value;
                      var DestRef = FirebaseDatabase.instance
                          .ref()
                          .child('Chats')
                          .child(valueKey)
                          .child(widget.messageKey);
                      DataSnapshot sappy = await chatdbRef.get();
                      await DestRef.set(sappy.value);
                    }
                  }
                });
              }
            });
          } else {
            // value is not a Map, so do something else
            // ...
          }
        }
      });
    } else {
      print('no data');
    }
    setState(() {
      ChatTextController.clear();
    });
  }

  Widget chatListItem(context, snapshot) {
    List<Message> messages = snapshot.data as List<Message>;
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        Message message = messages[index];
        return Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: gWidth / 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      message.message_sender_image,
                      height: gHeight / 18,
                      width: gWidth / 9,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message_sender,
                        style:
                            ((FirebaseAuth.instance.currentUser!.displayName ==
                                    message.message_sender)
                                ? TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.deepOrange)
                                : TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(message.message_text,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    message.message_timestamp,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding buildChatFormField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
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
        ),
      ),
    );
  }
}
