import 'package:caihong_app/pages/buyVipPage.dart';
import 'package:flutter/material.dart';

import '../pages/openVipPage.dart';

/**
 * 开通 VIP 弹窗
 */
class OpenVipDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double imgWidth = width - 55;
    double imgHeight = imgWidth * 410 / 348;

    Widget body = Stack(
      children: [
        Container(
          width: imgWidth,
          height: imgHeight,
        ),
        Positioned(
          left: (width - 40 - imgWidth * 0.8)/2,
          bottom:0,
          child: Image.asset('lib/assets/images/vip_dialog_img.png',width: imgWidth*0.8,height: imgHeight*0.8,fit: BoxFit.cover,),
        ),
        Positioned(
          left: (imgWidth - imgWidth * 0.45)/2,
          top: (imgHeight*0.8 - 40)/2 -20,
          child: Column(
            mainAxisAlignment:MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width:imgWidth * 0.45,
                height: 40,
                child: Text('充值VIP，观看完整视频邀请好友，领取免费VIP',textAlign: TextAlign.right,maxLines:2,softWrap: true,style: TextStyle(fontSize: 13,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFF7E3B0C),decoration: TextDecoration.none,),),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: Text('颜射视频',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFF7E3B0C),decoration: TextDecoration.none,),),
              ),
            ],
          ),
        ),
        Positioned(
          left: (imgWidth - 126)/2,
          bottom:35,
          child: GestureDetector(
            onTap: (){
              // 跳转到VIP 充值页面
              Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(builder: (context) => BuyVipPage()),
                    (route) => route == null,
              );

            },
            child: Container(
              width: 126,
              padding: EdgeInsets.symmetric(horizontal: 32,vertical: 6,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFCDEC2),
                    Color(0xFFFDC223),
                  ],
                  stops: [0.0, 0.8],
                ),
              ),
              child:Text('开通会员',style: TextStyle(fontSize: 15,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFF7E3B0C),decoration: TextDecoration.none,),),
            ),
          ),
        ),
      ],
    );

    /*showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogUtil(
          marginTop: (size.height + ei.top + ei.bottom - imgHeight)/2 + 30,
          content: Container(
            width: imgWidth,
            height: imgHeight - 65,
            decoration: BoxDecoration(
              // color: Colors.red,
              borderRadius: BorderRadius.circular(22),
            ),
            child: body,
          ),
          onClose: (){Navigator.of(context).pop();},
        );
      },
    );*/

    return Container(
      width: imgWidth,
      height: imgHeight - 65,
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.circular(22),
      ),
      child: body,
    );

  }

}