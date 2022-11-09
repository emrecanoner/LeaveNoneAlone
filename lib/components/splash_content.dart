import 'package:flutter/material.dart';
import 'package:lna/utils/constant.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text(
          'Leave None Alone',
          style: TextStyle(
              fontSize: 36, color: buttonColor, fontWeight: FontWeight.bold),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: gHeight / 3,
          width: gWidth / 1.2,
        )
      ],
    );
  }
}
