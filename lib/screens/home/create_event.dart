import 'dart:ui';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/chats/create_chat.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/screens/home/utils/constant.dart';
import 'package:lna/screens/home/utils/input_field.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/custom_snackbar.dart';
import 'package:lna/utils/default_button.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String endTime = "21:30";
  String startTime = DateFormat("HH:mm").format(DateTime.now()).toString();
  String? location;
  int lan = 10;
  int long = 10;
  String? _currentAddress;
  Position? _currentPosition;
  String selectedevent = '';

  DateTime? pickerDate;

  final titleController = TextEditingController();
  late SingleValueDropDownController eventTypeController;


  late DatabaseReference eventdref;

  void initState() {
    eventdref = FirebaseDatabase.instance.ref().child('Events');
    eventTypeController = SingleValueDropDownController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentPosition();
    });
    super.initState();
  }

  void dispose() {
    eventTypeController.dispose();
    super.dispose();
  }

  getDateFromUser(BuildContext context) async {
    pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickerDate != null) {
      setState(() {
        selectedDateAtBar = pickerDate!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarContent(
              errorMessage: "You didn't select date, select it immediately"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  getTimeFromUser({required bool isStarted}) async {
    if(pickerDate!=null){
      var pickedTime = await buildShowTimePicker();
      String formattedTime = pickedTime?.format(context);
      DateTime selectedTime = DateTime(
        pickerDate!.year,
        pickerDate!.month,
        pickerDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (pickedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomSnackBarContent(
                errorMessage: "You didn't select time, select it immediately"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }else if(selectedTime.isBefore(DateTime.now())){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomSnackBarContent(
                errorMessage: "You can't select a time before now"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }else{
        if (isStarted == true) {
          setState(() {
            startTime = formattedTime;
          });
        } else if (isStarted == false) {
          setState(() {
            endTime = formattedTime;
          });
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarContent(
              errorMessage: "You have to pick date first"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  buildShowTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(startTime.split(":")[0]),
        minute: int.parse(startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      //_getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  /* Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  } */

  void showModel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: gHeight / 2,
            child: Center(
              child: OpenStreetMapSearchAndPick(
                center: LatLong(_currentPosition?.latitude ?? 10,
                    _currentPosition?.longitude ?? 10),
                buttonColor: buttonColor,
                buttonText: "Set Current Location",
                onPicked: (pickedData) {
                  Navigator.pop(context);
                  setState(() {
                    //int i = pickedData.address.length;
                    location = pickedData.address;
/*                     while (pickedData.address.length > 0) {
                      if (location?[i] == "i") {
                        location?[i] = '4';
                      }
                    } */
                  });
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: gWidth / 50, right: gWidth / 50),
      child: Padding(
        padding: EdgeInsets.only(
            top: gHeight / 6.5, right: gWidth / 80, left: gWidth / 80),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Event",
                style: GoogleFonts.lato(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InputField(
                title: "Title", 
                hint: "Enter your title",
                Controller: titleController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(selectedDateAtBar),
                widget: IconButton(
                  onPressed: () {
                    getDateFromUser(context);
                  },
                  icon: Icon(Icons.calendar_today_outlined),
                  color: buttonColor,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: startTime,

                      widget: IconButton(
                        onPressed: () {
                          getTimeFromUser(isStarted: true);
                        },
                        icon: Icon(Icons.access_time_rounded),
                        color: buttonColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: endTime,
                      widget: IconButton(
                        onPressed: () {
                          getTimeFromUser(isStarted: false);
                        },
                        icon: Icon(Icons.access_time_rounded),
                        color: buttonColor,
                      ),
                    ),
                  ),
                ],
              ),
              buildEventTypeDropdown(),
              InputField(
                title: "Location",
                hint: location ?? "Enter your location",
                widget: IconButton(
                  onPressed: () {
                    _getCurrentPosition().then((value) => showModel(context));
                  },
                  icon: Icon(Icons.location_city_outlined),
                  color: buttonColor,
                ),
              ),
              SizedBox(height: gHeight / 15),
              Center(
                child: DefaultButton(
                    text: "Create",
                    press: (() async{
                      String date = DateFormat('dd-MM-yyyy').format(selectedDateAtBar);
                      Map Curruser = await customerAccountDetails(FirebaseAuth.instance.currentUser!.phoneNumber?.substring(3));
                      String event_photo = '';
                      if(selectedevent=='Basketball'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Fbasketball.png?alt=media&token=13852706-3211-41fd-8744-3dc3bc3479e2';
                      }else if(selectedevent=='Coffee'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Fcoffee.png?alt=media&token=80504e6d-08c8-4159-84e2-34571f6f910f';
                      }else if(selectedevent=='Dance party'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Fdance%20party.png?alt=media&token=1bb64657-411b-4302-9e2a-6c1059b1221a';
                      }else if(selectedevent=='Football'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Ffootball.png?alt=media&token=55a1dcf8-10c8-4baa-8dca-36d896e1cebf';
                      }else if(selectedevent=='Ice Skate'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Fice-skate.png?alt=media&token=7a731396-b665-40ce-b5c4-b6774866ba62';
                      }else if(selectedevent=='Normal party'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Fnormal%20party.png?alt=media&token=9ad1fb04-6ef9-4a04-915e-669d647c191d';
                      }else if(selectedevent=='Surfing'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Fsurfing.png?alt=media&token=f751c534-671b-42a0-893c-480255668a84';
                      }else if(selectedevent=='Swimming'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Fswimming.png?alt=media&token=dfa1aa98-557f-4990-aa68-778ccb083eb4';
                      }else if(selectedevent=='Tennis'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Ftennis.png?alt=media&token=b62bbecf-919c-402d-aad2-e52ee490488d';
                      }else if(selectedevent=='Touring'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Ftouring.png?alt=media&token=f740a298-178c-4ec5-9496-a6dd9613a018';
                      }else if(selectedevent=='Other'){
                        event_photo = 
                        'https://firebasestorage.googleapis.com/v0/b/leavenonealone.appspot.com/o/event%20icons%2Fevent.png?alt=media&token=27dc400e-158c-4973-acf5-06b5956f7779';
                      }
                      Map event = {
                        'event_title': titleController.text,
                        'event_photo': event_photo,
                        'event_city': Curruser['city'],
                        'event_type': selectedevent,
                        'event_date': date,
                        'start_time': startTime,
                        'end_time': endTime,
                        'event_location': location
                      };
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => createChat(chatN: titleController.text, chatMap: event),
                          ));
                    })),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropDownTextField buildEventTypeDropdown() {
    return DropDownTextField(
      controller: eventTypeController,
      clearOption: true,
      enableSearch: true,
      dropDownIconProperty: IconProperty(color: buttonColor),
      clearIconProperty: IconProperty(color: buttonColor),
      searchShowCursor: true,
      searchDecoration: InputDecoration(
        labelText: "Choose the event type",
        labelStyle: TextStyle(color: iconColor, fontSize: 13),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      textFieldDecoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "Event Type",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Select your event",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value == null) {
          return "Required field";
        } else {
          selectedevent = value.toString();
          return null;
        }
      },
      dropDownItemCount: 6,
      dropDownList: const [
        DropDownValueModel(name: 'Basketball', value: "Basketball"),
        DropDownValueModel(name: 'Coffee', value: "Coffee"),
        DropDownValueModel(name: 'Dance party', value: "Dance party"),
        DropDownValueModel(name: 'Football', value: "Football"),
        DropDownValueModel(name: 'Ice Skate', value: "Ice Skate"),
        DropDownValueModel(name: 'Normal party', value: "Normal party"),
        DropDownValueModel(name: 'Surfing', value: "Surfing"),
        DropDownValueModel(name: 'Swimming', value: "Swimming"),
        DropDownValueModel(name: 'Tennis', value: "Tennis"),
        DropDownValueModel(name: 'Touring', value: "Touring"),
        DropDownValueModel(name: 'Other', value: "Other"),

      ],
      onChanged: (val) {
        if (val == "") {
          selectedevent = "";
        } else {
          selectedevent = val.value;
        }
      },
    );
  }
}
