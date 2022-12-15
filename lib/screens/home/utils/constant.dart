import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/database/utils/constant.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/screens/profile/profile_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:google_fonts/google_fonts.dart';

List<Widget> pageList = [
  HomePageEventIcon(),
  HomePageHomeIcon(),
];

int pageIndex = 1;

/* class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
} */

/* class _BottomNavigationState extends State<BottomNavigation> {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: gHeight / 13,
      backgroundColor: Colors.white,
      color: buttonColor,
      animationDuration: kAnimationDuration,
      index: index,
      onTap: (index) {
        setState(() {
          this.index = index;
          pageIndex = index;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        });
      },
      items: [
        Icon(
          Icons.favorite,
        ),
        Icon(Icons.home),
        Icon(Icons.settings),
      ],
    );
  }
} */

class HomePageHomeIcon extends StatelessWidget {
  const HomePageHomeIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: gHeight / 8, right: gWidth / 80, left: gWidth / 80),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: gHeight / 40),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, $userName",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Let's explore what's happening nearby",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: buttonColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/emre.jpeg",
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: gHeight / 50,
          ),
          Container(
            child: DatePicker(
              DateTime.now(),
              height: gHeight / 9,
              width: gWidth / 8,
              initialSelectedDate: DateTime.now(),
              selectionColor: buttonColor,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  /* SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Container(
                width: gWidth / 4,
                height: gHeight / 4,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/emre.jpeg",
                    ),
                  ),
                  maxRadius: 15,
                  minRadius: 15,
                ),
              ),
              Container(
                height: gHeight / 25,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(buttonColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(color: buttonColor)))),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ));
                    },
                    child: Icon(
                      LineAwesomeIcons.plus,
                      size: 20,
                    )),
              ),
              SizedBox(
                width: gWidth / 30,
              ),
              Column(
                children: [
                  Text(
                    "Welcome,",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    userName,
                    style: TextStyle(fontSize: 30),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: gHeight / 30,
          ),
          Container(
            width: gWidth,
            height: gHeight / 500,
            color: buttonColor,
          ),
          SizedBox(
            height: gHeight / 50,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Past Events",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 30),
            ),
          ), */
}

class HomePageEventIcon extends StatelessWidget {
  const HomePageEventIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Container(
                width: gWidth / 4,
                height: gHeight / 4,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/emre.jpeg",
                    ),
                  ),
                  maxRadius: 15,
                  minRadius: 15,
                ),
              ),
              Container(
                height: gHeight / 25,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(buttonColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(color: buttonColor)))),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ));
                    },
                    child: Icon(
                      LineAwesomeIcons.plus,
                      size: 20,
                    )),
              ),
              SizedBox(
                width: gWidth / 30,
              ),
              Column(
                children: [
                  Text(
                    "Welcome,",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    userName,
                    style: TextStyle(fontSize: 30),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: gHeight / 30,
          ),
          Container(
            width: gWidth,
            height: gHeight / 500,
            color: buttonColor,
          ),
          SizedBox(
            height: gHeight / 50,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Create Event",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}

/* class DateTile extends StatelessWidget {
  String? weekDay;
  String? date;
  bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? buttonColor : Colors.transparent,
      child: Column(
        children: [Text(data)],
      ),
    );
  }
}

class DateModel {
  String? weekDay;
  String? date;
  bool? isSelected;
}

List<DateModel> getDates() {
  List<DateModel> dates;
  DateModel dateModel = new DateModel();


} */
