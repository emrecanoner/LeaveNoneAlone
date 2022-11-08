import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:lna/models/mysql.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final gWidth = Get.width;
final gHeight = Get.height;
//

final Color buttonColor = Color(0xffffaa17);
final Color iconColor = Color(0xff7e899d);
final Color text1Color = Color.fromRGBO(255, 90, 90, 90);
//

var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager);
