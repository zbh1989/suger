
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpreadWidget(),
    );
  }
}

class SpreadWidget extends StatefulWidget {


  @override
  _SpreadWidgetState createState() => _SpreadWidgetState();
}

class _SpreadWidgetState extends State<SpreadWidget>{

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

  @override
  Widget build(BuildContext context) {
    Future<String> future =  _deviceDetails();
    future.then(
      (value) => print('***********************' + value), /// cc5170134d382b5c
    );

    return Container(
      color: Colors.red,
      width: 100,
      height: 100,
      // child: Image.asset('lib/assets/images/alipay.png',height: 230,width: 230,),
      child: Container(
        color: Colors.green,
        width: 100,
        height: 100,
      ),
    );
  }
}