import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {

  TimerWidget({this.sec});

  final int sec;

  @override
  TimerState createState() => TimerState();

}

class TimerState extends State<TimerWidget>{

  Timer _timer;

  int currentTime;


  void start(int time){
    if(_timer != null && _timer.isActive){
      _timer.cancel();
      _timer = null;
    }

    if(time < 0){
      return ;
    }

    int countTime = time;
    const repeatPeriod = const Duration(seconds:1);
    _timer = Timer.periodic(repeatPeriod, (timer) {
      if(countTime <= 0){
        _timer.cancel();
        _timer = null;
        return ;
      }
      countTime--;
      setState(() {
        currentTime = countTime;
      });
    });


  }

  @override
  void initState(){
    super.initState();
    start(widget.sec);
    currentTime = widget.sec;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 25,
      color: Colors.grey,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
      child: Text('倒计时 $currentTime 秒',style: TextStyle(fontSize: 12,color: Color(
          0xDFF3673D)),),
    );
  }

  @override
  void dispose(){
    super.dispose();
    if(_timer != null && _timer.isActive){
      _timer.cancel();
      _timer = null;
    }
  }

}