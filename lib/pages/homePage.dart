import 'dart:io';
import 'package:caihong_app/base/view/base_state.dart';
import 'package:caihong_app/mock/homePageData.dart';
import 'package:caihong_app/mock/video.dart';
import 'package:caihong_app/pages/chatPage.dart';
import 'package:caihong_app/pages/loginPage.dart';
import 'package:caihong_app/pages/packageVersionPage.dart';
import 'package:caihong_app/pages/shortVideoPage.dart';
import 'package:caihong_app/pages/topicPage.dart';
import 'package:caihong_app/pages/userPage.dart';
import 'package:caihong_app/presenter/home_presenter.dart';
import 'package:caihong_app/utils/dialogUtil.dart';
import 'package:caihong_app/views/tikTokScaffold.dart';
import 'package:caihong_app/views/tiktokTabBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../views/tikTokHeader.dart';
import 'menuTopicPage.dart';
import 'newFirstPage.dart';


/**
 * DESC: 进入页面加载项
 */

class HomePage extends StatefulWidget {
  final TikTokPageTag type;

  final String menuId;

  final String menuName;

  /// 搜索跳转短视频页面 视频ID
  final String videoId;

  /// isHome: 是否是首页（没有设置，取第一条数据为首页） ,1: 是，2: 否,
  final int isHome;

  /// showType: 1 横着放，一行放两个图片，2 竖着放，一行放三个图片,首页优先取专题板块排列方式，没有设置板块排列方式取首页排列方式
  final int showType;

  /// 加载公告
  bool isLoaded = false;

  HomePage({
    Key key,
    this.type,
    this.menuId,
    this.menuName,
    this.videoId,
    this.isHome,
    this.showType,
    this.isLoaded,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseState<HomePage, HomePresenter>
   /* with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver */{

  TikTokPageTag tabBarType = TikTokPageTag.firstPage;

  String currentMenuId;

  String currentMenuName;

  TikTokScaffoldController tkController = TikTokScaffoldController();

  // PageController _pageController = PageController();

  // VideoListController _videoListController = VideoListController();

  /// 记录点赞
  Map<int, bool> favoriteMap = {};

  List<UserVideo> videoDataList = [];

  WebSocket _webSocket;

  int pageNumber = 1;

  String advoceMsg = '';

  CheckUpdateVersion checkUpdateVersion = CheckUpdateVersion();


  void closeSocket() {
    _webSocket.close();
  }

  /*@override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    _videoListController.currentPlayer.pause();
    closeSocket();
    super.dispose();
  }*/


  @override
  void initState() {


     WidgetsBinding.instance.addPostFrameCallback((_) {
       if(widget.isLoaded != null && widget.isLoaded){
         Size size = MediaQuery.of(context).size;
         EdgeInsets ei = MediaQuery.of(context).padding;
         // Toast.show('首页加载完成，页面初始高度' + (size.height + ei.top + ei.bottom).toString());

         /// 检测更新版本
         checkUpdateVersion.check();

         /// 公告弹窗
         showAdvoce(advoceMsg);

       }
    });

    if (widget.type != null) {
      tabBarType = widget.type;
    }
    if(widget.menuId != null){
      currentMenuId = widget.menuId;
    }
     if(widget.menuName != null){
       currentMenuName = widget.menuName;
     }
    // mPresenter.getVideoList(pageNumber.toString());
    // mPresenter.connectServer();
    super.initState();

  }

  void jumpLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (cxt) => LoginPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {

    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null){
      widget.isLoaded = args['isLoaded'];
      String tempMsg = args['advoceMsg'];
      tempMsg.split('\\n').forEach((element) {
        advoceMsg += element + '\n';
      });
    }

    Widget currentPage;

    switch (tabBarType) {
      case TikTokPageTag.firstPage:
        if(widget.isHome == null || widget.isHome == 1){
          currentPage = NewFirstPage(menuId: currentMenuId,);
        }else{
          currentPage = MenuTopicPage(menuId: currentMenuId,menuName:currentMenuName,showType: widget.showType,);
        }
        break;
      case TikTokPageTag.shortVideo:
      currentPage = ShortVideoPage(videoId:widget.videoId);
        break;
      case TikTokPageTag.topic:
        currentPage = TopicPage();
        break;
      case TikTokPageTag.find:
        currentPage = ChatPage();
        break;
      case TikTokPageTag.me:
        currentPage = UserPage();
        break;
    }
    double a = MediaQuery.of(context).size.aspectRatio;
    bool hasBottomPadding = a < 0.55;

    bool hasBackground = hasBottomPadding;
    hasBackground = tabBarType != TikTokPageTag.shortVideo;
    if (hasBottomPadding) {
      hasBackground = true;
    }
    Widget tikTokTabBar = TikTokTabBar(
      hasBackground: hasBackground,
      current: tabBarType,
      onTabSwitch: (type) async {
        setState(() {
          tabBarType = type;
        });
      },
    );

    var header = tabBarType == TikTokPageTag.shortVideo
        ? TikTokHeader(
            onSearch: () {
              tkController.animateToLeft();
            },
          )
        : Container();


    // 组合
    return TikTokScaffold(
      controller: tkController,
      hasBottomPadding: hasBackground,
      tabBar: tikTokTabBar,
      header: header,
      // leftPage: searchPage,
      enableGesture: tabBarType == TikTokPageTag.shortVideo,
      // onPullDownRefresh: _fetchData,
      page: Stack(
        // index: currentPage == null ? 0 : 1,
        children: <Widget>[
          currentPage ?? Container(),
        ],
      ),
    );
  }


  @override
  HomePresenter createPresenter() {
    return HomePresenter();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  /// 公告弹窗
  void showAdvoce(String advoceMsg) async {

    List<Widget> list = [];
    list.add(Image.asset("lib/assets/images/advoce.png",height: 100,width: 285,),);

    // 公告标题
    Widget title = Container(
      margin: EdgeInsets.only(top: 16,left:16,),
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFE08EFC),
                  Color(0xFF6D14B2),
                ],
                stops: [0.4, 0.8],
              ),
            ),
            child: Text('公告',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
          ),

          SizedBox(width: 12,),

          Container(
            child: Text('颜射视频公告',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',color: Color(0xFF000000),fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
          ),
        ],
      ),
    );
    list.add(title);

    // 公告内容
    Widget body = Container(
      margin: EdgeInsets.only(left: 16,top: 16,right: 16),
      alignment: Alignment.centerLeft,
      child: Text('$advoceMsg' ?? '',style: TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Medium',color: Color(0xFF000000),fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
    );

    list.add(
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: body,
        )
    );

    //知道了按钮
    Widget btn = Container(
      margin: EdgeInsets.only(left: 16,top: 24,bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 102.5,vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
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
      child: Text('知道了',style: TextStyle(fontSize: 16,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
    );
    list.add(GestureDetector(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: btn,
    ));

    Widget widget = Container(
      width: 285,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: list,
      ),
    );


    Size size = MediaQuery.of(context).size;
    EdgeInsets ei = MediaQuery.of(context).padding;
    bool isSelect = await showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogUtil(
          marginTop: (size.height + ei.top + ei.bottom - 285)/2,
          content: widget,
          onClose: (){
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
