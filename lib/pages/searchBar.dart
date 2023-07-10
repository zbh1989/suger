import 'package:caihong_app/extension/deviceUnit.dart';
import 'package:caihong_app/pages/searchPage.dart';
import 'package:caihong_app/pages/signPage.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';
import 'package:caihong_app/style/style.dart';

import 'chargePage.dart';

class SearchBar extends StatefulWidget {
  final Function onPop;

  const SearchBar({
    Key key,
    this.onPop,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 4.0),
      width: double.infinity,
      alignment: Alignment.center,
      color: Color(0xFF060123),
      child: Container(
        // padding: const EdgeInsets.only( left: 20,top:5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (cxt) => SearchPage(),
                      )
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0x33FFFFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // padding: EdgeInsets.only(left: 16),
                  child: Opacity(
                    opacity: 0.3,
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 16,top: 10,bottom: 10),
                          child: Image.asset('lib/assets/images/search.png',width: 20,height: 20,),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 4,top: 10,bottom: 10),
                          // padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                          child: Text(
                            '请输入你要搜索的内容',
                            style: TextStyle(fontSize: 13,color: Color(0x80FFFFFF),fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Medium',),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 21,top: 4),
                // padding: EdgeInsets.all(2),
                child: Image.asset('lib/assets/images/recharge.png',width: 40,height: 40,),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (cxt) => ChargePage(),
                  )
                );
              },
            ),
            GestureDetector(
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 8),
                // padding: EdgeInsets.all(2),
                child: Image.asset('lib/assets/images/sign.png',width: 40,height: 40,),
              ),
              onTap: () {
                // Navigator.pop(context);
                print('会员签到页面');
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (cxt) => SignPage(),
                    )
                );
              },
            ),


          ],
        ),
      ),
    );
  }
}