import 'dart:ui';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String endTime = "9:30 PM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String? location;
  int lan = 10;
  int long = 10;
  String? _currentAddress;
  Position? _currentPosition;

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentPosition();
    });
    super.initState();
  }

  getDateFromUser(BuildContext context) async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (pickerDate != null) {
      setState(() {
        selectedDateAtBar = pickerDate;
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
    var pickedTime = await buildShowTimePicker();
    String formattedTime = pickedTime?.format(context);
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
    } else if (isStarted == true) {
      setState(() {
        startTime = formattedTime;
      });
    } else if (isStarted == false) {
      setState(() {
        endTime = formattedTime;
      });
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
      setState(() => _currentPosition = position);
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
              InputField(title: "Title", hint: "Enter your title"),
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
                    press: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
