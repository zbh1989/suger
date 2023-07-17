import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {

  static show(String message, {duration = 2000}) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static tips(String message, {duration = 2000,position:ToastGravity.CENTER}) {
    Fluttertoast.showToast(
        msg: message,
        gravity: position,
        backgroundColor: Colors.white,
        textColor: Colors.grey,
        fontSize: 16.0);
  }



  static dismiss() {}
}
