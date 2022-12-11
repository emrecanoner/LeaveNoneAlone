import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lna/utils/constant.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class Body extends StatelessWidget {
  Body({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigation(),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gWidth / 25),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
}

/*CurvedNavigationBar BottomNavigation() {
  return CurvedNavigationBar(
    height: gHeight / 13,
    backgroundColor: Colors.white,
    color: buttonColor,
    animationDuration: kAnimationDuration,
    index: index,
    onTap: (index) {
      
    },
    items: [
      Icon(
        Icons.favorite,
      ),
      Icon(Icons.home),
      Icon(Icons.settings),
    ],
  );
}*/
