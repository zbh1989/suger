import 'package:caihong_app/pages/buyVipPage.dart';
import 'package:flutter/material.dart';

import '../pages/openVipPage.dart';
import '../utils/dialogUtil.dart';

/**
 * 扣除金币弹窗
 */
class UseGoldDialog extends StatelessWidget {

  UseGoldDialog({this.gold});

  final int gold;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double imgWidth = width - 35;
    double imgHeight = imgWidth * 468 / 348;

    Widget body = Container(
      child:Text('支付金币$gold 解锁视频'),
    );

    List<String> list = [];
    list.add('1.支付成功后，一般在1-10分钟内到账，如果超时未到账，请联系在线客服为您处理。');
    list.add('2.受特殊行业限制，如支付失败可尝试重新发起订单，系统将会自动切换备用的支付通道。');
    list.add('3.本APP有稳定的广告收益产品稳定安全，可放心充值使用。');

    showDialog<bool>(
      context: context,
      builder: (context) {

        Widget widget = Container(
          height: 295,
          width: 304,
          padding: EdgeInsets.symmetric(horizontal: 12.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF0C7F9),
                Color(0xFFFFFFFF),
              ],
              stops: [0.0, 0.3],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 18),
                alignment: Alignment.center,
                child: Text('金币解锁视频',style: TextStyle(fontSize: 18,color: Color(0xFF000000),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
              ),

              Container(
                margin: EdgeInsets.only(top: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(list[0],style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0xFF000000),decoration: TextDecoration.none),),
                    SizedBox(height: 18,),
                    Text(list[1],style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0xFF000000),decoration: TextDecoration.none),),
                    SizedBox(height: 18,),
                    Text(list[2],style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0xFF000000),decoration: TextDecoration.none),),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.5,vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2,color: Color(0xFFAC5AFF)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          /* mPresenter.queryOrderInfo(orderNo);
                          Navigator.of(context).pop();*/
                        },
                        child: Text('支付遇到问题',style: TextStyle(fontSize: 14,color: Color(0xFFAC5AFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.5,vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFC560E7),
                            Color(0xFFD93B9F),
                          ],
                          stops: [0.0, 0.8],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          // mPresenter.queryOrderInfo(orderNo);
                          Navigator.of(context).pop();
                        },
                        child: Text('支付成功',style: TextStyle(fontSize: 16,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        Size size = MediaQuery.of(context).size;
        EdgeInsets ei = MediaQuery.of(context).padding;

        return DialogUtil(
          marginTop: (size.height + ei.top + ei.bottom - 295)/2,
          content: widget,
          onClose: (){
            // mPresenter.queryOrderInfo(orderNo);
            Navigator.of(context).pop();
          },
        );

      },
    );


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