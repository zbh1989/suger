import 'package:caihong_app/mock/homePageData.dart';
import 'package:caihong_app/pages/searchBar.dart';
import 'package:caihong_app/style/MyUnderlineTabIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'firstPageItem.dart';

/**
 * 首页
 * 布局页面
 */
RefreshController _refreshController = RefreshController(initialRefresh: true);

void _onRefresh() async {
  // monitor network fetch
  await Future.delayed(Duration(milliseconds: 1000));
  // if failed,use refreshFailed()
  _refreshController.refreshCompleted();
}

void _onLoading() async {
  // monitor network fetch
  await Future.delayed(Duration(milliseconds: 1000));
  _refreshController.loadComplete();
}

@override
void dispose() {
  // TODO: implement dispose
  _refreshController.dispose();
}

//首页
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

BuildContext _buildContext;

class _FirstPageState extends State<FirstPage> {
  int select = 0;
  TabController controller;
  List topMenu;

  @override
  void initState(){
    super.initState();

    initData();
  }

  void initData(){
    // 发送请求，查询顶部导航菜单 TODO:
    topMenu = getTopMenu();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black, //顶部背景色
          title: SearchBar(),  // 顶部搜素框（自定义组件）
          bottom: _tabBar(),
        ),
        body: _TabBarView(),//FirstPageItem(),//_listView2(),//_tabBarView(),
      ),
    );
  }

  TabBarView _TabBarView(){
    List<Widget> pageItem = [];
    if(topMenu.length > 0){
      topMenu.forEach((e){
        pageItem.add(FirstPageItem(e['menuId']));
      });
    }
    return TabBarView(children: pageItem);
  }


  TabBar _tabBar(){
    return TabBar(
      labelColor: Colors.blue,  //选中时颜色
      unselectedLabelColor: Colors.white, //未选中时颜色
      indicatorColor: Colors.red,
      indicatorWeight: 2.0,
      indicator: MyUnderlineTabIndicator(
          borderSide: BorderSide(width: 2.0, color: Colors.red)),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.zero,
      tabs: _tabs(),
      labelStyle: TextStyle(
        color: Color(0xEC20AD10),
        fontSize: 14,
        backgroundColor:Color(0xE107070F),
      ),
    );
  }

  List<Widget> _tabs(){
    List<Widget> list = [];
    if(topMenu.length > 0){
      topMenu.forEach((e) {
        list.add(Tab(text: e['menuName'],));
      });
    }
    return list;
  }
}




