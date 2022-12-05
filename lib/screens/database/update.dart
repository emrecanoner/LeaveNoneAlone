import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
 
class UpdateRecord extends StatefulWidget {
  
  const UpdateRecord({Key? key, required this.userKey}) : super(key: key);
 
  final String userKey;
 
  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}
 
class _UpdateRecordState extends State<UpdateRecord> {
 
  final  username = TextEditingController();
  final  phoneN= TextEditingController();
 
  late DatabaseReference dbRef;
 
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Users');
    getUserData();
  }
 
  void getUserData() async {
    DataSnapshot snapshot = await dbRef.child(widget.userKey).get();
 
    Map user = snapshot.value as Map;
 
    username.text = user['user_name'];
    phoneN.text = user['phone_number'];
 
  }
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updating record'),
      ),
      body:  Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Updating data in Firebase Realtime Database',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: username,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter Your Name',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: phoneN,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  hintText: 'Enter Your Number',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
 
                  Map<String, String> users = {
                    'user_name': username.text,
                    'phone_number': phoneN.text,
                  };
 
                  dbRef.child(widget.userKey).update(users)
                  .then((value) => {
                     Navigator.pop(context) 
                  });
 
                },
                child: const Text('Update'),
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}