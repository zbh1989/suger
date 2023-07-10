import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ViewPage(),
    );
  }
}

class ViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  var imgList = [
    // 'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
    'https://p5.itc.cn/images01/20230425/9a56bbb130db419dbc34fce5b841b848.jpeg'
  ];
  PageController _pageController;

  var _currPageValue = 0.0;

  //缩放系数
  double _scaleFactor = 0.5;

  //view page height
  double _height = 230.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _pageController.addListener(() {
      setState(() {
        _currPageValue = _pageController.page;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        height: _height,
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => _buildPageItem(index),
          itemCount: 2,
          controller: _pageController,
          onPageChanged: (currentPage){
            print('当前页面 = $currentPage');
          },
        ));
  }

  _buildPageItem(int index) {
    Matrix4 matrix4 = Matrix4.identity();
    print('当前 index = $index, _currPageValue = $_currPageValue');
    if (index == _currPageValue.floor()) {
      //当前的item
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;

      matrix4 = Matrix4.diagonal3Values(1.0, currScale, 1.0)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else if (index == _currPageValue.floor() + 1) {
      //右边的item
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;

      matrix4 = Matrix4.diagonal3Values(1.0, currScale, 1.0)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else if (index == _currPageValue.floor() - 1) {
      //左边
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;

      matrix4 = Matrix4.diagonal3Values(1.0, currScale, 1.0)
        ..setTranslationRaw(0.0, currTrans, 0.0);
    } else {
      //其他，不在屏幕显示的item
      matrix4 = Matrix4.diagonal3Values(1.0, _scaleFactor, 1.0)
        ..setTranslationRaw(0.0, _height * (1 - _scaleFactor) / 2, 0.0);
    }

    return Transform(
      transform: matrix4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
                image: NetworkImage(imgList[index % 1]), fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}