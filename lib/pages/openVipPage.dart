import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/tiktokTabBar.dart';
import '../views/vipCardItem.dart';
import 'homePage.dart';

/**
 * VIP 会员选择开通 页面
 */
class OpenVipPage extends StatefulWidget{
  @override
  OpenVipPageState createState() => OpenVipPageState();

}

class OpenVipPageState extends State<OpenVipPage>{

  List<Map<String,dynamic>> vipCardDataList;

  @override
  void initState(){
    super.initState();
    vipCardDataList = [
      {
        'name':'三日体验卡',
        'money': 19,
        'originalPrice': 39.9,
        'cardUrl':'lib/assets/images/vip/three_day_vip.png',
        'color':Color(0xFF46454D),
      },
      {
        'name':'周卡会员',
        'money': 50,
        'originalPrice': 72,
        'cardUrl':'lib/assets/images/vip/week_vip.png',
        'color':Color(0xFF6B76B9),
      },
      {
        'name':'月卡会员',
        'money': 88,
        'originalPrice': 168,
        'cardUrl':'lib/assets/images/vip/month_vip.png',
        'color':Color(0xFF46454D),
      },
      {
        'name':'季卡会员',
        'money': 100,
        'originalPrice': 300,
        'cardUrl':'lib/assets/images/vip/season_vip.png',
        'color':Color(0xFF8F6536),
      },
      {
        'name':'年卡会员',
        'money': 288,
        'originalPrice': 1098,
        'cardUrl':'lib/assets/images/vip/year_vip.png',
        'color':Color(0xFF51419A),
      },
      {
        'name':'至尊永久',
        'money': 398,
        'originalPrice': 1399,
        'cardUrl':'lib/assets/images/vip/superior_vip.png',
        'color':Color(0xFFFFD96B),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget header = Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(builder: (context) => HomePage(type:TikTokPageTag.shortVideo),),
                    (route) => route == null,
              );
            },
            child: Icon(Icons.chevron_left_outlined,),
          ),
          Expanded(child: Center(child:Text('金币明细',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),))
        ],
      ),
    );

    List<Widget> list = [];
    list.add(SizedBox(height: 24.5,));

    vipCardDataList.forEach((ele) {
      list.add(VipCardItem(cardInfo: ele,));
      list.add(SizedBox(height: 25,));
    });


    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          height: 30,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0x001A0258),
                Color(0xFF3D0363),
              ],
            ),
          ),
        ),
        preferredSize:  Size(MediaQuery.of(context).size.width, 45),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return list[index];
        },
      ),
    );
  }

}