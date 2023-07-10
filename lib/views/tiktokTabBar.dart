
import 'package:caihong_app/style/style.dart';
import 'package:caihong_app/views/selectText.dart';
import 'package:flutter/material.dart';

import 'bottomText.dart';

enum TikTokPageTag {
  //首页
  firstPage,
  //短视频
  shortVideo,
  //专题
  topic,
  //发现
  find,
  //我的
  me,
}

class TikTokTabBar extends StatelessWidget {
  final Function(TikTokPageTag) onTabSwitch;

  final bool hasBackground;
  final TikTokPageTag current;

  const TikTokTabBar({
    Key key,
    this.onTabSwitch,
    this.current,
    this.hasBackground: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    Widget row = Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            child: BottomText(
              isSelect: current == TikTokPageTag.firstPage,
              tag: TikTokPageTag.firstPage,
            ),
            onTap: () => onTabSwitch?.call(TikTokPageTag.firstPage),
          ),
        ),
        Expanded(
          child: GestureDetector(
            child: BottomText(
              isSelect: current == TikTokPageTag.shortVideo,
              tag: TikTokPageTag.shortVideo,
            ),
            onTap: () => onTabSwitch?.call(TikTokPageTag.shortVideo),
          ),
        ),
        Expanded(
          child: GestureDetector(
            child: BottomText(
              isSelect: current == TikTokPageTag.topic,
              tag: TikTokPageTag.topic,
            ),
            onTap: () => onTabSwitch?.call(TikTokPageTag.topic),
          ),
        ),
        /*Expanded(
          child: GestureDetector(
            child: BottomText(
              isSelect: current == TikTokPageTag.find,
              tag: TikTokPageTag.find,
            ),
            onTap: () => onTabSwitch?.call(TikTokPageTag.find),
          ),
        ),*/
        Expanded(
          child: GestureDetector(
            child: BottomText(
              isSelect: current == TikTokPageTag.me,
              tag: TikTokPageTag.me,
            ),
            onTap: () => onTabSwitch?.call(TikTokPageTag.me),
          ),
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        color: hasBackground ? Color(0xFF060123) : ColorPlate.back2.withOpacity(0),
        /*border: Border(
          top: BorderSide(width: 1.0, color: Color(0xEC9308B4)),
        ),*///        Border.all(/*color: Color(0xF4F3B608),*/width:0.2),
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: padding.bottom),
        height: 52 + padding.bottom,
        child: row,
      ),
    );
  }
}
