import 'package:caihong_app/pages/buyVipPage.dart';
import 'package:flutter/material.dart';

import '../pages/openVipPage.dart';

/**
 * 开通 VIP 弹窗
 */
class OpenNewVipDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double imgWidth = width - 65;
    double imgHeight = imgWidth * 151.5 / 285;

    Widget body = Column(
      children: [

        Container(
          width: imgWidth*0.8,
          height: imgHeight*0.8,
         /* decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(22),topRight: Radius.circular(22)),
          ),*/
          child: Image.asset('lib/assets/images/vip/open_vip_bcg.png',width: imgWidth*0.8,height: imgHeight*0.8,fit: BoxFit.cover,),
        ),

        Container(
          width: imgWidth*0.8,
          height: 30,
          margin:EdgeInsets.only(top: 16,),
          child: Center(child: Text('观看完整视频需开通会员',style: TextStyle(color:Color(0xFF000000),fontSize: 18,fontWeight: FontWeight.bold,decoration: TextDecoration.none,),),),
        ),

        Container(
          width: imgWidth*0.8,
          height: 30,
          margin:EdgeInsets.only(top: 4,),
          child: Center(child: Text('您的VIP会员已过期',style: TextStyle(color:Color(0x80000000),fontSize: 14,fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),),
        ),

        Container(
          width: imgWidth*0.8,
          height: 80,
          margin:EdgeInsets.only(top: 12,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Image.asset('lib/assets/images/vip/open_vip_kefu.png',width: 45,height: 45,fit: BoxFit.cover,),
                    SizedBox(height: 6,),
                    Text('专属客服',style: TextStyle(color:Color(0xFF211D38),fontSize: 13,fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
                  ],
                ),
              ),

              Container(
                child: Column(
                  children: [
                    Image.asset('lib/assets/images/vip/open_vip_video.png',width: 45,height: 45,fit: BoxFit.cover,),
                    SizedBox(height: 6,),
                    Text('畅享VIP视频',style: TextStyle(color:Color(0xFF211D38),fontSize: 13,fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
                  ],
                ),
              ),

              Container(
                child: Column(
                  children: [
                    Image.asset('lib/assets/images/vip/open_vip_switch.png',width: 45,height: 45,fit: BoxFit.cover,),
                    SizedBox(height: 6,),
                    Text('线路切换',style: TextStyle(color:Color(0xFF211D38),fontSize: 13,fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          width: imgWidth*0.8,
          height: 20,
          margin:EdgeInsets.only(top: 6,bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Text('狠心离开',style: TextStyle(color:Color(0xFF211D38),fontSize: 16,fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      fullscreenDialog: false,
                      builder: (context){
                        return BuyVipPage();
                      }
                  ));
                },
                child: Text('立即开通',style: TextStyle(color:Color(0xFFBF790A),fontSize: 16,fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
              )
            ],
          ),
        )
      ],
    );



    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0C7F9),
            Color(0xFFFFFFFF),
          ],
          stops: [0.0, 0.3],
        ),
      ),

      child: body,
    );

  }

}