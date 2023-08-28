import 'package:caihong_app/pages/searchBar.dart';
import 'package:caihong_app/pages/swiperPage.dart';
import 'package:caihong_app/pages/titlePage.dart';
import 'package:caihong_app/presenter/newFirstPagePresenter.dart';
import 'package:caihong_app/views/topMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../mock/MyTabIndicator.dart';
import 'menuTopicPage.dart';

/**
 * 新版首页
 */
class NewFirstPage extends StatefulWidget {

  NewFirstPage({this.menuId,this.showType,});

  final String menuId;

  final int showType;

  @override
  NewFirstPageState createState() => NewFirstPageState();
}

class NewFirstPageState extends BaseState<NewFirstPage,NewFirstPagePresenter>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int select = 0;
  TabController controller;

  // 顶部菜单列表
  List topMenu = [];

  // 当前选中的顶部菜单
  String currentMenuId;

  // 视频和广告板块信息
  List titleList = [];

  List swipInfoList = [];

  List<Widget> list = [];

  Future resultFuture = Future.value(null);
  Future menuAndTopicFuture = Future.value(null);
  bool isLoading = false;


  Future switchFuture;

  List<Widget> titleVideoList = [];

  Function callback;

  Function onErrorCallback;

  TabController _tabController;

  //自定义 RefreshIndicatorState 类型的 Key
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  @override
  void initState(){
    //必须在组件挂载运行的第一帧后执行，否则 _refreshKey 还没有与组件状态关联起来
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //关键代码，直接触发下拉刷新
      _refreshKey.currentState?.show();
    });
    requestData();
    super.initState();
  }

  void requestData() async {
    mPresenter.getMenuList();
  }

  void refreshData(List menuList){
    if(currentMenuId == null){
      currentMenuId = menuList[0]['id'];
    }
    setState(() {
      _tabController = TabController( initialIndex: 0, length: menuList.length, vsync: this);
      topMenu.addAll(menuList);
    });
  }

  /*Future<void> initData() async{
    try{
      swipInfoList.clear();
      topMenu.clear();
      list.clear();
      titleList.clear();
      titleVideoList.clear();

      await Future.wait([
        initSwipInfoData().then((swipList){
          swipInfoList.addAll(swipList);
        }),
        initMenuInfoData().then((menuList){
          currentMenuId = widget.menuId ?? menuList[0]['id'];
          topMenu.addAll(menuList);
        }),
      ]).then((results){

            // 搜索框 充值按钮 签到按钮
            Widget searchBar = SearchBar();
            list.add(searchBar);

            // 菜单按钮
            // Widget menuTabs = _newTabs();
            Widget menuTabs = TopMenu(currentMenuId: currentMenuId,);
            list.add(menuTabs);

            // 轮播图
            // 轮播图开关打开，添加轮播图
            Widget swiper;
            if(swipInfoList != null){
              List<Map> imgList = [];
              swipInfoList.forEach((element) {
                imgList.add({'url':element['img']});
              });
              swiper = Container(
                height: (MediaQuery.of(context).size.width - 40)*9/16,
                margin: EdgeInsets.only(top: 16,left: 20,right: 20),
                child: SwiperPage(),
              );
              list.add(swiper);
            }

            // 加载4大版块
            // 每日推荐   一元秒杀     合集导航      开通会员
            // list.add(getModule4());


            // 视频图片块
            Future.wait([
              initTopicData(currentMenuId).then((titleResult){
                titleList.addAll(titleResult);
              }),
            ]).then((res){
                if(titleList.length > 0){

                  List<Future> tempFutureList = [];
                  titleList.forEach((video){
                    int limit = video['type'] == 1 ? 5 : 6;
                    Future f = mPresenter.getVideoList(video['id'], 1, limit).then((videoList){
                      list.add(FirstPageVideoModule(topicId:video['id'],topicImg: video['image'],topic:video['name'],showType:video['type'],pageNum:Constant.first_page_num,limit: limit,dataList: videoList,));
                    });
                    tempFutureList.add(f);
                  });

                  Future.wait(tempFutureList).then((res){
                    setState(() {
                      print(list.length);
                    });
                  });

                };
            });
        }).catchError((err){
          print(err);
        });
    }catch(e){
      print('请求接口异常：$e');
    }
  }
*/


  @override
  Widget build(BuildContext context) {
    super.build(context);
    list.clear();

    // 搜索框 充值按钮 签到按钮
    Widget searchBar = SearchBar();
    list.add(searchBar);

    Widget menuWidget = TabBar(tabs: [],);

    if(topMenu != null && topMenu.length > 0){
      /// 菜单
      menuWidget = TopMenu(currentMenuId: currentMenuId,activeMenu: (menuId){
        setState(() {
          currentMenuId = menuId;
        });
      },topMenu: topMenu,tabController: _tabController,);

      list.add(menuWidget);
    }

    /// 轮播图
    // titlePageList.add(SwiperPage());


    List<Widget> pageItemList = [];
    if(topMenu != null && topMenu.length > 0){


      topMenu.forEach((menu) {

        bool isMain = topMenu[0]['id'] == menu['id'];

        List<Widget> titlePageList = [];

        Widget titlePage;
        if(isMain){
          titlePageList.add(SwiperPage());
          titlePage = TitlePage(menuId:menu['id'],);

          titlePageList.add(titlePage);
          titlePageList.add(SizedBox(height: 30,));

          Widget pageView = ListView.builder(
              itemCount: titlePageList.length,
              itemBuilder: (ctx,index){
                return titlePageList[index];
              }
          );
          pageItemList.add(pageView);

        }else{
          titlePage = MenuTopicPage(menuId: menu['id'],menuName:menu['name'],showType: menu['type'],);
          pageItemList.add(titlePage);
        }
      });
    }

    TabBarView tabView = TabBarView(
      controller: _tabController,
      children: pageItemList
    );

    list.add(SizedBox(height: 30,));

    return DefaultTabController(
      length: topMenu.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF060123), //顶部背景色
          title: searchBar,  // 顶部搜素框（自定义组件）
          // bottom: buildPreferredSize(),
          bottom: TabBar(
            padding: EdgeInsets.only(left: 18,right: 18,),
            controller: _tabController,
            onTap: (index){
              setState(() {
                currentMenuId = topMenu[index]['id'];
              });
            },
            isScrollable: true,
            indicator: MyTabIndicator(),
            labelPadding: EdgeInsets.only(left: 0, right: 8),
            tabs: topMenu.map((e) {
              return Container(
                padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6,),
                // height: 40,
                decoration: BoxDecoration(
                  color: e['id'] == currentMenuId ? Color(0xFF6205B3) : Color(0xFF2E0169),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(e['name'], style : e['id'] == currentMenuId ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
              );
            }).toList(),
          ),
        ),
        body: tabView,//FirstPageItem(),//_listView2(),//_tabBarView(),
      ),
    );

  }

  Widget getModule4(){
    // 每日推荐   一元秒杀     合集导航      开通会员
    Widget module4 = Container(
      margin: EdgeInsets.only(top: 16,left:26,right: 27.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              print('出发每日推荐事件');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              verticalDirection: VerticalDirection.down,
              children: [
                Container(
                  // color: Colors.red,
                  child: Container(
                    width: 55,
                    height: 55,
                    child: Image.asset('lib/assets/images/recommend.png'),
                  ),
                ),
                SizedBox(height: 8,),
                Text('每日推荐',style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'PingFang SC-Medium',
                ),)
              ],
            ),
          ),


          GestureDetector(
            onTap: (){
              print('出发一元秒杀事件');
            },
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              verticalDirection: VerticalDirection.down,
              children: [
                Container(
                  // color: Colors.red,
                  child: Container(
                    width: 55,
                    height: 55,
                    child: Image.asset('lib/assets/images/grocery_card.png'),
                  ),
                ),
                SizedBox(height: 8,),
                Text('一元秒杀',style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'PingFang SC-Medium',
                ),)
              ],
            ),
          ),

          GestureDetector(
            onTap: (){
              print('出发合集导航事件');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              verticalDirection: VerticalDirection.down,
              children: [
                Container(
                  // color: Colors.red,
                  child: Container(
                    width: 55,
                    height: 55,
                    child: Image.asset('lib/assets/images/group.png'),
                  ),
                ),
                SizedBox(height: 8,),
                Text('导航合集',style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'PingFang SC-Medium',
                ),)
              ],
            ),
          ),


          GestureDetector(
            onTap: (){
              print('出发开通会员事件');
            },
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              verticalDirection: VerticalDirection.down,
              children: [
                Container(
                  // color: Colors.red,
                  child: Container(
                    width: 55,
                    height: 55,
                    child: Image.asset('lib/assets/images/vip_user.png'),
                  ),
                ),
                SizedBox(height: 8,),
                Text('开通会员',style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'PingFang SC-Medium',
                ),)
              ],
            ),
          ),
        ],
      ),
    );
    return module4;
  }

  /// 公告弹窗
  /*void showAdvoce(String advoceMsg,bool isLoaded) async {

    if(isLoaded){
      return;
    }
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
            child: Text('夜啪啪公告',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',color: Color(0xFF000000),fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
          ),
        ],
      ),
    );
    list.add(title);

    // 公告内容
    Widget body = Container(
      margin: EdgeInsets.only(left: 16,top: 16,right: 16),
      alignment: Alignment.centerLeft,
      child: Text(advoceMsg ?? '',style: TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Medium',color: Color(0xFF000000),fontWeight: FontWeight.w400,decoration: TextDecoration.none,),),
    );

    list.add(
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: body,
        )
    );

    //知道了按钮
    Widget btn = GestureDetector(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: Container(
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
      ),
    );
    list.add(btn);

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

    bool isSelect = await showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogUtil(
          content: widget,
          onClose: (){
            Navigator.of(context).pop();
          },
        );
      },
    );

    print(isSelect);
  }*/

  @override
  NewFirstPagePresenter createPresenter() {
    return NewFirstPagePresenter();
  }

  @override
  bool get wantKeepAlive => true;

}