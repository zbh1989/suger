import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../network/api/network_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DemoWidget(),
    );
  }
}

class DemoWidget extends StatefulWidget {
  @override
  _DemoWidgetState createState() => _DemoWidgetState();
}

class _DemoWidgetState extends State<DemoWidget> {
  @override
  Widget build(BuildContext context) {
    var _demoText = "zzz";

    getFromServer() async {
      setState(() {
        _demoText = 'fdsafdsaf';
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("DemoWidgetPage"),
      ),
      body: Column(
        children: <Widget>[
          FloatingActionButton(onPressed: getFromServer, child: Text("GetFromServer")),
          Container(
            width: 200,
            height: 200,
            color: Colors.green,
            child: Text(_demoText ?? 'dddd'),
          ),
        ],
      ),
    );
  }
}