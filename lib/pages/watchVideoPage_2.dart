import 'package:caihong_app/pages/showSwiperPage.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../base/config/playerShowConfig.dart';
import '../base/view/base_state.dart';
import '../presenter/watchVideoPagePresenter.dart';
import '../utils/stringUtils.dart';
import '../views/guessLikePage.dart';
import '../views/videoOperation.dart';

class WatchVideoPage2 extends StatefulWidget {

  final int videoId;

  final String videoUrl;

  // 标题
  final String title;

  // 点赞数
  final int likeNum;

  //播放数
  final int playNum;

  // 时长
  final String duration;

  // 视频标签;#分割
  final String tags;

  final String createTime;

  WatchVideoPage2({this.videoId,this.videoUrl,this.title,this.likeNum : 0,this.playNum : 0,this.duration : '',this.tags : '',this.createTime : '2023-06-23'});

  @override
  WatchVideoPageState createState() => WatchVideoPageState();
}

class WatchVideoPageState extends BaseState<WatchVideoPage2,WatchVideoPagePresenter> {

  final FijkPlayer player = FijkPlayer();

  VideoSourceFormat _videoSourceTabs;
  int _currTabIndex = 0;
  int _currActiveIdx  = 0;
  ShowConfigAbs vConfig = PlayerShowConfig();

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
    super.initState();
    // videoInfo = getWatchVideoPageInfo('123', '231');
    // player.setDataSource(widget.videoUrl ?? widget.videoUrl,autoPlay: true,showCover: true);

    // 视频数据源
    Map<String, List<Map<String, dynamic>>> videoList = {
      'video':[
        {
          'list':[
            {
              'url': widget.videoUrl,
              'name': '视频名称'
            },
          ]
        }
      ]
    };
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
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

    Widget fijkView = FijkView(
      height: 260,
      color: Colors.black,
      fit: FijkFit.contain,
      player: player,
      panelBuilder: (
          FijkPlayer player,
          FijkData data,
          BuildContext context,
          Size viewSize,
          Rect texturePos){
        return CustomFijkPanel(
            player: player,
            viewSize: viewSize,
            texturePos: texturePos,
            pageContent: context,
            //标题 当前页面顶部的标题部分
            // playerTitle: '一个忧郁的故事',
            //视频显示的配置
            showConfig: vConfig,
            //json格式化后的视频数据
            videoFormat: _videoSourceTabs,
            //当前视频源 资源一 资源二等
            curTabIdx: _currTabIndex,
            //当前视频 高清 标清 流畅等
            curActiveIdx: _currActiveIdx
        );
      },
    );

    /*Widget fijkView = FijkView(
      height:  videoHeight,
      width:  width,
      player: player,
      color: Colors.black,
      fit: FijkFit.contain,
      fsFit: FijkFit.contain,
      // panelBuilder: (_, __, ___, ____, _____) => Container(),
      *//*panelBuilder:  (FijkPlayer player, FijkData data, BuildContext context, Size viewSize, Rect texturePos) {
        /// 使用自定义的布局
        return CustomFijkWidgetBottom(
          player: player,
          buildContext: context,
          viewSize: viewSize,
          texturePos: texturePos,
          onTapPlayer: (playerState){
            oldFijkstate = playerState;
          },
          onEntryFullScreen:(map){
            bool _isFullScreen = map['isFullScreen'];
            oldFijkstate = map['playerState'];

            setState(() {
              if (player.state == FijkState.started) {
                player.pause();
                /// 播放状态，进度条一直刷新，需要暂停播放器，让进度条暂时不刷新
                oldFijkstate = player.state;
              }

              if(_isFullScreen){
                player.exitFullScreen();
              }else{
                player.enterFullScreen();
              }
              isFullScreen = !_isFullScreen;
            });
          },
          isFullScreen: isFullScreen,
          oldFijkstate:oldFijkstate,
          hasPermission: false,
        );
      },*//*
    );*/
    /*list.add(fijkView);*/

    ///播放视频下面的介绍信息
    Widget videoInfoText = Container(
        margin: EdgeInsets.only(left: 20,right: 20,),
        alignment: Alignment.topLeft,
        child:RichText(
          text: TextSpan(
              children: [
                TextSpan(text: "正在播放预览视频，",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 12,fontWeight: FontWeight.w400),),
                TextSpan(
                    text: " 开通会员 ",
                    style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFAC5AFF),fontSize: 12,fontWeight: FontWeight.w400),
                    recognizer: TapGestureRecognizer()..onTap = () async {
                      print('跳转升级会员页面');
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
              Text(widget.playNum.toString() + '次观看',style: TextStyle(fontSize: 12,color: Color(0x80FFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400)),
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
        isCollect:1,
        isFavorite:1,
        favoriteTotal:widget.likeNum.toString(),
        collectTotal:'1009',
        level:1,
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
    Widget guessLikeWidget = GuessLikePage(showType: 1,dataList: [],player: player,);
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



    return Scaffold(
      body: Stack(
        children: [
          // VideoPlay(videoUrl: videoInfo['videoUrl'],player: player,),

          Container(
            child: Column(
              children: [
                GestureDetector(
                  /*onTap: (){
                    if (isShowDialog){
                      // DialogUtil(content: getShowDialog(),onClose: (){Navigator.of(context).pop();},);
                      if (player.state == FijkState.started) {
                        player.pause();
                      }
                      getShowDialog();
                      showTime++;
                    }else{
                      if (player.state == FijkState.started) {
                        player.pause();
                      } else {
                        player.start();
                      }
                      setState(() {});
                    }
                  },*/
                  child: Container(
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
    );
  }

  @override
  WatchVideoPagePresenter createPresenter() {
    return WatchVideoPagePresenter();
  }

}


