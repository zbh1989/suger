import 'dart:math';

import 'package:caihong_app/utils/toast.dart';
import 'package:flutter/material.dart';

/**
 * 自定义弹出框(底部不带关闭按钮)
 */
class AlertDialogUtil extends Dialog {

  AlertDialogUtil({this.content,this.marginTop: 120,});

  final Widget content;

  final double marginTop;

  @override
  Widget build(BuildContext context) {
    Toast.show('弹窗高度：' + (marginTop - 53).toString());
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            content,
          ],
        ),
      ),
    );
  }


}