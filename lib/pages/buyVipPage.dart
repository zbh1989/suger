import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/BuyVipPagePresenter.dart';

import '../utils/bottomDialogUtil.dart';
import '../views/VipCardPageView.dart';
import '../views/chargeGoldPage.dart';
import '../views/chargeVipPage.dart';
import '../views/vipCardItem.dart';
import 'myVipPage.dart';

/**
 * VIP 会员选择购买页面
 */
class BuyVipPage extends StatefulWidget{

  BuyVipPage({this.cardInfo});

  Map<String,dynamic> cardInfo;

  @override
  BuyVipPageState createState() => BuyVipPageState();

}

class BuyVipPageState extends BaseState<BuyVipPage,BuyVipPagePresenter> with WidgetsBindingObserver{

  Size size;
  double height = 0.0;

  int money = 0;

  bool isPay = false;

  String orderNo;

  List vipLevelList = [];

  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    mPresenter.queryVipLevelList();

  }

  void refreshData(List list){
    if(list != null){
      vipLevelList.clear();
      setState(() {
        vipLevelList.addAll(list);
      });
    }
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
          /// 跳转到我的会员
          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>MyVipPage()));
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
    size = MediaQuery.of(context).size;
    height = size.height;

    List<Widget> list = [];
    /// 头部
    Widget header = Container(
      margin: EdgeInsets.only(top: 14,left: 14,right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left_outlined),
          ),
          Text('我的购买',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>MyVipPage()));
            },
            child: GestureDetector(
              child: Text('我的会员',style: TextStyle(fontFamily: 'PingFang SC-Medium',fontSize: 16,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
            ),
          ),
        ],
      ),
    );
    list.add(header);

    ///  滚动选择 充值卡
    if(vipLevelList != null && vipLevelList.length > 0){
      Widget vipCardPageViewWidget = GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 28,top: 24.5),
          child: VipCardPageView(dataList:vipLevelList,getCardItemInfo:(map){
            money = int.parse(map['sellingPrice']);
          },
            openPayDialog: (){
              ///调用支付
              /// 生成订单号
              DateTime currentTime = DateTime.now();
              int timeMills = currentTime.microsecondsSinceEpoch;
              String orderNo = timeMills.toString() + Random().nextInt(1000).toString();
              this.orderNo = orderNo;
              showBottomFunction(orderNo) ;
            },),
        ),
      );
      list.add(vipCardPageViewWidget);
    }

    /// member benefits
    Widget memberBenefitsTitle = Container(
      margin: EdgeInsets.only(left: 28,top: 24.5),
      /*decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF8A7E63),
            Color(0x00FFFFFF),
          ],
        ),
      ),*/
      child: Text('MEMBER BENEFITS',style: TextStyle(fontSize: 24,fontFamily: 'Inter V-Bold',fontWeight: FontWeight.w700),),
    );
    list.add(memberBenefitsTitle);

    // 立即开通会员
    Widget buyVipBtn = GestureDetector(
      onTap: (){
        ///调用支付
        /// 生成订单号
        DateTime currentTime = DateTime.now();
        int timeMills = currentTime.microsecondsSinceEpoch;
        String orderNo = timeMills.toString() + Random().nextInt(1000).toString();
        this.orderNo = orderNo;
        showBottomFunction(orderNo) ;
      },
      child: Container(
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
        child: Text('立即开通会员',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
      ),
    );


    // VIP 权益项
    List<Widget> vipBenifits = [

      /// VIP 标志
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/vip_hat.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VIP标志',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('尊贵VIP独特标志',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      /// 专属客服
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/kefu.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('专属客服',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('7-24专属客服在线服务',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      /// 内容精准匹配
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/neirong_pipei.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('内容精准匹配',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('专属个性化视频推送',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///畅享VIP视频
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/vip_video.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('畅享VIP视频',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('5W+部精品VIP视频免费看',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///评论发布
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/comment_publish.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('评论发布',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('万千瞩目畅所欲言',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///轮盘畅玩
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/lunpan.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('轮盘畅玩',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('90%+中奖率丰厚的奖品等你来拿',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///试试手气
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/shishi_shouqi.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('试试手气',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('更低的价格解锁视频更多玩法',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///每日折扣
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/zhekou.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('每日折扣',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('每日热门精品资源超低折扣解锁',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///双倍奖励
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/shuangbei_jiangli.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('双倍奖励',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('任务系统双倍奖励',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///线路切换
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/xianlu_qiehuan.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('线路切换',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('VIP专属影视线路观看更流畅',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///个性设置
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/gexin_shezhi.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('个性设置',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('设置您的个性化喜好精准匹配高分视频',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 18,),

      ///一键起飞
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/gexin_shezhi.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('一键起飞',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('性福同步回味无穷',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),


      SizedBox(height: 18,),

      ///全屏大图
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/quanpin_datu.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('全屏大图',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('社区丰厚资源限制级查看',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),



      SizedBox(height: 18,),

      ///视频折扣
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/zhekou.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('视频折扣',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('金币视频不定期折扣优惠',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),



      SizedBox(height: 18,),

      ///跳过广告
      Container(
        width: 280,
        height: 55,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('lib/assets/images/vip/skip_ad.png',width: 53.5,height: 53.5,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('跳过广告',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFDC223)),),
                SizedBox(height: 6,),
                Text('VIP无需等待广告',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x80FDC223)),),
              ],
            ),
          ],
        ),
      ),

      buyVipBtn,

    ];

    // VIP 权益/*Widget vipWidget = Container(
    //       width: size.width - 40,
    //       // height: 600,
    //       margin: EdgeInsets.only(left: 18,right: 20,top: 8),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(16),
    //         gradient: LinearGradient(
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //           colors: [
    //             Color(0xFF211D13),
    //             Color(0xFF1A1711),
    //           ],
    //           stops: [0.1, 0.9],
    //         ),
    //         image: DecorationImage(
    //           image: AssetImage('lib/assets/images/vip/buy_vip_background.png'),
    //           fit: BoxFit.fill, // 完全填充
    //         )
    //       ),
    //     );*/


    Widget bottomContain = ListView.builder(
        shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
        physics:NeverScrollableScrollPhysics(),//禁止滚动
        itemCount:vipBenifits.length,
        itemBuilder:(context,index){
          return vipBenifits[index];
        }
    );


    Widget benifitWidget = Stack(
      children: [

        Container(
          width: size.width - 40,
          height: 1260,
          margin: EdgeInsets.only(left: 18,right: 20,top: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF211D13),
                  Color(0xFF1A1711),
                ],
                stops: [0.1, 0.9],
              ),
              image: DecorationImage(
                image: AssetImage('lib/assets/images/vip/buy_vip_background.png'),
                fit: BoxFit.fill, // 完全填充
              )
          ),
        ),

        Positioned(
          left: 20,
          top: 0,
          // child: benifitList
          child: Container(
            margin: EdgeInsets.only(left: 20,right: 20,top: 18),
            child:Text('会员权益介绍',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0x8FFFFFFFF)),),
          ),
        ),

        Positioned(
          left: 20,
          top: 55,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: 300,
                  // height: 450,
                  // color: Colors.blue,
                  margin: EdgeInsets.only(left: 20,top:8,),
                  child: bottomContain,
                ),
              ],
            ),
          ),
        ),

        /*Positioned(
          left: 20,
          top: 480,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: 300,
                  // height: 450,
                  // color: Colors.blue,
                  margin: EdgeInsets.only(left: 20,top:8,),
                  child: buyVipBtn,
                ),
              ],
            ),
          ),
        ),*/
      ],
    );

    list.add(benifitWidget);


    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        return Future(() => true);
      },
      child: Scaffold(
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: list,
                ),

                // _buildCid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _cid = "搞笑";

  // 当前页数//设定Widget的偏移量


  final GlobalKey _cidGlobalKey = GlobalKey();

  _buildCid() {
    Offset _offset = Offset(20, height - 18.5);
    return Positioned(
        left: _offset.dx,
        top: _offset.dy,
        child: GestureDetector(
          //滑动中，实时更新位置
          onPanUpdate: (detail) {
            setState(() {
              _offset = Offset(
                  _offset.dx + detail.delta.dx, _offset.dy + detail.delta.dy);
            });
          },
          //滑动结束 计算最后位置
          onPanEnd: (detail) {
            var margin = 5.0;
            //得到屏幕宽度 根据宽度吸到边上
            var screenWidth = MediaQuery.of(context).size.width;
            var screenHeight = MediaQuery.of(context).size.height;
            //得到当前控件宽
            var weightWidgth = _cidGlobalKey.currentContext.size.width;
            var weightHeight = _cidGlobalKey.currentContext.size.height;
            //得到 当前偏移量
            var offsetDx = _offset.dx;
            var offsetDy = _offset.dy;
            //右边吸边
            if (offsetDx >= screenWidth / 2) {
              offsetDx = screenWidth - weightWidgth - margin;
            } else {
              //左边吸边
              offsetDx = margin;
            }

            if (offsetDy <= 0) {
              offsetDy = margin;
            }
            //获取状态栏高度：
            final double statusBarHeight = MediaQuery.of(context).padding.top;
            //计算y轴的偏移量
            var maxHeight = screenHeight -
                weightHeight -
                kBottomNavigationBarHeight -
                kToolbarHeight -
                margin -
                statusBarHeight;
            if (offsetDy > maxHeight) {
              offsetDy = maxHeight;
            }

            setState(() {
              _offset = Offset(offsetDx, offsetDy);
            });
          },
          child: _cid.length > 0
              ? Chip(
            key: _cidGlobalKey,
            label: Text(
              _cid,
              style: TextStyle(color: Colors.white),
            ),
            // backgroundColor: _colorPrimary,
            onDeleted: () {
              setState(() {
                _cid = "";
              });
            },
          )
              : Container(),
        ));
  }


  /*Positioned(
    left: _offet.dx,
    top: _offset.dy,
    *//*child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),*//*
  )*/


  /**
   * 底部弹窗支付
   */
  Future<int> showBottomFunction(String orderNo) async {
    BottomDialogUtil btm = BottomDialogUtil(
      context: context,
      content: ChargeVipPage(money: money,orderNo: orderNo,setPaymentOperation: (val){
        isPay = val;
      },),
    );
    return btm.build();
  }


  List getVipCardInfo(){
    return [
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
  BuyVipPagePresenter createPresenter() {
    return BuyVipPagePresenter();
  }

}