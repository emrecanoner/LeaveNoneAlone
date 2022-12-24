import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DefaultButton(
                text: 'Create new chat', 
                press: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (_) => createChat(),
                    )
                  );
                }
              ),
              FutureBuilder(
                future: getUserChats(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return chatsListItem(context, snapshot);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
              ),
            ]
          ),
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
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              height: 110,
              color: Colors.amberAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  chat.chat_name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => userChat(messageKey: chat.chat_uid)
                            ),        
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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