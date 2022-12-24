import 'dart:ui';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/screens/home/utils/constant.dart';
import 'package:lna/screens/home/utils/input_field.dart';
import 'package:lna/utils/constant.dart';
import 'package:lna/utils/custom_snackbar.dart';
import 'package:lna/utils/default_button.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String endTime = "9:30 PM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

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
              InputField(title: "Location", hint: "Enter your location"),
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
