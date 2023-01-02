import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:lna/screens/database/terms_and_conditions_dialog.dart';
import 'package:lna/utils/constant.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: TextStyle(color: Colors.black),
            text: "By creating an account, you are agreeing to our\n",
            children: [
              TextSpan(
                  text: "Terms and conditions",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return TermsAndConditionsDialog(
                              mdFileName: 'terms_and_conditions.md');
                        },
                      );
                    }),
            ]),
      ),
    );
  }
}
