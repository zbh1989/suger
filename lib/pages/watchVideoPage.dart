import 'dart:async';
import 'dart:math';
import 'package:caihong_app/pages/chargePage.dart';
import 'package:caihong_app/pages/showSwiperPage.dart';
import 'package:caihong_app/utils/toast.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/watchVideoPagePresenter.dart';
import '../utils/PreferenceUtils.dart';
import '../utils/dialogUtil.dart';
import '../utils/stringUtils.dart';
import '../views/customFijkPanel.dart';
import '../views/guessLikePage.dart';
import '../views/openVipDialog.dart';
import '../views/tiktokTabBar.dart';
import '../views/videoOperation.dart';
import 'buyVipPage.dart';
import 'homePage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WatchVideoPage extends StatefulWidget {

  final String videoId;

  final String videoUrl;

  // 标题
  final String title;

  // 点赞数
  final int likeNum;

  // 收藏次数
  final int favNum;

  //播放数
  final int playNum;

  // 时长
  final String duration;

  // 视频标签;#分割
  final String tags;

  final String createTime;

  /// 收费状态[1: 免费; 2: 金币; 3: vip]
  final int showLevel;

  /// 价格大于1需要独立购买
  final int gold;

  final int videoEndTime;

  final int videoStartTime;

  WatchVideoPage({this.videoId,this.videoUrl,this.title,this.likeNum : 0,this.playNum : 0,this.duration : '',this.tags : '',this.createTime : '2023-06-23',this.showLevel,this.gold,this.favNum,this.videoStartTime:30,this.videoEndTime:60,});

  @override
  WatchVideoPageState createState() => WatchVideoPageState();
}

class WatchVideoPageState extends BaseState<WatchVideoPage,WatchVideoPagePresenter> {

  final Completer<WebViewController> controller = Completer();

  final FijkPlayer player = FijkPlayer();

  // Map videoInfo;

  /// 流监听器
  StreamSubscription _currentPosSubs;

  bool isShowDialog = false;

  int showTime = 0;

  Timer timer;

  /// 是否有播放权限
  bool hasPermission = false;

  bool reloadData = false;

  List guessLikeList = [];

  int baseVideoEndTime;

  int baseVideoStartTime;

  static const FijkFit fill = FijkFit(
    sizeFactor: 1.0,
    aspectRatio: double.infinity,
    alignment: Alignment.center,
  );

  static const FijkFit contain = FijkFit(
    sizeFactor: 1.0,
    aspectRatio: -1,
    alignment: Alignment.center,
  );

  @override
  void initState() {
    Future.wait([

      PreferenceUtils.instance.getInteger("videoStartTime").then((val)=>baseVideoStartTime = val,), // 视频预览开始时间
      PreferenceUtils.instance.getInteger("videoEndTime").then((val)=>baseVideoEndTime = val,), // 视频预览结束时间

      mPresenter.getGuessLikeVideoPages(1, 10),
    ]).then((guessLikeVideoList){
      if(mounted){
        setState(() {
          if(guessLikeVideoList != null && guessLikeVideoList.length > 0){
            guessLikeList.addAll(guessLikeVideoList[2]);
          }
        });
      }
    }).catchError((err){
      print('查询猜你喜欢异常.$err');
    });

    super.initState();

    if(widget.showLevel == 1){ /// 免费
      hasPermission = true;
      player.setDataSource(widget.videoUrl,autoPlay: true,showCover: true);
    }else{
      if(widget.showLevel == 2){ /// 金币
        /// 购买视频
        requestData();
      }else if(widget.showLevel == 3){ /// VIP
        PreferenceUtils.instance.getInteger("vipStatus").then((vipStatus){ /// 是否是vip; 1: 是; 0 不是
          if(vipStatus == 1){
            setState(() {
              hasPermission = true;
              player.setDataSource(widget.videoUrl,autoPlay: true,showCover: true);
            });
          }else{
            setState(() {
              int seekTime = 0;
              if(widget.videoStartTime != null && widget.videoStartTime > 0){
                seekTime = widget.videoStartTime;
              }else if(baseVideoStartTime !=null && baseVideoStartTime > 0){
                seekTime = baseVideoStartTime;
              }
              if(seekTime > 0){
                player.setOption(FijkOption.playerCategory, "seek-at-start", seekTime*1000);
              }
              player.setDataSource(widget.videoUrl,autoPlay: true,showCover: true);
            });
          }
        });
      }
    }
  }

  /// 购买视频
  void requestData() async {
    if(widget.videoId == null){
      Toast.show('视频ID为空');
      return ;
    }
    mPresenter.buyVideo(widget.videoId);
  }

  /// 初始化视频，加载播放
  void refreshPage(bool res,int buyOrNot) async { // res = true 为扣除成功，false 扣除失败   buyOrNot : 1 已经购买过 ，2 没有购买
    if(mounted){
      setState(() {
        hasPermission = res;
        player.setDataSource(widget.videoUrl ?? widget.videoUrl,autoPlay: hasPermission ? true : false,showCover: true);

        if(res){
          if(buyOrNot == 1){
            Toast.tips('你已购买过该视频，请观看');
          }else{
            Toast.tips('扣除金币 ${widget.gold} 成功');
          }

        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showGoldDialog(widget.gold);
          });
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      player.pause();
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  @override
  Widget build(BuildContext context) {
    final Size size =MediaQuery.of(context).size;
    final double width =size.width;
    final double height =size.height;
    final double videoHeight = 225;

    List<Widget> list = [];

    // Widget fijkView = WatchPage(videoHeight:videoHeight,width:width,player:player,hasPermission: hasPermission,showLevel: widget.showLevel,);

     Widget fijkView = FijkView(
      height: videoHeight,
      width: width,
      player: player,
      color: Colors.black,//Colors.purpleAccent,
      fit: FijkFit.contain,
      fsFit: FijkFit.contain,
      panelBuilder:  (FijkPlayer player, FijkData data, BuildContext context, Size viewSize, Rect texturePos) {
        return CustomFijkPanel(
          videoStartTime: widget.videoStartTime,
          videoEndTime: widget.videoEndTime,
          baseVideoStartTime: baseVideoStartTime ?? 0,
          baseVideoEndTime: baseVideoEndTime ?? 30,
          showLevel: widget.showLevel,
          player: player,
          videoUrl: widget.videoUrl,
          buildContext: context,
          viewSize: viewSize,
          texturePos: texturePos,
          videoTitle: '',
          isPlayAd: false,
          isNextNumber: false,
          hasPermission: hasPermission,
          onPlayAd: () {
            /// 播放广告 isPlayAd true 才会显示点击后处理播放后再开始播放视频
          },
          onError: () async {
            await player.reset();
          },
          onBack: () {
            if(player.value.fullScreen){
              player.exitFullScreen();
              reloadData = true;
            }else{
              Navigator.of(context).pop();
             /* Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(
                    builder: (context) => new HomePage(type: TikTokPageTag.firstPage)),
                    (route) => route == null,
              );*/
            }

            // Navigator.pop(context); // 如果需要做拦截返回则在此判断
          },
          onVideoEnd: () async {
            // 视频结束最后一集的时候会有个UI层显示出来可以触发重新开始
            await player.reset();
          },
          onVideoTimeChange: () {
            // 视频时间变动则触发一次，可以保存视频历史如不想频繁触发则在里修改 sendCount % 50 == 0
          },
          onVideoPrepared: () async {
            // 视频初始化完毕，如有历史记录时间段则可以触发快进
          },
          noPermissionDialog: () async {
            // 没有权限播放完整视频弹窗提示:
            if(widget.showLevel == 2){
              showGoldDialog(widget.gold);
            }else if(widget.showLevel == 3){
              showVipDialog();
            }
          },
        );
      },
    );
    /*list.add(fijkView);*/

    ///播放视频下面的介绍信息
    Widget videoInfoText = Container(
        margin: EdgeInsets.only(left: 20,right: 20,),
        alignment: Alignment.topLeft,
        child: hasPermission ? Text('正在播放完整视频',style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 12,fontWeight: FontWeight.w400),) :
        RichText(
          text: TextSpan(
              children: [
                TextSpan(text: "正在播放预览视频，",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 12,fontWeight: FontWeight.w400),),
                TextSpan(
                    text: " 开通会员 ",
                    style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFAC5AFF),fontSize: 12,fontWeight: FontWeight.w400),
                    recognizer: TapGestureRecognizer()..onTap = () async {
                      print('跳转升级会员页面');
                      player.pause();
                      Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>BuyVipPage()));
                    }),
                TextSpan(text: "后播放 " + (widget.duration ?? '')+ " 完整版视频",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 12,fontWeight: FontWeight.w400),),
              ]
          ),
          textDirection: TextDirection.ltr,
        ),
    );
    // list.add(videoInfoText);

    /// 视频编码 + 视频名称 + 主角名称
    Widget videoText = Container(
      margin: EdgeInsets.only(top: 18,left: 20,right: 20,),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            ConstrainedBox(
              constraints:BoxConstraints(maxWidth: width - 60),
              child: Text( StringUtils.breakWord(widget.title ?? ''),
                textAlign:TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
              ),
          ],),
          SizedBox(height: 8,),
          Row(
            children: [
              Text((widget.playNum == 0 || widget.playNum == null) ? Random().nextInt(2000).toString() + '次观看' : widget.playNum.toString() + '次观看',style: TextStyle(fontSize: 12,color: Color(0x80FFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400)),
              SizedBox(width: 9.5,),
              Text(widget.createTime ?? '' ,style: TextStyle(fontSize: 12,color: Color(0x80FFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400)),
            ],
          )
        ],
      ),
    );
    // list.add(videoText);

    /// 小编推荐标签
    List recommandTitle = [];
    if(widget.tags != '' && widget.tags != null){
      recommandTitle = widget.tags.split('#');
    }
    if(recommandTitle.isNotEmpty){
      List<Widget> titleWidgetList = [];
      recommandTitle.forEach((item) {
        print('-----==' + item);
        titleWidgetList.add(Container(
          height: 25,
          padding: EdgeInsets.only(left:10,right: 10,top: 4,bottom: 4),
          decoration: BoxDecoration(
            color: Color(0xFF2E0169),
            borderRadius: BorderRadius.circular(15.75),
          ),
          child: Text(item,style: TextStyle(fontSize: 12,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400)),
        ));
        titleWidgetList.add(SizedBox(width: 8,),);
      });

      Widget titleWidget = Container(
        margin: EdgeInsets.only(top: 8,left: 20),
        child: Row(
          textDirection : TextDirection.ltr ,
          children: titleWidgetList,
        ),
      );
      list.add(titleWidget);
    }

    /// 点赞    收藏     缓存下载       普通线路
    Widget favorite = VideoOperation(
        isCollect:0,
        isFavorite:0,
        favoriteTotal:(widget.likeNum == null || widget.likeNum == 0) ? (Random().nextInt(1000) + 1000).toString() : widget.likeNum.toString(),
        collectTotal:(widget.favNum == null || widget.favNum == 0) ? (Random().nextInt(1000) + 1000).toString() : widget.favNum.toString(),
        level:1,// TODO: 这里要取用户等级
        videoId: widget.videoId,
    );
    list.add(favorite);

    /// 横幅广告图片
    Widget adWidget = Container(
      height: 120,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 38,left: 20,right: 20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        child:Image.network('https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
          width: width,
          fit: BoxFit.cover,
        ),
        onTap: (){
          player.release();
          Navigator.push(context, MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context){
                return ShowSwiperPage('https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg');
              }
          ));
        },
      ),
    );
    // list.add(adWidget);

    /// 猜你喜欢
    Widget guessLikeWidget = GuessLikePage(showType: 1,dataList: guessLikeList,player: player,reloadData: reloadData,);
    list.add(guessLikeWidget);

   /* Widget guessLikeWidget = Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 7.5,top: 18),
            child: Row(
              children: [
                Image.asset('lib/assets/images/title_icon.png',height: 25,width: 5,),
                SizedBox(width: 7.5,),
                Text('猜你喜欢',style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Medium',),),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 20,right: 20,top: 16),
            child: GridView.count(
              //如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
              primary: false,
              //禁止滚动
              physics: NeverScrollableScrollPhysics(),
              //是否允许内容适配
              shrinkWrap: true,
              //水平子Widget之间间距
              crossAxisSpacing: videoInfo['showType'] == 1 ? 15 : 10,
              //垂直子Widget之间间距
              mainAxisSpacing: 16,
              //GridView内边距
              padding: EdgeInsets.all(0.0),
              //一行的Widget数量  showType: 1 横着放， 2 竖着放
              crossAxisCount: videoInfo['showType'] == 1 ? 2 : 3,
              //子Widget宽高比例
              childAspectRatio: videoInfo['showType'] == 1 ? 160/118 : 105/168,
              //子Widget列表
              children:  getWidgetList(),
            ),
          ),
        ],
      ),
    );
    list.add(guessLikeWidget);*/


    return WillPopScope(
      onWillPop: () async {
        player.release();

        Navigator.of(context).pop();

        /*Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (context) => new HomePage(type: TikTokPageTag.firstPage)),
              (route) => route == null,
        );*/

        return Future.value(true);
      },
      child:  Scaffold(
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 30,),
                      child: fijkView,
                    ),
                  ),
                  videoInfoText,
                  videoText,
                ],
              ),
            ),

            DraggableScrollableSheet(
              // 注意 maxChildSize >= initialChildSize >= minChildSize
              //初始化占用父容器高度
              initialChildSize: (height - videoHeight - 80 + 16)/height,
              //占用父组件的最小高度
              minChildSize: 0.0,
              //占用父组件的最大高度
              maxChildSize: (height - videoHeight - 80 + 20)/height,
              //是否应扩展以填充其父级中的可用空间默认true 父组件是Center时设置为false,才会实现center布局，但滚动效果是向两边展开
              expand: true,
              //true：触发滚动则滚动到maxChildSize或者minChildSize，不在跟随手势滚动距离 false:滚动跟随手势滚动距离
              snap: true,
              // 当snapSizes接收的是一个数组[],数组内的数字必须是升序，而且取值范围必须在 minChildSize,maxChildSize之间
              //作用是可以控制每次滚动部件占父容器的高度，此时expand: true,
              // snapSizes: [ 0.3, 0.4, 0.8],
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.zero,
                  child: ListView(children: list,),
                );
              },
            )


          ],
        ),
        // body: ListView(children: list,),
      ),
    );

    /*return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 30,),
                    child: fijkView,
                  ),
                ),
                videoInfoText,
                videoText,
              ],
            ),
          ),

          DraggableScrollableSheet(
            // 注意 maxChildSize >= initialChildSize >= minChildSize
            //初始化占用父容器高度
            initialChildSize: (height - videoHeight - 80 + 16)/height,
            //占用父组件的最小高度
            minChildSize: 0.0,
            //占用父组件的最大高度
            maxChildSize: (height - videoHeight - 80 + 20)/height,
            //是否应扩展以填充其父级中的可用空间默认true 父组件是Center时设置为false,才会实现center布局，但滚动效果是向两边展开
            expand: true,
            //true：触发滚动则滚动到maxChildSize或者minChildSize，不在跟随手势滚动距离 false:滚动跟随手势滚动距离
            snap: true,
            // 当snapSizes接收的是一个数组[],数组内的数字必须是升序，而且取值范围必须在 minChildSize,maxChildSize之间
            //作用是可以控制每次滚动部件占父容器的高度，此时expand: true,
            // snapSizes: [ 0.3, 0.4, 0.8],
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.zero,
                child: ListView(children: list,),
              );
            },
          )


        ],
      ),
      // body: ListView(children: list,),
    );*/
  }

   void showVipDialog(){
    Size size = MediaQuery.of(context).size;
    EdgeInsets ei = MediaQuery.of(context).padding;
    double width = size.width;
    double imgWidth = width - 35;
    double imgHeight = imgWidth * 468 / 348;
    double marginTop = (size.height + ei.top + ei.bottom - imgHeight)/2 + 30;
    if(marginTop < 0){
      marginTop = 30;
    }
    showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogUtil(
          marginTop: 30,
          content: OpenVipDialog(),
          onClose: (){Navigator.of(context).pop();},
        );
      },
    );
  }

  /**
   * 解锁金币弹窗
   */
  void showGoldDialog(int gold) async {
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    Image.asset('lib/assets/images/use_gold_watch.png',width: 75,height: 75,),
                    SizedBox(height:10),
                    Text('$gold金币解锁视频',style: TextStyle(fontSize: 18,color: Color(0xFFAC5AFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
                    SizedBox(height:10),
                    Text('购买解锁后才能观看完整视频！',style: TextStyle(fontSize: 13,color: Color(0x80000000),fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
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
                          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>ChargePage()));
                        },
                        child: Text('使用观影券',style: TextStyle(fontSize: 14,color: Color(0xFFAC5AFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
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
                          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>ChargePage()));
                        },
                        child: Text('确认',style: TextStyle(fontSize: 16,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
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
            Navigator.of(context).pop();
          },
        );

      },
    );

    print("弹框关闭 $isSelect");
  }

  @override
  WatchVideoPagePresenter createPresenter() {
    return WatchVideoPagePresenter();
  }

}


