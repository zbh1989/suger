import 'dart:math';

import 'package:caihong_app/utils/toast.dart';
import 'package:flutter/material.dart';

/**
 * 自定义弹出框
 */
class DialogUtil extends Dialog {

  DialogUtil({this.content,this.onClose,this.marginTop: 120,});

  final Widget content;

  final double marginTop;

  Function onClose;

  @override
  Widget build(BuildContext context) {
    // Toast.show('弹窗高度：' + (marginTop - 53).toString());
    return Container(
      margin: EdgeInsets.only(top: max(marginTop - 53,130)),
      child: Column(
        children: [
          content,
          GestureDetector(
            onTap: (){
              onClose();
            },
            child: Container(
              margin: EdgeInsets.only(top: 18),
              child: Image.asset('lib/assets/images/cancel.png',width: 35,height: 35,),
            ),
          ),
        ],
      ),
    );
  }

  /// 看视频提示弹窗
  Widget buildPlayerDialog(BuildContext context){
    showDialog(
      barrierDismissible: true, //点击空白是否退出
      context: context,
      builder: (context) {
        return AlertDialog(
          // titlePadding: EdgeInsets.all(10),
          elevation: 10,
          backgroundColor: Colors.pink, //背景颜色

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), //设置形状

          title: const Text('提示'),
          // icon: Icon(Icons.work_rounded),
          content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('升级VIP 观看完整视频'),
          ),
          contentTextStyle: const TextStyle(
              color: Colors.black), //文本内容的text样式
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('确定')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消')),
            ),
          ],
        );
      }
    );
  }


}