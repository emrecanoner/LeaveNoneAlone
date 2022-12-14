import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lna/screens/database/utils/constant.dart';
import 'package:lna/screens/home/components/body.dart';
import 'package:lna/screens/home/utils/constant.dart';
import 'package:lna/screens/profile/profile_page.dart';
import 'package:lna/screens/sign_out/sign_out_page.dart';
import 'package:lna/utils/constant.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget page = MainPage();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Builder(builder: (context) {
        return MenuPage(
          onPageChanged: (a) {
            setState(() {
              page = a;
            });
            ZoomDrawer.of(context)!.close();
          },
        );
      }),
      mainScreen: page,
      borderRadius: 24.0,
      showShadow: true,
      drawerShadowsBackgroundColor: Colors.grey[300]!,
      menuBackgroundColor: buttonColor,
    );
  }
}

class MenuPage extends StatelessWidget {
  MenuPage({super.key, required this.onPageChanged});
  final Function(Widget) onPageChanged;
  List<ListItems> drawerItems = [
    ListItems(
        Icon(Icons.home),
        Text(
          "Home",
        ),
        HomePage()),
    ListItems(Icon(Icons.person), Text("Profile"), ProfilePage()),
    ListItems(Icon(Icons.logout), Text("Logout"), null)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: drawerItems
            .map((e) => ListTile(
                  onTap: () {
                    if (e.page == null) {
                      AuthService().signOut();
                    } else {
                      onPageChanged(e.page!);
                    }
                  },
                  title: e.text,
                  leading: e.icon,
                ))
            .toList(),
      ),
    );
  }
}

class ListItems {
  final Icon icon;
  final Text text;
  final Widget? page;

  ListItems(this.icon, this.text, [this.page]);
}

/*class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setstate
        },
        items: BottomNavigationBarItem(
            icon: Icon(
          Icons.favorite,semanticLabel: ,
        )),
        BottomNavigationBarItem(Icon(
          Icons.favorite,
        )),
        BottomNavigationBarItem(Icon(
          Icons.favorite,
        )),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(selectedCity)));
            },
            icon: Row(
              children: [
                Text(selectedCity),
                Icon(Icons.location_on_outlined),
              ],
            ),
          ),
        ],
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(Icons.menu_open_rounded)),
        automaticallyImplyLeading: false,
        title: Text(
          "Leave None Alone",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: pageList[pageIndex],
    );
  }
}*/

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: buildMyNavBar(context)
      /*backgroundColor: Colors.white,
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event,
              color: buttonColor,
            ),
            label: "Event",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        ],*/
      ,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(selectedCity)));
            },
            icon: Row(
              children: [
                Text(selectedCity),
                Icon(Icons.location_on_outlined),
              ],
            ),
          ),
        ],
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(Icons.menu_open_rounded)),
        automaticallyImplyLeading: false,
        title: Text(
          "Leave None Alone",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: pageList[pageIndex],
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: gWidth / 15, right: gWidth / 15),
      height: gHeight / 12,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 25,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.white,
                    size: 25,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.chat_bubble,
                    color: Colors.white,
                    size: 25,
                  )
                : const Icon(
                    Icons.chat_bubble_outline_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
          ),
        ],
      ),
    );
  }
}
