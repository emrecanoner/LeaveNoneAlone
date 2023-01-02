import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/events/splash/animated_splash.dart';
import 'package:lna/screens/friends/search_Users_list.dart';
import 'package:lna/screens/friends/splash/animated_splash.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/default_button.dart';
import 'package:lna/screens/profile/profile_edit.dart';

class eventAccount extends StatefulWidget {
  const eventAccount({Key? key, required this.eventName}) : super(key: key);

  final String eventName;

  State<eventAccount> createState() => _eventAccountState();
}

class _eventAccountState extends State<eventAccount> {
  late String photo;
  bool eventJoined = true;

  late DatabaseReference eventdbref;
  late DatabaseReference chatDf;

  @override
  void initState() {
    super.initState();
    eventdbref = FirebaseDatabase.instance.ref().child('Events');
    chatDf = FirebaseDatabase.instance.ref().child('Chats');
    getEvent();
  }

  void getEvent() async {
    List<Chat> events =
        await getUserChats(FirebaseAuth.instance.currentUser!.uid);
    for (var element in events) {
      if (element.chat_name == widget.eventName) {
        eventJoined = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
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
      body: FutureBuilder(
        future: getEventDetails(widget.eventName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return displayEventInformation(context, snapshot);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget displayEventInformation(context, snapshot) {
    Map EventSearched = snapshot.data as Map;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(children: [
        Center(
          child: Stack(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    (EventSearched['event_photo']),
                    height: gHeight / 6,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
        SizedBox(height: 50),
        TextField(
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "Event Name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_title']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 15),
        TextField(
          enabled: false,
          readOnly: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "Date",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_date']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 15),
        TextField(
          enabled: false,
          readOnly: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "Start time",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_starttime']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 15),
        TextField(
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "End Time",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_endtime']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 15),
        TextField(
          minLines: 1,
          maxLines: 20,
          enabled: false,
          readOnly: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3, left: 10),
              labelText: "Location",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "${EventSearched['event_location']}",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(height: 80),
        Visibility(
          child: DefaultButton(
              text: 'Join Event',
              press: () async {
                String chatKey = await getChatUID(EventSearched['event_title'],
                    EventSearched['event_creator']);
                Map newItem = {
                  'member_name': FirebaseAuth.instance.currentUser!.displayName,
                  'member_phone': FirebaseAuth.instance.currentUser!.phoneNumber
                      ?.substring(3),
                  'member_photo': FirebaseAuth.instance.currentUser!.photoURL,
                  'member_authid': FirebaseAuth.instance.currentUser!.uid,
                };
                var chDref = FirebaseDatabase.instance
                    .ref()
                    .child('Chats')
                    .child(EventSearched['event_creator'])
                    .child(chatKey);
                bool gotiT = false;
                final shnap = await chDref.get();
                if (shnap.exists) {
                  Map<Object?, Object?> data =
                      shnap.value as Map<Object?, Object?>;

                  data.forEach((key, value) async {
                    if (key == 'chat_members') {
                      if (value is List) {
                        // List<Object?> objList = value as List<Object?>;
                        List ok = [];
                        ok.addAll(value);
                        ok.add(newItem);
                        chDref.update({'chat_members': ok});
                      }
                    }
                  });
                } else {
                  print('no data');
                }

                final shap = await chDref.get();
                var currUs = FirebaseDatabase.instance
                    .ref()
                    .child('Chats')
                    .child(FirebaseAuth.instance.currentUser!.uid)
                    .child(chatKey);
                currUs.set(shap.value);

                final snap = await chDref.get();
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
                                if (value ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid ||
                                    value == EventSearched['event_creator']) {
                                } else {
                                  String valueKey = value;
                                  var DestRef = FirebaseDatabase.instance
                                      .ref()
                                      .child('Chats')
                                      .child(valueKey)
                                      .child(chatKey);
                                  DataSnapshot sappy = await chDref.get();
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

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SplashScreenEAnimated(chatK: chatKey),
                    ));
                Fluttertoast.showToast(
                  msg: "Joining Event",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: buttonColor,
                  textColor: Colors.white,
                  fontSize: 16,
                );
              }),
          visible: eventJoined,
        ),
      ]),
    );
  }
}
