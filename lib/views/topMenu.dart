
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../mock/MyTabIndicator.dart';
import '../pages/homePage.dart';
import '../presenter/TopMenuPagePresenter.dart';

class TopMenu extends StatefulWidget {

  TopMenu({this.currentMenuId,this.currentMenuName,this.activeMenu,this.topMenu,this.tabController,});

  // 当前选中的顶部菜单
  String currentMenuId;
  String currentMenuName;

  ValueChanged activeMenu;

  List topMenu = [];

  TabController tabController;

  @override
  TopMenuState createState() => TopMenuState();

}

class TopMenuState extends BaseState<TopMenu,TopMenuPagePresenter>{



 /* @override
  void initState(){
    super.initState();
    _tabController = null;
    _tabController = TabController( initialIndex: 0, length: titleList.length, vsync: this); // 直接传this

    print("---->${_tabController.previousIndex}");

    if (_tabController.indexIsChanging) {
      print("---->indexch");
    }
  }*/

  @override
  void initState(){
    // requestData();
    super.initState();
  }

  /*void requestData() async {
    mPresenter.getMenuList();
  }

  void refreshData(List menuList){
    widget.currentMenuId == null ? widget.currentMenuId = menuList[0]['id'] : widget.currentMenuId;
    setState(() {
      _tabController = TabController( initialIndex: 0, length: menuList.length, vsync: this);
      topMenu.addAll(menuList);
    });
  }*/

  @override
  Widget build(BuildContext context) {

    return TabBar(
      controller: widget.tabController,
      isScrollable: true,
      indicator: MyTabIndicator(),
      labelPadding: EdgeInsets.only(left: 0, right: 8),
      tabs: widget.topMenu.map((e) {
        return Container(
          // margin: const EdgeInsets.only(top: 16),
          padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6,),
          // height: 40,
          decoration: BoxDecoration(
            color: e['id'] == widget.currentMenuId ? Color(0xFF6205B3) : Color(0xFF2E0169),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(e['name'], style : e['id'] == widget.currentMenuId ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
        );
      }).toList(),
    );

    /*return Container(
      margin: EdgeInsets.only(top: 16,left: 20,right: 20),
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: widget.tabController,
        isScrollable: true,
        indicator: MyTabIndicator(),
        labelPadding: EdgeInsets.only(left: 0, right: 8),
        tabs: widget.topMenu.map((e) {
          return Container(
            // margin: const EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6,),
            // height: 40,
            decoration: BoxDecoration(
              color: e['id'] == widget.currentMenuId ? Color(0xFF6205B3) : Color(0xFF2E0169),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(e['name'], style : e['id'] == widget.currentMenuId ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
          );
        }).toList(),
      ),
    );*/

    /*Widget menuWidget = Scaffold(
      body: Column(
        children: [
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: MyTabIndicator(),
              tabs: widget.topMenu.map((e) {
                return Container(
                  // margin: const EdgeInsets.only(top: 16),
                  padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
                  height: 40,
                  decoration: BoxDecoration(
                    color: e['id'] == widget.currentMenuId ? Color(0xFF6205B3) : Color(0xFF2E0169),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(e['name'], style : e['id'] == widget.currentMenuId ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
                );
              }).toList(),
            ),
          ),
          Container(
            height: 400,
            child: TabBarView(
                controller: _tabController,
                children: widget.topMenu.isEmpty
                    ? []
                    : widget.topMenu.map((f) {
                        return Center(
                          child: new Text("第"+f['name']+"页"),
                        );
                      }).toList()
            ),
          )
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(top:16),
      child: menuWidget,
    );*/
  }

  /*@override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    if(topMenu.length > 0){
      topMenu.forEach((element) {
        list.add(
          GestureDetector(
            onTap: (){
              setState(() {
                widget.currentMenuId = element['id'];
                widget.currentMenuName = element['name'];
                widget.activeMenu(widget.currentMenuId);
                Navigator.of(context).push(MaterialPageRoute( // TODO: 这里图片横着放 ，竖着放是要设置变量， 目前写死
                  builder: (cxt) => HomePage(menuId: widget.currentMenuId,menuName: widget.currentMenuName,isHome: topMenu[0]['id'] == element['id'] ? 1 : 2,showType: element['type'] ?? 1,),
                ));
              });
            },
            child: Container(
              // margin: const EdgeInsets.only(top: 16),
              padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
              height: 32,
              decoration: BoxDecoration(
                color: element['id'] == widget.currentMenuId ? Color(0xFF6205B3) : Color(0xFF2E0169),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(element['name'], style : element['id'] == widget.currentMenuId ? TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold') : TextStyle(color: Color(0x80FFFFFF),fontSize: 14,fontWeight: FontWeight.w600),),
            ),
          ),
        );
        // 设置每个菜单之间的间距
        list.add(SizedBox(width: 8,));
      });
    }

    return Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 16),
      color: Color(0xFF060123),
      child: LayoutBuilder(
          builder: (BuildContext context,BoxConstraints constraints){
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: list,
              ),
            );
          }
      ),
    );
  }*/

  @override
  createPresenter() {
    return TopMenuPagePresenter();
  }

}