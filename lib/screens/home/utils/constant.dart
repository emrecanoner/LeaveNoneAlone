import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lna/screens/chats/create_chat.dart';
import 'package:lna/screens/chats/members.dart';
import 'package:lna/screens/events/event_account.dart';
import 'package:lna/screens/home/create_event.dart';
import 'package:lna/screens/home/home_page.dart';
import 'package:lna/screens/profile/profile_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
//<<<<<<< HEAD
import 'package:lna/utils/custom_snackbar.dart';
//=======
import 'package:lna/utils/default_button.dart';

import '../../chats/user_chatlist.dart';
import '../../friends/search_Users_list.dart';
//>>>>>>> b582d40db834b6623c8c8b9c678348847d8efa4a

List<Widget> pageList = [
  CreateEvent(),
  HomePageHomeIcon(),
  searchLNAUserBar(),
  // userChatList(),
  //membersList(),
];

DateTime selectedDateAtBar = DateTime.now();

DatePickerController dateControl = DatePickerController();

String userName = FirebaseAuth.instance.currentUser!.displayName.toString();

class HomePageHomeIcon extends StatefulWidget {
  const HomePageHomeIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageHomeIcon> createState() => _HomePageHomeIconState();
}

class _HomePageHomeIconState extends State<HomePageHomeIcon> {
  late SingleValueDropDownController cityController;
  String cityEvent = '';

  @override
  void initState() {
    cityController = SingleValueDropDownController();
    super.initState();
  }

  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: gHeight / 6.5, right: gWidth / 80, left: gWidth / 80),
      child: Column(
        children: [
          // SizedBox(height: gHeight / 50),
          FutureBuilder(
              future: customerAccountDetails(
                  FirebaseAuth.instance.currentUser!.phoneNumber?.substring(3)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return buildTaskBar(context, snapshot);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: gWidth / 45),
            child: buildCityDropdown(),
          ),
          SizedBox(height: 10),
          FutureBuilder(
              future: getEventsbyCity(cityEvent),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return buildEventList(context, snapshot);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  Widget buildEventList(context, snapshot) {
    List<LNAevent> eventmap = snapshot.data as List<LNAevent>;
    return ListView.builder(
      itemCount: eventmap.length,
      itemBuilder: (BuildContext context, int index) {
        LNAevent event = eventmap[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              event.event_photo,
              height: gHeight / 18,
              width: gWidth / 9,
            ),
          ),
          title: Text(event.event_title),
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => eventAccount(eventName: event.event_title),
                ));
          },
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Container buildDateBar() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        onDateChange: (selectedDate) {
          selectedDateAtBar = selectedDate;
        },
        controller: dateControl,
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
    );
  }

  DropDownTextField buildCityDropdown() {
    return DropDownTextField(
      controller: cityController,
      clearOption: true,
      enableSearch: true,
      dropDownIconProperty: IconProperty(color: buttonColor),
      clearIconProperty: IconProperty(color: buttonColor),
      searchShowCursor: true,
      searchDecoration: InputDecoration(
        labelText: "Search City for Events",
        labelStyle: TextStyle(color: iconColor, fontSize: 13),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      textFieldDecoration: InputDecoration(
        prefix: Padding(
          padding: EdgeInsets.all(4),
        ),
        labelText: "City",
        labelStyle: TextStyle(color: iconColor),
        hintText: "Select city for events",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value == null) {
          return "Required field";
        } else {
          cityEvent = value.toString();
          return null;
        }
      },
      dropDownItemCount: 6,
      dropDownList: const [
        DropDownValueModel(name: 'Adana', value: "Adana"),
        DropDownValueModel(name: 'Adıyaman', value: "Adıyaman"),
        DropDownValueModel(name: 'Afyonkarahisar', value: "Afyonkarahisar"),
        DropDownValueModel(name: 'Ağrı', value: "Ağrı"),
        DropDownValueModel(name: 'Aksaray', value: "Aksaray"),
        DropDownValueModel(name: 'Amasya', value: "Amasya"),
        DropDownValueModel(name: 'Ankara', value: "Ankara"),
        DropDownValueModel(name: 'Antalya', value: "Antalya"),
        DropDownValueModel(name: 'Ardahan', value: "Ardahan"),
        DropDownValueModel(name: 'Artvin', value: "Artvin"),
        DropDownValueModel(name: 'Aydın', value: "Aydın"),
        DropDownValueModel(name: 'Balıkesir', value: "Balıkesir"),
        DropDownValueModel(name: 'Bartın', value: "Bartın"),
        DropDownValueModel(name: 'Batman', value: "Batman"),
        DropDownValueModel(name: 'Bayburt', value: "Bayburt"),
        DropDownValueModel(name: 'Bilecik', value: "Bilecik"),
        DropDownValueModel(name: 'Bingöl', value: "Bingöl"),
        DropDownValueModel(name: 'Bitlis', value: "Bitlis"),
        DropDownValueModel(name: 'Bolu', value: "Bolu"),
        DropDownValueModel(name: 'Burdur', value: "Burdur"),
        DropDownValueModel(name: 'Bursa', value: "Bursa"),
        DropDownValueModel(name: 'Çanakkale', value: "Çanakkale"),
        DropDownValueModel(name: 'Çankırı', value: "Çankırı"),
        DropDownValueModel(name: 'Çorum', value: "Çorum"),
        DropDownValueModel(name: 'Denizli', value: "Denizli"),
        DropDownValueModel(name: 'Diyarbakır', value: "Diyarbakır"),
        DropDownValueModel(name: 'Düzce', value: "Düzce"),
        DropDownValueModel(name: 'Edirne', value: "Edirne"),
        DropDownValueModel(name: 'Elazığ', value: "Elazığ"),
        DropDownValueModel(name: 'Erzincan', value: "Erzincan"),
        DropDownValueModel(name: 'Erzurum', value: "Erzurum"),
        DropDownValueModel(name: 'Eskişehir', value: "Eskişehir"),
        DropDownValueModel(name: 'Gaziantep', value: "Gaziantep"),
        DropDownValueModel(name: 'Giresun', value: "Giresun"),
        DropDownValueModel(name: 'Gümüşhane', value: "Gümüşhane"),
        DropDownValueModel(name: 'Hakkâri', value: "Hakkâri"),
        DropDownValueModel(name: 'Hatay', value: "Hatay"),
        DropDownValueModel(name: 'Iğdır', value: "Iğdır"),
        DropDownValueModel(name: 'Isparta', value: "Isparta"),
        DropDownValueModel(name: 'İstanbul', value: "İstanbul"),
        DropDownValueModel(name: 'İzmir', value: "İzmir"),
        DropDownValueModel(name: 'Kahramanmaraş', value: "Kahramanmaraş"),
        DropDownValueModel(name: 'Karabük', value: "Karabük"),
        DropDownValueModel(name: 'Karaman', value: "Karaman"),
        DropDownValueModel(name: 'Kars', value: "Kars"),
        DropDownValueModel(name: 'Kastamonu', value: "Kastamonu"),
        DropDownValueModel(name: 'Kayseri', value: "Kayseri"),
        DropDownValueModel(name: 'Kilis', value: "Kilis"),
        DropDownValueModel(name: 'Kırıkkale', value: "Kırıkkale"),
        DropDownValueModel(name: 'Kırklareli', value: "Kırklareli"),
        DropDownValueModel(name: 'Kırşehir', value: "Kırşehir"),
        DropDownValueModel(name: 'Kocaeli', value: "Kocaeli"),
        DropDownValueModel(name: 'Konya', value: "Konya"),
        DropDownValueModel(name: 'Kütahya', value: "Kütahya"),
        DropDownValueModel(name: 'Malatya', value: "Malatya"),
        DropDownValueModel(name: 'Manisa', value: "Manisa"),
        DropDownValueModel(name: 'Mardin', value: "Mardin"),
        DropDownValueModel(name: 'Mersin', value: "Mersin"),
        DropDownValueModel(name: 'Muğla', value: "Muğla"),
        DropDownValueModel(name: 'Muş', value: "Muş"),
        DropDownValueModel(name: 'Nevşehir', value: "Nevşehir"),
        DropDownValueModel(name: 'Niğde', value: "Niğde"),
        DropDownValueModel(name: 'Ordu', value: "Ordu"),
        DropDownValueModel(name: 'Osmaniye', value: "Osmaniye"),
        DropDownValueModel(name: 'Rize', value: "Rize"),
        DropDownValueModel(name: 'Sakarya', value: "Sakarya"),
        DropDownValueModel(name: 'Samsun', value: "Samsun"),
        DropDownValueModel(name: 'Şanlıurfa', value: "Şanlıurfa"),
        DropDownValueModel(name: 'Siirt', value: "Siirt"),
        DropDownValueModel(name: 'Sinop', value: "Sinop"),
        DropDownValueModel(name: 'Sivas', value: "Sivas"),
        DropDownValueModel(name: 'Şırnak', value: "Şırnak"),
        DropDownValueModel(name: 'Tekirdağ', value: "Tekirdağ"),
        DropDownValueModel(name: 'Tokat', value: "Tokat"),
        DropDownValueModel(name: 'Trabzon', value: "Trabzon"),
        DropDownValueModel(name: 'Tunceli', value: "Tunceli"),
        DropDownValueModel(name: 'Uşak', value: "Uşak"),
        DropDownValueModel(name: 'Van', value: "Van"),
        DropDownValueModel(name: 'Yalova', value: "Yalova"),
        DropDownValueModel(name: 'Yozgat', value: "Yozgat"),
        DropDownValueModel(name: 'Zonguldak', value: "Zonguldak"),
      ],
      onChanged: (val) {
        setState(() {
          if (val == "") {
            cityEvent = "";
          } else {
            cityEvent = val.value;
          }
        });
      },
    );
  }

  Widget buildTaskBar(context, snapshot) {
    Map CurrUser = snapshot.data as Map;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gHeight / 40),
      child: Column(children: <Widget>[
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${CurrUser['name']}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: gHeight / 150),
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
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    CurrUser['photoURL'],
                    height: gHeight / 18,
                    width: gWidth / 9,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: gHeight / 150),
        buildDateBar(),
        SizedBox(height: gHeight / 50),
      ]),
    );
  }
}

class HomePageEventIcon extends StatelessWidget {
  const HomePageEventIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: gHeight / 6.5, right: gWidth / 80, left: gWidth / 80),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: buttonColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        FirebaseAuth.instance.currentUser!.photoURL.toString(),
                        height: gHeight / 18,
                      ),
                    ),
                  ),
                ),
/*                 ClipOval(
                  child: Container(
                    width: gWidth / 4,
                    height: gHeight / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: NetworkImage(FirebaseAuth
                            .instance.currentUser!.photoURL
                            .toString()),
                      ),
                    ),
                    child: TextButton(
                        child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: null,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        }),
                  ),
                ), */
                // Container(
                //   height: gHeight / 25,
                //   child: ElevatedButton(
                //       style: ButtonStyle(
                //           backgroundColor:
                //               MaterialStateProperty.all<Color>(buttonColor),
                //           shape:
                //               MaterialStateProperty.all<RoundedRectangleBorder>(
                //                   RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(12.0),
                //                       side: BorderSide(color: buttonColor)))),
                //       onPressed: () {
                //         Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => ProfilePage(),
                //             ));
                //       },
                //       child: Icon(
                //         LineAwesomeIcons.plus,
                //         size: 20,
                //       )),
                // ),
                SizedBox(
                  width: gWidth / 30,
                ),
                Column(
                  children: [
                    Text(
                      "Welcome, ${FirebaseAuth.instance.currentUser!.displayName.toString()}",
                      style: TextStyle(fontSize: 30),
                    ),
                    // Text(
                    //   userName,
                    //   style: TextStyle(fontSize: 30),
                    // )
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
            SizedBox(
              height: gHeight / 50,
            ),

            // DefaultButton(
            //     text: 'Chatlist',
            //     press: () {
            //       Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => userChatList(),
            //           ));
            //     }),
            // SizedBox(
            //   height: gHeight / 50,
            // ),
            // DefaultButton(
            //     text: 'Add friend',
            //     press: () {
            //       Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => searchLNAUserBar(),
            //           ));
            //     }),
          ],
        ),
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
