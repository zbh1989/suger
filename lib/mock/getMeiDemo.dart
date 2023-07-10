import 'package:caihong_app/base/presenter/base_presenter.dart';
import 'package:caihong_app/network/api/network_api.dart';
import 'package:caihong_app/network/network_util.dart';
import 'package:caihong_app/pages/homePage.dart';
import 'package:caihong_app/utils/PreferenceUtils.dart';
import 'package:caihong_app/utils/db_utils.dart';
import 'package:caihong_app/utils/time_format_util.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

Future<String> _deviceDetails() async{
  String deviceId;
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceId = build.androidId;
      //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceId = data.identifierForVendor; //
    }
  } on PlatformException {
    print('Failed to get platform version');
  }
  return deviceId;
}

main(){
  Future<String> future =  _deviceDetails();
  future.then((value) => print(value),);
}