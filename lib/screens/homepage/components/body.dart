import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lna/utils/constant.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class Body extends StatelessWidget {
  const Body({super.key});

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

CurvedNavigationBar BottomNavigation() {
  return CurvedNavigationBar(
    height: gHeight / 13,
    backgroundColor: Colors.white,
    color: buttonColor,
    animationDuration: kAnimationDuration,
    onTap: (value) {
      print(value);
    },
    items: [
      Icon(
        Icons.home,
      ),
      Icon(Icons.favorite),
      Icon(Icons.settings),
    ],
  );
}
