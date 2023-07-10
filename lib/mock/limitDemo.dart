import 'package:flutter/material.dart';

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

class _SpreadWidgetState extends State<SpreadWidget>
    with TickerProviderStateMixin {
  bool offstage = true;
  bool zhankai = false;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = new Tween(begin: 0.0, end: 150.0).animate(controller)
      ..addListener(() {
        if (animation.status == AnimationStatus.dismissed &&
            animation.value == 0.0) {
          offstage = !offstage;
        }
        setState(() => {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 490,
      height: 100,
      child: Stack(
        children: [
          Positioned(
              top: 30,
              left: 20,
              child: Text(
                "展开/收起",
                style: TextStyle(fontSize: 20),
              )),
          Positioned(
            top: 70,
            left: ((animation?.value ?? 150.0) > 150 ? 150 : animation?.value),
            child: Offstage(
              offstage: offstage,
              child: Image.asset(
                "lib/assets/images/movie.png",
                width: 50,
                height: 50,
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: ((animation?.value ?? 100) > 100 ? 100 : animation?.value),
            child: Offstage(
              offstage: offstage,
              child: Image.asset(
                "lib/assets/images/movie.png",
                width: 50,
                height: 50,
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: ((animation?.value ?? 50.0) > 50 ? 50 : animation?.value),
            child: Offstage(
              offstage: offstage,
              child: Image.asset(
                "lib/assets/images/movie.png",
                width: 50,
                height: 50,
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  zhankai = !zhankai;
                  if (!zhankai) {
                    //展开
                    offstage = !offstage;
                    //启动动画(正向执行)
                    controller.forward();
                  } else {
                    controller.reverse();
                  }
                });
              },
              child: Image.asset(
                "lib/assets/images/movie.png",
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}