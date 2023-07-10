import 'package:caihong_app/mock/homePageData.dart';
import 'package:caihong_app/views/tikTokScaffold.dart';
import 'package:caihong_app/views/tikTokVideo.dart';
import 'package:caihong_app/views/tikTokVideoButtonColumn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/shortVideoPagePresen.dart';
import '../utils/PreferenceUtils.dart';

/**
 * 短视频页面
 * 布局页面
 */
class ShortVideoPage extends StatefulWidget{

  String videoId;

  ShortVideoPage({
    Key key,
    this.videoId,
  }) : super(key: key);

  @override
  ShortVideoPageState createState() => ShortVideoPageState();

}

class ShortVideoPageState extends BaseState<ShortVideoPage, ShortVideoPagePresenter> {
    /*with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver */

  int select = 0;
  TabController controller;
  List topMenu;

  int pageNumber = 1;

  int limit = 5;

  bool hasPermission = false;

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List videoDataList = [];

  PageController _pageController = PageController();

  TikTokScaffoldController tkController = TikTokScaffoldController();

  @override
  void initState(){
    super.initState();
    initData();
  }

  void initData(){
    /// 查询视频 &&  搜索短视频
    if(widget.videoId != null){

      /// 当前用户是否是VIP，还是普通用户，金币余额
      PreferenceUtils.instance.getInteger('vipStatus').then((val){
        if(val == 1){
          hasPermission = true;
        };
      });


    Future.wait([
        mPresenter.getShortVideoPages(pageNumber++,limit).then((videoList){
          /// 搜索短视频
          videoDataList.add(searchShortVideoById(widget.videoId));
          widget.videoId = null;
          /// 查询数据
          if(videoList != null && videoList.length > 0){
            videoDataList.addAll(videoList);
          }
        }),

        /// 是不是VIP
        PreferenceUtils.instance.getInteger('vipStatus').then((val){
          if(val == 1){
            hasPermission = true;
          }
        }),

      ]).then((res){
        setState((){ });
      });
    }else{
      Future.wait([
        mPresenter.getShortVideoPages(pageNumber++,limit).then((videoList){
          videoDataList.addAll(videoList);
        }),
        /// 是不是VIP
        PreferenceUtils.instance.getInteger('vipStatus').then((val){
          if(val == 1){
            hasPermission = true;
          }
        }),
      ]).then((res){
        setState((){ });
      });

    }

  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    return PageView.builder(
      key: Key('home'),
      controller: _pageController,
      pageSnapping: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: videoDataList.length,
      onPageChanged: (index){
        print('当前页面： $pageNumber 滚动到第 $index 页.');
        if(videoDataList.length - index < 3){
          initData();
        }
      },
      itemBuilder: (context, i) {
        // 拼一个视频组件出来
        var data = videoDataList[i];
        bool isF = data['isFavorite'] == 1 ? true : false; //SafeMap(favoriteMap)[i].boolean ?? false;
        // var player = _videoListController.playerOfIndex(i);
        // _videoListController.currentPlayer = player;
        // 右侧按钮列
        Widget buttons = TikTokButtonColumn(
          isFavorite: isF,
          onAvatar: () {
            tkController.animateToPage(TikTokPagePositon.right);
          },
          onFavorite: () {
            setState(() {
              favoriteMap[i] = !isF;
            });
            // showAboutDialog(context: context);
          },
          onComment: () {
            /*CustomBottomSheet.showModalBottomSheet(
              backgroundColor: Colors.white.withOpacity(0),
              context: context,
              builder: (BuildContext context) =>
                  TikTokCommentBottomSheet(),
            );*/
          },
          onShare: () {},
          shortVideoInfo: data,
        );

        Widget currentVideo = TikTokVideoPage(
          // hidePauseIcon: player.state != FijkState.paused,
          aspectRatio: 9 / 16.0,
          key: Key(data['playPath'] + '$i'),
          tag: data['playPath'],
          backgroundImage: '',
          bottomPadding: hasBottomPadding ? 16.0 : 16.0,
          userInfoWidget: VideoUserInfo(
            desc: data['title'],
            bottomPadding: 50,
            // onGoodGift: () => showDialog(
            //   context: context,
            //   builder: (_) => FreeGiftDialog(),
            // ),
          ),
          onAddFavorite: () {
            setState(() {
              favoriteMap[i] = true;
            });
          },
          rightButtonColumn: buttons,
          videoInfo: data,
          hasPermission: hasPermission,
        );
        return currentVideo;
      },
    );
  }

  @override
  ShortVideoPagePresenter createPresenter() {
    return ShortVideoPagePresenter();
  }


  /*@override
  HomePresenter createPresenter() {
    // TODO: implement createPresenter
    return HomePresenter();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;*/
}




