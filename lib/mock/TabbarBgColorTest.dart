import 'package:flutter/material.dart';

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
      home: TabbarBgColorTest(),
    );
  }
}


class TabbarBgColorTest extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TabbarBgColorTesttate();
  }
}

class _TabbarBgColorTesttate extends State<TabbarBgColorTest> with SingleTickerProviderStateMixin{
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  final List<String> _tabs = ["新闻", "历史", "图片"];

  String current = '新闻';

  TabController _tabController;
  // PageController _pageController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener((){
      print("selected tabBar ${_tabs[_tabController.index]}");
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> list = [];
    if(_tabs.length > 0){
      _tabs.forEach((e) {
        Widget tab = Container(
          padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6,),
          // height: 40,
          decoration: BoxDecoration(
            color: e == current ? Color(0xFF6205B3) : Color(0xFF2E0169),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(e, style : TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold'),),
        );
        list.add(tab);
      });
    }

    return Scaffold(
        key: _key,
        appBar: AppBar(
            title: Text("ScaffoldTest"),
            //TabBar布置
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Material(
                // color: Colors.green,
                child: TabBar(
                  onTap: (index){
                    setState(() {
                      current = _tabs[index];
                    });
                  },
                  /*indicator: BoxDecoration(
                    color:Color(0xFF6205B3),
                    borderRadius: BorderRadius.circular(20),
                  ),*/
                  // indicator: Decoration(),//选中标签颜色
                  indicatorColor: Colors.black,//选中下划线颜色,如果使用了indicator这里设置无效
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.yellow,
                    labelPadding:EdgeInsets.all(2),
                 /* labelStyle: TextStyle(
                      backgroundColor: Colors.purpleAccent,//Color(0xFF2E0169),
                      fontSize: 20
                  ),*/
                  tabs: list,
                ),
              ),
            )
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((item) => Container(
            color: Colors.blueGrey,
            alignment: AlignmentDirectional.center,
            child: Text(item),
          )).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home)
            ),
            BottomNavigationBarItem(
                label: "Business",
                icon: Icon(Icons.business)
            ),
            BottomNavigationBarItem(
                label: "School",
                icon: Icon(Icons.school)
            )
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.green,
          onTap: (index){
            setState(() {
              _selectedIndex = index;
            });
            print(_selectedIndex);
          },
        )
    );
  }
}