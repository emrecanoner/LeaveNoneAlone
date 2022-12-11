import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lna/screens/home/components/body.dart';
import 'package:lna/screens/profile/profile_page.dart';
import 'package:lna/screens/sign_out/sign_out_page.dart';
import 'package:lna/utils/constant.dart';

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
    ListItems(Icon(Icons.home), Text("Home"), HomePage()),
    ListItems(Icon(Icons.person), Text("Profile"), ProfilePage()),
    ListItems(Icon(Icons.logout), Text("Logout"), SignOutPage())
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
                    onPageChanged(e.page);
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
  final Widget page;

  ListItems(this.icon, this.text, this.page);
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(Icons.menu)),
        automaticallyImplyLeading: false,
        title: Text("Home Page"),
      ),
      body: Body(),
    );
    ;
  }
}
