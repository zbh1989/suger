import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

import 'selectText.dart';

class TikTokHeader extends StatefulWidget {
  final Function onSearch;
  const TikTokHeader({
    Key key,
    this.onSearch,
  }) : super(key: key);

  @override
  _TikTokHeaderState createState() => _TikTokHeaderState();
}

class _TikTokHeaderState extends State<TikTokHeader> {
  int currentSelect = 1;
  @override
  Widget build(BuildContext context) {
    List<String> list = ['解锁','推荐', '热门','博主'];
    List<Widget> headList = [];
    for (var i = 0; i < list.length; i++) {
      headList.add(Expanded(
        child: GestureDetector(
          child: Container(
            margin: EdgeInsets.only(top: 14),
            color: Colors.black.withOpacity(0),
            child: Text(list[i],textAlign: TextAlign.center,
              style: i == currentSelect ? TextStyle(fontSize: 18,fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF)) : TextStyle(fontSize: 18,fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Bold',color: Color(0x80FFFFFF)),
            ),
          ),
          onTap: () {
            setState(() {
              currentSelect = i;
            });
          },
        ),
      ));
    }
    Widget headSwitch = Row(
      children: headList,
    );
    return Container(
      // color: Colors.green,
      padding: EdgeInsets.symmetric(horizontal: 15,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Tapped(
              child: Container(
                color: Colors.black.withOpacity(0),
                margin: EdgeInsets.only(bottom: 3),
                alignment: Alignment.bottomLeft,
                child: Image.asset('lib/assets/images/upload_video.png',width: 24,height: 24,),
              ),
              onTap: (){},
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black.withOpacity(0),
              alignment: Alignment.center,
              child: headSwitch,
            ),
          ),
          Expanded(
            child: Tapped(
              child: Container(
                color: Colors.black.withOpacity(0),
                padding: EdgeInsets.all(4),
                alignment: Alignment.centerRight,
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
