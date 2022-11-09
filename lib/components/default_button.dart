import 'package:flutter/material.dart';
import 'package:lna/utils/constant.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String? text;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: gHeight / 12,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll<Color>(buttonColor),
        ),
        onPressed: press,
        child: Text(
          text!,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
