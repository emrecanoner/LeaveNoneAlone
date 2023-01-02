import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/chats/user_chat.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/screens/chats/create_chat.dart';
import 'package:image/image.dart' as img;


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

  void initState(){
    super.initState();
    setState(() {});
    getChat();
  }

  void getChat() async{
    DataSnapshot snapshot = await chatreference.get();
    if(snapshot.exists){
      print('Chats Exists');
    }else{
      print('No chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My events'),
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
            body: Container(
        child: Column(
          children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: getUserChats(FirebaseAuth.instance.currentUser!.uid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return chatsListItem(context, snapshot);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                ),
              ),
              // FloatingActionButton(
              //   child: Icon(Icons.message_sharp),
              //   backgroundColor: Color(0xffffaa17),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //       builder: (_) => createChat(),
              //       )
              //     );
              //   },
              // )
            ]
        ),
      ),
    );
  }
  Widget chatsListItem(context, snapshot) {
    List<Chat> chats = snapshot.data as List<Chat>;

    try{
      return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index){
          Chat chat = chats[index];
          
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                chat.chat_photo,
                height: gHeight / 18,
                width: gWidth / 9,
              ),
            ),
            title: Text(chat.chat_name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => userChat(messageKey: chat.chat_uid)
                ),        
              );
            },
          );
        }
      );
    }on NullThrownError catch (e){
      print(e.toString());
      return Container();
    }catch(e){
      print(e.toString());
      return Container();
    }
  }
}
