import 'package:flutter/material.dart';

import '../views/VipCardPageView.dart';
import '../views/vipCardItem.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DisplayPage(),
    );
  }
}

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => new _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double imgWidth = size.width - 21;
    double imgHeight = imgWidth * 152/319;

    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          height: 30,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0x001A0258),
                Color(0xFF3D0363),
              ],
            ),
          ),
        ),
        preferredSize:  Size(MediaQuery.of(context).size.width, 45),
      ),
      body: Container(
        child: VipCardPageView(),
      ),
    );
  }

}

