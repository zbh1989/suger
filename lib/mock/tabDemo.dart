import 'package:flutter/material.dart';
import 'package:caihong_app/style/MyUnderlineTabIndicator.dart';

import '../pages/searchBar.dart';
import '../pages/swiperPage.dart';
import 'MyTabIndicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabWidget(),
    );
  }
}


class TabWidget extends StatefulWidget {

  @override
  TabWidgetState createState() => TabWidgetState();
}

class TabWidgetState extends State<TabWidget> with  TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  List<String> titleList = [
    '首页1',
    '首页2',
    '首页3',
    '首页4',
    '首页5',
    '首页6',
    '首页7',
    '首页8',
    '首页9'
  ];

  final pages = [
    Text("首页1"),
    Text("首页2"),
    Text("首页3"),
    Text("首页4"),
    Text("首页5"),
    Text("首页6"),
    Text("首页7"),
    Text("首页8"),
    Text("首页9")
  ];


  TabController _tabController;

  List<Widget> list = [];

  @override
  void initState(){
    super.initState();
    _tabController = null;
    _tabController = TabController( initialIndex: 0, length: titleList.length, vsync: this); // 直接传this

    print("---->${_tabController.previousIndex}");

    if (_tabController.indexIsChanging) {
      print("---->indexch");
    }
  }


  @override
  Widget build(BuildContext context) {

    // 搜索框 充值按钮 签到按钮
    Widget searchBar = SearchBar();
    list.add(searchBar);

    /// 轮播图
    list.add(
        Container(
          margin: EdgeInsets.only(top: 16,),
          child: SwiperPage(),
        )
    );


    Widget menu =  Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: MyTabIndicator(),
              tabs: titleList.map((e) {
                return Container(
                  // margin: const EdgeInsets.only(top: 16),
                  padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
                  height: 32,
                  decoration: BoxDecoration(
                    color: e == '首页1' ? Color(0xFF6205B3) : Color(0xFF2E0169),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(e, style : e == '首页1' ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: titleList.isEmpty
                    ? []
                    : titleList.map((f) {
                  return Center(
                    child: new Text("第$f页"),
                  );
                }).toList()),
          ),
        ],
      ),
    );

    list.add(Container(
      height: 40,
      child: menu,
    ));

    return DefaultTabController(
      length: titleList.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF060123), //顶部背景色
          title: searchBar,  // 顶部搜素框（自定义组件）
          bottom: buildPreferredSize(),
        ),
        body: new TabBarView(controller: _tabController, children: pages),//FirstPageItem(),//_listView2(),//_tabBarView(),
      ),
    );

  }

  /*@override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: titleList.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black, //顶部背景色
          bottom: _tabBar(),
        ),
        body: _TabBarView(),//FirstPageItem(),//_listView2(),//_tabBarView(),
      ),
    );
  }*/

  PreferredSize buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size(0, 84),
      // child: buildTabBar(),
      child: buildTheme(),
    );
  }

 /* Widget buildTabBar() {
    List<Widget> list = [];
    titleList.map((e) {
      Widget tab = Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6,),
        // height: 40,
        decoration: BoxDecoration(
          color: e == '首页' ? Color(0xFF6205B3) : Color(0xFF2E0169),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(e, style : e == '首页' ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
      );
      list.add(tab);
    });

    return new TabBar(
      controller: _tabController,
      tabs: list,
      indicatorWeight: 0.1,
    );
  }*/

  Widget buildTabBar() {

    List<Tab> tabList = [];
    for (var value in titleList) {
      tabList.add(Tab(text: value,));
    }

    return new TabBar(
      controller: _tabController,
      tabs: tabList,
      indicatorWeight: 0.1,
    );
  }

  Theme buildTheme() {

    List<Widget> list = [];
    if(titleList.length > 0){
      titleList.forEach((e) {
        Widget tab = Container(
          padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6,),
          // height: 40,
          decoration: BoxDecoration(
            color: e == '首页' ? Color(0xFF6205B3) : Color(0xFF2E0169),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(e, style : e == '首页' ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
        );
        list.add(tab);
      });

    return Theme(
      data: ThemeData(
        ///默认显示的背景颜色
        backgroundColor: Color(0x80FFFFFF),
        ///点击的背景高亮颜色
        highlightColor: Color(0xFFFFFFFF),
        ///点击水波纹颜色
        splashColor: Color.fromRGBO(0, 0, 0, 0),
      ),
      child: titleList.length <= 0 ? Container() : TabBar(
        controller: _tabController,
        tabs: list,
        indicatorWeight: 0.1,
      ),
    );
  }


  TabBarView _TabBarView(){
    List<Widget> pageItem = [];
    titleList.forEach((e) {
      pageItem.add(Text(e));
    });

    return TabBarView(children: pageItem);
  }


  List<Widget> _tabs(){
    List<Widget> list = [];
    titleList.forEach((e) {
      list.add(Container(
        // margin: const EdgeInsets.only(top: 16),
        padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
        height: 32,
        decoration: BoxDecoration(
          color: e == '首页1' ? Color(0xFF6205B3) : Color(0xFF2E0169),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(e, style : e == '首页1' ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
      ));
    });

    return list;
  }


}

  @override
  bool get wantKeepAlive => true;
}