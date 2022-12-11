import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lna/screens/homepage/components/body.dart';
import 'package:lna/utils/constant.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MenuDrawer(),
        automaticallyImplyLeading: false,
        title: Text("Home Page"),
        actions: [
          Container(
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.all(3),
            height: 15,
            width: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Location",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Icon(
                  Icons.location_on,
                  size: 15,
                )
              ],
            ),
          ),
        ],
      ),
      body: Body(),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ZoomDrawer.of(context)?.toggle();
      },
      icon: Icon(Icons.menu),
    );
  }
}
