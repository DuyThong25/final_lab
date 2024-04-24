import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

const String urlLogo = "assets/images/hlphone_logo.png";

showToastMessage(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0);
}

formatVND(input) {
    var formatCurrency = NumberFormat.simpleCurrency(locale: 'vi');
    return formatCurrency.format(input);
}
