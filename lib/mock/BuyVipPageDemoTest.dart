import 'package:flutter/material.dart';

import '../pages/buyVipPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        child: BuyVipPage(),
      ),
    );
  }
}