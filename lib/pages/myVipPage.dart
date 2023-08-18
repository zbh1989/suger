import 'dart:math';

import 'package:caihong_app/pages/vipChargeHisPage.dart';
import 'package:caihong_app/pages/watchVideoPage.dart';
import 'package:caihong_app/presenter/MyVipPagePresenter.dart';
import 'package:caihong_app/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../utils/PreferenceUtils.dart';
import '../views/videoImg.dart';


/**
 * 我的会员页面
 */
class MyVipPage extends StatefulWidget{

  @override
  MyVipPageState createState() => MyVipPageState();

}


class MyVipPageState extends BaseState<MyVipPage,MyVipPagePresenter>{

  List dataList = [];

  String endVipDate = '1990-1-1';

  String username;

  //自定义 RefreshIndicatorState 类型的 Key
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  @override
  void initState() {

    Future.wait([
      PreferenceUtils.instance.getString("endVipDate").then((val){
        endVipDate = val;
      }),
      /// 用户名
      PreferenceUtils.instance.getString("username").then((value) => username = value),

    ]).then((res) => {
      setState(() {}),
    });

    initData();
    //必须在组件挂载运行的第一帧后执行，否则 _refreshKey 还没有与组件状态关联起来
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //关键代码，直接触发下拉刷新
      _refreshKey.currentState?.show();
    });
    super.initState();

  }

  void initData() async {
    await mPresenter.getRecommandVideos().then((videoList){
      dataList.addAll(videoList);
      if(mounted){
        setState(() {

        });
      }
    });
  }

  void refreshPage() async {
    setState(() {
    });
  }

  Future<void> refreshData() async{
    mPresenter.refreshAllData();
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

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
          Text('我的会员',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          /*GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>VipChargeHisPage(),));
            },//
            child: Text('会员记录',style: TextStyle(fontFamily: 'PingFang SC-Medium',fontSize: 16,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          ),*/
          Container(),
        ],
      ),
    );
    list.add(header);


    ///  我的VIP 信息
    Widget myVipInfo = Container(
      width: size.width - 40,
      margin: EdgeInsets.only(left: 20,right: 20,top: 32,),
      decoration: BoxDecoration(
        color: Color(0xFF322A1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 18,right: 20,top: 35,bottom: 35),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/myvip/my_vip_background.png'),
                fit: BoxFit.fill, // 完全填充
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 头像
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    /*border: Border.all(
                      color: Colors.white,
                      width: 0,
                    ),*/
                  ),
                  child: ClipOval(
                      child:Image.asset('lib/assets/images/avator/001.webp',fit:BoxFit.cover,)
                  ),
                ),


                /// VIP 信息
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(username??'千歌未央',style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFD96B)),),
                          SizedBox(width: 8,),
                          Image.asset('lib/assets/images/myvip/vip_log.png',width: 30,height: 30,)
                        ],
                      ),
                      // SizedBox(height: 8),
                      Text('会员到期:$endVipDate',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF)),),
                    ],
                  ),
                ),

                /// 开通会员按钮
                Container(
                  alignment: Alignment.center,
                  // margin: EdgeInsets.only(right: 20,top: 35),
                  padding: EdgeInsets.only(left: 12.5,right: 12.5,top: 8,bottom: 8,),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAE094),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Text('开通会员',style: TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFF664826)),),
                  ),
                )
              ],
            ),
          ),


          Container(
            // color: Colors.red,
            margin: EdgeInsets.only(left: 18,top: 18),
            child: Text('领取价值180元+专属权益',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 16,color: Color(0xFFFFD96B),fontWeight: FontWeight.bold),),
          ),

          // SizedBox(height: 16,),

          Container(
            height: 100,
            margin: EdgeInsets.only(left: 18,right: 18,top: 16,bottom: 16),
            padding: EdgeInsets.only(left: 17,right: 20,top: 18,bottom: 18),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/myvip/vip_fuli.png'),
                  fit: BoxFit.fill, // 完全填充
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('赠送188金币',style: TextStyle(fontFamily: 'PingFang SC-Medium',fontSize: 13,color: Color(0xFF664826),fontWeight: FontWeight.w400),),
                    Text('赠送3张观影券',style: TextStyle(fontFamily: 'PingFang SC-Medium',fontSize: 13,color: Color(0xFF664826),fontWeight: FontWeight.w400),),
                    Text('赠送1次轮盘抽奖机会',style: TextStyle(fontFamily: 'PingFang SC-Medium',fontSize: 13,color: Color(0xFF664826),fontWeight: FontWeight.w400),),
                  ],
                ),

                /// 立即领取按钮
                Container(
                  padding: EdgeInsets.only(left: 18,right: 18,top: 2,bottom: 2,),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAE094),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Toast.tips('活动未开始，敬请期待...');
                    },
                    child: Text('立即领取',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFF664826)),),
                  ),
                )

              ],
            ),
          ),


        ],
      ),
    );

    list.add(myVipInfo);

    // list.add(SizedBox(height: 16,));

    /// VIP 今日专属推荐
    Widget vipRecommand = Container(
      width: size.width - 40,
      margin: EdgeInsets.only(left: 20,right: 20,top: 16,bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xFF211D38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 18,top: 20,),
            child: Text('VIP今日专属推荐',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFFFFFF)),),
          ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 18,),
            child: Text('来一部好片放松下自己，cheerup!',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.bold,color: Color(0x80FFFFFF)),),
          ),

          Container(
            margin: EdgeInsets.only(left: 20,right: 20,top: 16,bottom: 15),
            child: GridView.count(
              //如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
              primary: false,
              //禁止滚动
              physics: NeverScrollableScrollPhysics(),
              //是否允许内容适配
              shrinkWrap: true,
              //水平子Widget之间间距
              crossAxisSpacing: 4,
              //垂直子Widget之间间距
              mainAxisSpacing: 2,
              //GridView内边距
              padding: EdgeInsets.all(0.0),
              //一行的Widget数量  showType: 1 横着放， 2 竖着放
              crossAxisCount: 3,
              //子Widget宽高比例
              childAspectRatio: 105/188,
              //子Widget列表
              children:  getWidgetList(),
            ),
          ),


        ],
      ),
    );

    list.add(vipRecommand);

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
        child: Container(
          color: Color(0xFF060123),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
          ),
        ),
      ),


    );
  }


  List<Widget> getWidgetList(){
    List<Widget> list = [];
    if(dataList.length > 0){
      dataList.forEach((item) {
        list.add(getItemContainer(item));
      });
    }
    return list;
  }

  Widget getItemContainer(Map<String,dynamic> item) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    double imgWidth = (width - 60)/3;
    double imgHeight = imgWidth * 140 / 105;

    String imgUrl = item['vcover'] == '' ? item['hcover'] : item['vcover'];
    String duration = item['duration'];
    int showLevel = item['toll'];
    int gold = item['price']??0;
    String desc = item['title'];
    String videoId = item['id'] ?? 0;
    String playPath = item['playPath'];
    // 标题
    String title = item['title'];
    // 点赞数
    int likeNum = item['likeNum'];

    //播放数
    int playNum = item['playNum'];
    if(playNum == null || playNum == 0){
      playNum = Random().nextInt(20000) + 2000;
    }

    // 视频标签;#分割
    String tags = item['tags'];

    String createTime = item['createTime'];

    // 收藏次数
    int favNum = item['favNum'];

    int videoEndTime = item['videoEndTime'];

    int videoStartTime = item['videoStartTime'];

    //视频图片
    return VideoImg(imgUrl:imgUrl,imgWidth:imgWidth,imgHeight:imgHeight,duration:duration,showLevel:showLevel,gold: gold,desc:desc,videoId:videoId,
        onTapPlayer:(){
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context) => WatchVideoPage(videoId:videoId,videoUrl: playPath,title: title,likeNum: likeNum,playNum: playNum,duration: duration,
                tags: tags,createTime: createTime,gold: gold,showLevel: showLevel,favNum:favNum,videoStartTime: videoStartTime,videoEndTime: videoEndTime,),
            ),
          );
        }
    );
  }

  @override
  MyVipPagePresenter createPresenter() {
    return MyVipPagePresenter();
  }

}