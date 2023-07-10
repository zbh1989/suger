import 'package:caihong_app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../base/view/base_state.dart';
import '../presenter/chargeGoldPagePresenter.dart';
import '../presenter/chargeVipPagePresenter.dart';

class ChargeVipPage extends StatefulWidget {

  ChargeVipPage({this.money,this.setPaymentOperation,this.orderNo,});

  final int money;
  final String orderNo;

  ValueChanged setPaymentOperation;

  @override
  ChargeVipPageState createState() => ChargeVipPageState();

}

class ChargeVipPageState extends BaseState<ChargeVipPage,ChargeVipPagePresenter>{

  int chooseItem; // 1: 支付宝，2: 微信

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height*0.82,
      color: Color(0xFF200E37),
      padding: EdgeInsets.only(left: 25,right: 35,top: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('lib/assets/images/pay_icon.png',width: 24,height: 24,),
              Text('订单支付',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Text('X',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
              ),
            ],
          ),


          PaymentChoose(choosePayType:(choose){
            chooseItem = choose;
          }),

          Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('支付小贴士',style:TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF))),
                SizedBox(height: 10,),
                Text('1.支付前请先绑定手机号，避免重新安装后账户损失！',style:TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF))),
                Text('2.点击“立即支付”后请尽快完成支付，超时支付无法到账，需要重新支付。',style:TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF))),
                Text('3.如果出现任何风险提示请不必担心，重新支付一次即可，并不会重复付款。',style:TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF))),
                Text('4.如果您使用了优惠券下单并为支付成功，优惠券将于2小时后返还账户。',style:TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF))),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('总计￥'+ widget.money.toString() +'',style:TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Heavy',fontWeight: FontWeight.w400,color: Color(0xFFAC5AFF))),

                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                    // Toast.show('选择' + (chooseItem == 1 ? '支付宝' : '微信' ) + '支付金额' + widget.money.toString());
                    mPresenter.createOrder(chooseItem,widget.money,widget.orderNo);
                    widget.setPaymentOperation(true);
                  },
                  child: Container(
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
                      child: Text('立即支付',style: TextStyle(fontSize: 16,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
                    ),
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }


  /**
   * 打开网页地址
   */
  void launchUrl(String url) async {
    canLaunch(url).then((canOpen){
      if(canOpen){
        launch(url);
      }else{
        Toast.show('无法打开网页地址: $url');
      }
    });
  }

  @override
  ChargeVipPagePresenter createPresenter() {
    return ChargeVipPagePresenter();
  }

}

class PaymentChoose extends StatefulWidget {

  PaymentChoose({this.choosePayType});

  ValueChanged choosePayType;

  @override
  PaymentChooseState createState() => PaymentChooseState();
}

class PaymentChooseState extends State<PaymentChoose> {

  int chooseItem = 1; // 1: 支付宝，2: 微信

  @override
  void initState() {
    super.initState();
    widget.choosePayType(chooseItem);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              if(chooseItem == 1){
                return ;
              }
              setState(() {
                chooseItem = 1;
                widget.choosePayType(chooseItem);
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 26),
              width: size.width,
              child: Row(
                children: [
                  Image.asset('lib/assets/images/alipay.png',width: 30,height: 30,),
                  SizedBox(width: 16,),
                  Expanded(child: Text('支付宝（推荐使用）',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),),
                  chooseItem == 1 ?
                  Image.asset('lib/assets/images/checked.png',width: 20,height: 20,) :
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Color(0xFFAC5AFF)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 15),
            child: Divider(height: 1.0,indent: 0.0,color: Color(0xFF3A067E),),
          ),

          GestureDetector(
            onTap: (){
              if(chooseItem == 2){
                return ;
              }
              setState(() {
                chooseItem = 2;
                widget.choosePayType(chooseItem);
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 16),
              width: size.width,
              child: Row(
                children: [
                  Image.asset('lib/assets/images/wechat_pay.png',width: 30,height: 30,),
                  SizedBox(width: 16,),
                  Expanded(child: Text('微信（官方风控易失败）',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),),
                  chooseItem == 2 ?
                  Image.asset('lib/assets/images/checked.png',width: 20,height: 20,) :
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Color(0xFFAC5AFF)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 15),
            child: Divider(height: 1.0,indent: 0.0,color: Color(0xFF3A067E),),
          ),
        ],
      ),
    );
  }

}