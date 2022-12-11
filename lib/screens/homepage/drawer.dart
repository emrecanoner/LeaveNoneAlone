import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lna/screens/homepage/components/body.dart';
import 'package:lna/screens/homepage/menupage.dart';
import 'package:lna/utils/constant.dart';

class Drawer extends StatefulWidget {
  const Drawer({super.key});

  @override
  State<Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonColor,
      body: ZoomDrawer(angle: 0.0, menuScreen: MenuPage(), mainScreen: Body()),
    );
  }
}
