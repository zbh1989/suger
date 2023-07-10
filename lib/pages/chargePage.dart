import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/charge_presenter.dart';
import '../utils/PreferenceUtils.dart';
import '../utils/bottomDialogUtil.dart';
import '../utils/dialogUtil.dart';
import '../views/chargeGoldPage.dart';
import '../views/goldChargeSelect.dart';


/**
 * 充值页面
 * 布局页面
 */
class ChargePage extends StatefulWidget{

  @override
  ChargePageState createState() => ChargePageState();

}

class ChargePageState extends BaseState<ChargePage,ChargePresenter> with WidgetsBindingObserver{

  int money;
  int gold;
  int extraGold;

  int balance = 0;

  /// 是否已经触发过支付
  bool isPay = false;
  /// 支付订单号
  String orderNo;

  List goldList = [];

  //自定义 RefreshIndicatorState 类型的 Key
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();


  void setOrderNo(orderNo) => this.orderNo = orderNo;

  @override
  void initState(){
    mPresenter.queryGoldList();
    //必须在组件挂载运行的第一帧后执行，否则 _refreshKey 还没有与组件状态关联起来
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //关键代码，直接触发下拉刷新
      _refreshKey.currentState?.show();
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    refreshPage();
  }


  void refreshGoldList(List list) async {
    if(list != null && list.length > 0 && mounted){
      setState(() {
        goldList.addAll(list);
      });
    }
  }

  void refreshPage() async {
    PreferenceUtils.instance.getInteger("cronNum").then((val){
      if(mounted){
        setState(() {
          balance = val;
        });
      }
    });
  }

  Future<void> refreshData() async{
    mPresenter.refreshAllData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("-didChangeAppLifecycleState-" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        /// 支付之后刷新页面数据
        if(isPay){
          /// 查询订单金额
          mPresenter.queryOrderInfo(orderNo);
          showDialogFunction();
        }
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
          Text('我的钱包',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          /*GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>GoldChargeHisPage()));
            },
            child: Icon(Icons.wallet_rounded),
          ),*/
          Container(),
        ],
      ),
    );
    list.add(header);

    // 我的余额
    double yuEBoxWidth = width - 40;
    double yuEBoxHeight = (width + 40) * 110 / 335;
    Widget yuE = Container(
      width: yuEBoxWidth,
      height: yuEBoxHeight,
      margin: EdgeInsets.only(top: 12,left: 20,right: 20),
      padding: EdgeInsets.only(left: 18,bottom: 28*yuEBoxHeight/110,top: 20*yuEBoxHeight/110),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF64EF9),
            Color(0xFF6D14B2),
          ],
          stops: [0.1, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('金币余额',style: TextStyle(fontFamily: 'PingFang SC-Medium',fontSize: 16,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          SizedBox(height: 14,),
          Text('$balance',style: TextStyle(fontFamily: 'DIN-Bold',fontSize: 32,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w700),),
        ],
      ),
    );

    Widget stackWidget = Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 12,left: 20,right: 20),
          height: yuEBoxHeight + 20,
          width: yuEBoxWidth,
        ),
        yuE,
        Positioned(
          right: 25,
          bottom: 0,
          child: Image.asset('lib/assets/images/charge_gold.png',width: 111,height: 101,)
        ),
      ],
    );
    list.add(stackWidget);

    //选择充值金币选项
    Widget goldSelectTextWidget = Container(
      margin: EdgeInsets.only(left: 20,top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('选择充值金额',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          Text('本APP有稳定的广告收益，安全无毒，可放心使用。',style: TextStyle(fontFamily: 'PingFang SC-Medium',fontSize: 12,color: Color(0x80FFFFFF),fontWeight: FontWeight.w400),)
        ],
      ),
    );
    list.add(goldSelectTextWidget);

    //充值选项
    Widget goldSelectWidget = GoldChargeSelect(dataList:goldList ,setSelectMoney: (map){
      money = map['money'];
      gold = map['gold'];
      extraGold = map['extraGold'];
    },);
    list.add(goldSelectWidget);

    // 立即购买按钮
    Widget buyBtn = Container(
      height: 44,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20,right: 20,top: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC560E7),
            Color(0xFFD93B9F),
          ],
          stops: [0.1, 1.0],
        ),
      ),
      child: Text('立即购买',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
    );

    list.add(GestureDetector(
      onTap: (){
        print('充值金额 $money, 金币 $gold , 赠送金币 $extraGold');
        if(money == null){
          mPresenter.view.showToast('请选择充值项');
        }else{
          // mPresenter.view.showToast('充值金额 $money, 金币 $gold , 赠送金币 $extraGold');

          // showDialogFunction();
          /// 生成订单号
          DateTime currentTime = DateTime.now();
          int timeMills = currentTime.microsecondsSinceEpoch;
          String orderNo = timeMills.toString() + Random().nextInt(1000).toString();
          this.orderNo = orderNo;

          showBottomFunction(orderNo) ;

        }
      },
      child: buyBtn,
    ));


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
      body: RefreshIndicator(
        key: _refreshKey,    //自定义 key，需要通过 key 获取到对应的 State
        onRefresh: refreshData,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return list[index];
          },
        ),
      ),
    );
  }

  @override
  ChargePresenter createPresenter() {
    return ChargePresenter();
  }


  /**
   * 底部弹窗支付
   */
  Future<int> showBottomFunction(String orderNo) async {
    BottomDialogUtil btm = BottomDialogUtil(
      context: context,
      content: ChargeGoldPage(money: money,gold: gold,extraGold: extraGold,orderNo: orderNo,setPaymentOperation: (val){
        isPay = val;
      },),
    );
    return btm.build();
  }



  /**
   * 支付确认弹窗
   */
  void showDialogFunction() async {

    List<String> list = [];
    list.add('1.支付成功后，一般在1-10分钟内到账，如果超时未到账，请联系在线客服为您处理。');
    list.add('2.受特殊行业限制，如支付失败可尝试重新发起订单，系统将会自动切换备用的支付通道。');
    list.add('3.本APP有稳定的广告收益产品稳定安全，可放心充值使用。');

    bool isSelect = await showDialog<bool>(
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
                child: Text('订单支付确认',style: TextStyle(fontSize: 18,color: Color(0xFF000000),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
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
                          mPresenter.queryOrderInfo(orderNo);
                          Navigator.of(context).pop();
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
                          mPresenter.queryOrderInfo(orderNo);
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
            mPresenter.queryOrderInfo(orderNo);
            Navigator.of(context).pop();
          },
        );

      },
    );

    print("弹框关闭 $isSelect");
  }












}