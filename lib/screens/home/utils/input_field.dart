import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lna/utils/constant.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? Controller;
  final Widget? widget;
  const InputField(
      {super.key,
      required this.title,
      required this.hint,
      this.Controller,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: gHeight / 40, left: gWidth / 70, right: gWidth / 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: gHeight / 100),
            height: gHeight / 14.5,
            decoration: BoxDecoration(
                border: Border.all(
                  color: buttonColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 20,
                    readOnly: widget == null ? false : true,
                    cursorColor: buttonColor,
                    autofocus: false,
                    controller: Controller,
                    style: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: gWidth / 60,
                        ),
                        hintText: hint,
                        hintStyle: GoogleFonts.lato(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                  ),
                ),
                widget == null ? Container() : Container(child: widget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
