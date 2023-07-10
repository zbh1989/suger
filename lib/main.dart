import 'dart:async';
import 'dart:io';

import 'package:caihong_app/pages/homePage.dart';
import 'package:caihong_app/pages/openVipPage.dart';
import 'package:caihong_app/pages/shortVideoPage.dart';
import 'package:caihong_app/pages/swiperPage.dart';
import 'package:caihong_app/presenter/splashScreenPresenter.dart';
import 'package:caihong_app/style/style.dart';
import 'package:caihong_app/views/openVipDialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'base/view/base_state.dart';

void main() {
  /// 自定义报错页面
  if (kReleaseMode) {
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      debugPrint(flutterErrorDetails.toString());
      return Material(
        child: Center(
            child: Text(
          "发生了没有处理的错误\n请通知开发者",
          textAlign: TextAlign.center,
        )),
      );
    };
  }
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,//这里替换你选择的颜色
    ),
  );


  /*if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }*/
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '彩虹视频',
      // color: Color(0xF703165E), // 0xF7050D2C
      theme: ThemeData(
        brightness: Brightness.dark,
        hintColor: Colors.white,
        accentColor: Colors.white,
        primaryColor: ColorPlate.orange,
        primaryColorBrightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF060123),//ColorPlate.back1,
        dialogBackgroundColor: ColorPlate.back2,
        accentColorBrightness: Brightness.light,
        textTheme: TextTheme(
          bodyText1: StandardTextStyle.normal,
        ),
      ),
      routes: {
        '/homePage': (ctx) => HomePage(),
        '/shortVideo':(ctx) => ShortVideoPage(),
        '/openVipDialog':(ctx) => OpenVipDialog(),
        '/openVipPage':(ctx) => OpenVipPage(),
      },
      home: SplashScreen(),
      // home:HomePage(isLoaded: true,)
    );
  }
}

/**
 * 启动后广告加载
 */
class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends BaseState<SplashScreen,SplashScreenPresenter> {
  Timer _timer;

  List dataList = [];

  String advoceMsg;

  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 5);
    _timer = new Timer(_duration, navigationPage);
    return _timer;
  }

  void navigationPage() {
    _timer.cancel();
    Map param = Map();
    param['isLoaded'] = true;
    param['advoceMsg'] = advoceMsg;
    Navigator.of(context).pushReplacementNamed('/homePage',arguments: param);
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {

    /// 启动页信息
    mPresenter.getAppStartPageInfo();

    /// 自动注册登录
    mPresenter.autoLogin();

    /// APP 配置信息
    mPresenter.getAppConfig();

    /// 公告信息
    mPresenter.getAdvoceMsg();

  }

  void refreshPage(List imgList,String msg){
    if(imgList != null){
      setState(() {
        dataList.addAll(imgList);
        startTime();
      });
    }

    if(msg != null){
      setState(() {
        advoceMsg = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container();
    if(dataList != null && dataList.length > 0){
      body = ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          child: SwiperPage(imgList:dataList,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,needFullScreen: true,),
        ),
      );
    }
    return new Scaffold(
      body: body,
    );
  }

  @override
  SplashScreenPresenter createPresenter() {
    return SplashScreenPresenter();
  }
}
