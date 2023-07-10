
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/buyVipPage.dart';

/**
 * VIP 卡片
 */
class VipCardItem extends StatelessWidget {

  VipCardItem({this.cardInfo,this.times : 1});

  final Map<String,dynamic> cardInfo;

  final double times;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double imgWidth = size.width - 56;
    double imgHeight = imgWidth * 152/319;

    Widget stack = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12*times),
          ),
          width: imgWidth,
          height: imgHeight,
          margin: EdgeInsets.only(left: 28,right: 28,),
        ),
        Positioned(
          left: 28,
          top: 0,
          child: Image.asset(cardInfo['cardUrl'],height: imgHeight,width: imgWidth,),
        ),
        Positioned(
          left: 52.5,
          top: 78,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(text: '￥',style: TextStyle(fontFamily:'PingFang SC-Medium',color: cardInfo['color'],fontSize: 16,fontWeight: FontWeight.w400),),
                      TextSpan(text: cardInfo['money'].toString(),style: TextStyle(fontFamily:'Swis721 BlkCn BT-Black',color: cardInfo['color'],fontSize: 36,fontWeight: FontWeight.bold),),
                      TextSpan(text: '  原价:',style: TextStyle(fontFamily:'PingFang SC-Medium',color: cardInfo['color'],fontSize: 10,fontWeight: FontWeight.w400),),
                      TextSpan(text: '￥'+ cardInfo['originalPrice'].toString(),style: TextStyle(fontFamily:'PingFang SC-Medium',color: cardInfo['color'],fontSize: 10,fontWeight: FontWeight.w400,decoration: TextDecoration.lineThrough,decorationStyle: TextDecorationStyle.solid,decorationColor: cardInfo['color']),),
                    ]
                ),
                textDirection: TextDirection.ltr,
              ),

              Text('优惠价',style:TextStyle(fontFamily:'PingFang SC-Medium',color: cardInfo['color'],fontSize: 14,fontWeight: FontWeight.w400),),
            ],
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx)=>BuyVipPage(cardInfo:cardInfo),),
        );
      },
      child: stack,
    );

  }

}