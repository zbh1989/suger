import 'package:flutter/material.dart';

/**
 * 自定义弹出框
 */
class BottomDialogUtil {

  BottomDialogUtil(
    {
      this.content,
      this.backgroundColor: Colors.transparent,
      this.isDismissible: true,
      this.isScrollControlled: true,
      this.context,
    }
  );

  // 弹窗内容
  final Widget content;

  //背景颜色
  final Color backgroundColor;

  //能够点击消失
  final bool isDismissible;

  //能否拖动消失
  final bool isScrollControlled;

  final BuildContext context;


  Future<int> build() {
    return showModalBottomSheet(
      //showModalBottomSheet函数底部面板相当于一个新的页面
      backgroundColor: Colors.transparent,
      //颜色空白
      isDismissible: true,
      //能否点击消失
      isScrollControlled: true,
      //能否拖动消失
      context: context,
      //接受cotext
      builder: (context) {
        return content;
      },
    );
  }


}