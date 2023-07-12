import 'package:caihong_app/pages/signHisPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/signPagePresenter.dart';
import '../utils/PreferenceUtils.dart';
import '../views/signItem.dart';


/**
 * 签到页面
 */
class SignPage extends StatefulWidget{

  @override
  SignPageState createState() => SignPageState();

}

class SignPageState extends BaseState<SignPage,SignPagePresenter>{

  /// 今日是否已签到
  bool isSign = false;

  /// 金币数
  int cronNum = 0;

  /// 观影券 （这两个先写死） tmpViewNum
  int watchTicket = 0;

  /// 优惠券 （这两个先写死）
  int discountTicket = 0;

  /// 连续签到天数
  int checkNum ;

  /// VIP 天数
  int endVipDateNum;


  @override
  void initState(){
    getSignData();
    super.initState();
  }

  void getSignData(){

    Future.wait([
      PreferenceUtils.instance.getInteger("cronNum").then((val){
        cronNum = val;
      }),
      PreferenceUtils.instance.getInteger("tmpViewNum").then((val){
        watchTicket = val;
      }),
      PreferenceUtils.instance.getInteger("discountTicket").then((val){
        discountTicket = val;
      }),

      PreferenceUtils.instance.getInteger("checkNum").then((val){
        checkNum = val;
      }),

      PreferenceUtils.instance.getInteger("endVipDateNum").then((val){
        endVipDateNum = val;
      }),

    ]).then((value){
      setState(() {
        
      });
    }).catchError((err){
      print('签到数据获取异常: $err');
    });
  }

  void sign(){
    mPresenter.doSign();
  }

  void refreshSignResult(){
    if(mounted){
      getSignData();
    }
  }


  @override
  Widget build(BuildContext context) {

    Size size  = MediaQuery.of(context).size;

    List<Widget> list = [];
    // 头部
    Widget header = Container(
      margin: EdgeInsets.only(top: 14,left: 14,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left_outlined),
          ),
          Text('签到',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          /*GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>SignHisPage()));
            },
            child: Image.asset('lib/assets/images/sign/his_icon.png',width: 19.6,height: 21.6,),
          ),*/
          Container(),
        ],
      ),
    );
    list.add(header);

    /// 头像 金币信息
    Widget headGoldInfo = Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20,top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              color: Colors.black,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: ClipOval(
                child:Image.asset('lib/assets/images/avator/001.webp',fit:BoxFit.cover,)
            ),
          ),

          Expanded(
            child: Container(
              width: 140,
              height: 50,
              margin: EdgeInsets.only(left: 12),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('已连续签到 $checkNum 天',style: TextStyle(fontSize: 15,fontWeight:FontWeight.w400,fontFamily: 'PingFang SC-Regular',color: Color(0xFFFFFFFF)),),
                  SizedBox(height: 10),
                  //Text('明日签到可获得观影券x2',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'PingFang SC-Regular',color: Color(0x80FFFFFF)),),
                  Text('签到可获得奖励',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'PingFang SC-Regular',color: Color(0x80FFFFFF)),),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(right: 20,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/sign/golden.png',width: 25,height: 25,),

                SizedBox(width: 5,),

                Text('$cronNum',style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold,fontFamily: 'DIN-Bold',color: Color(0xFFFFFFFF)),),
              ],
            ),
          ),

        ],
      ),
    );
    list.add(headGoldInfo);


    ///  金币   VIP 天数  观影券   优惠券
    Widget userGoods = Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 18.5,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 金币
          Column(
            children: [
              Text('$cronNum',style: TextStyle(fontSize: 15,fontFamily: 'DIN-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w500),),
              Text('金币',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',color: Color(0x80FFFFFF),fontWeight: FontWeight.w400),),
            ],
          ),
          /// VIP 天数
          Column(
            children: [
              Text('$endVipDateNum',style: TextStyle(fontSize: 15,fontFamily: 'DIN-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w500),),
              Text('VIP天数',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',color: Color(0x80FFFFFF),fontWeight: FontWeight.w400),),
            ],
          ),
          /// 观影券
          Column(
            children: [
              Text('$watchTicket',style: TextStyle(fontSize: 15,fontFamily: 'DIN-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w500),),
              Text('观影券',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',color: Color(0x80FFFFFF),fontWeight: FontWeight.w400),),
            ],
          ),
          /// 优惠券
          Column(
            children: [
              Text('0',style: TextStyle(fontSize: 15,fontFamily: 'DIN-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w500),),
              Text('优惠券',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',color: Color(0x80FFFFFF),fontWeight: FontWeight.w400),),
            ],
          ),
        ],
      ),
    );
    list.add(userGoods);

    Widget mySign = Container(
      width: size.width - 40,
      margin: EdgeInsets.only(top: 18,left: 20,right: 20,bottom: 20),
      padding: EdgeInsets.only(top: 18,bottom: 20,left: 16,right: 16),
      decoration: BoxDecoration(
        color: Color(0xFF2E0169),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(width:0.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('我的签到',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
                  Text('开通会员领取双倍签到奖励～',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',color: Color(0x80FFFFFF),fontWeight: FontWeight.w400),),
                ],
              ),
              /// 立即签到按钮
              GestureDetector(
                onTap: (){
                  sign();
                },
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 23,right: 23,top: 10,  bottom: 10,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF64E7E),
                        Color(0xFFA40CF0),
                      ],
                      stops: [0.1, 1.0],
                    ),
                  ),
                  child: Text('立即签到',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
                ),
              )
            ],
          ),

          /// 签到表格选项
          Container(
            margin: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SignItem(topTxt: '第1天',middleIcon: 'lib/assets/images/sign/golden.png',bottomTxt: '金币*38',isSelect: (checkNum??0) >= 1 ? true : false,),

                SignItem(topTxt: '第2天',middleIcon: 'lib/assets/images/sign/watch_movie.png',bottomTxt: '观影券*2',isSelect: (checkNum??0) >= 2 ? true : false,),


                SignItem(topTxt: '第3天',middleIcon: 'lib/assets/images/sign/vip.png',bottomTxt: 'VIP*1天',isSelect: (checkNum??0) >= 3 ? true : false,),


                SignItem(topTxt: '第4天',middleIcon: 'lib/assets/images/sign/watch_movie.png',bottomTxt: '观影券*1',isSelect: (checkNum??0) >= 4 ? true : false,),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SignItem(topTxt: '第5天',middleIcon: 'lib/assets/images/sign/golden.png',bottomTxt: '金币*58',isSelect: (checkNum??0) >= 5 ? true : false,),
                SignItem(topTxt: '第6天',middleIcon: 'lib/assets/images/sign/watch_movie.png',bottomTxt: 'VIP*1天',isSelect: (checkNum??0) >= 6 ? true : false,),
                /// 第 7 天
                Container(
                  child: Stack(
                    children: [
                      Container(
                        width: size.width * 142 / 375 + 6,
                        height: (size.width * 142 / 375 + 6)*80/142,
                        decoration: BoxDecoration(
                          color: (checkNum??0) >= 7 ? Color(0xFF6205B3) : Color(0xFF3A067E),
                          image: DecorationImage(
                            image: AssetImage('lib/assets/images/sign/gift_package.png'),
                            fit: BoxFit.fill, // 完全填充
                          ),
                        ),
                      ),

                      ///   文字描述
                      Positioned(
                        left: 12,
                        top: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('第7天',style: TextStyle(fontSize: 11,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
                            Text('神秘大礼包',style: TextStyle(fontSize: 11,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
                          ],
                        ),
                      )


                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    list.add(mySign);

    /// 广告图
    Widget ad = Container(
      width: size.width - 40,
      height: (size.width - 40)*80/335,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/sign/ad_live.png'),
          fit: BoxFit.fill, // 完全填充
        ),
      ),
    );
    list.add(ad);

    Widget rule = Container(
      margin: EdgeInsets.only(top: 16),
      width: size.width - 40,
      padding: EdgeInsets.only(top: 18,left: 18,bottom: 21,right: 18,),
      decoration: BoxDecoration(
        color: Color(0xFF2E0169),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('签到规则',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          SizedBox(height: 18,),
          Text('1.每天可签到1次\n2.最多可以连续签到7天，获得7天签到礼包所有奖励\n3.签到中间不可漏签，否则从第1天重新签到\n4.签到奖励数量展示为普通用户，某些奖励项VIP可获得双倍奖励\n5.最终解释权归颜射视频所有',style: TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Regular',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
        ],
      ),
    );
    list.add(rule);


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
      body: Container(
        color: Color(0xFF060123),
        constraints: BoxConstraints(
          minWidth: size.width,
          minHeight: size.height,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: list,
          ),
        ),
      ),
    );
  }

  @override
  SignPagePresenter createPresenter() {
    return SignPagePresenter();
  }

}