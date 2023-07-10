import 'package:caihong_app/pages/searchBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base/view/base_state.dart';
import '../common/constant.dart';
import '../presenter/titlePagePresenter.dart';
import 'firstPageVideoModule.dart';


/**
 * 首页title 模块
 */
class TitlePage extends StatefulWidget{

  TitlePage({this.menuId,});

  final String menuId;

  // final Map menu;

  @override
  TitlePageState createState() => TitlePageState();

}


class TitlePageState extends BaseState <TitlePage,TitlePagePresenter>  with WidgetsBindingObserver{

  // 视频和广告板块信息
  List titleList = [];

  List<Widget> titleWidgetList = [];

  //自定义 RefreshIndicatorState 类型的 Key
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();



  @override
  void initState(){

    requestData();

    //必须在组件挂载运行的第一帧后执行，否则 _refreshKey 还没有与组件状态关联起来
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //关键代码，直接触发下拉刷新
      _refreshKey.currentState?.show();
    });
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  Future<void> requestData() async{
    mPresenter.getTopicList(widget.menuId);
  }

  void refreshPage(List list){
    if(list != null && list.length > 0){
      if(mounted){
        setState(() {

          titleList.addAll(list);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return titleList.length > 0 ?
          RefreshIndicator(
            key: _refreshKey,    //自定义 key，需要通过 key 获取到对应的 State
            onRefresh: requestData,
            child: ListView.builder(
                shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
                physics:NeverScrollableScrollPhysics(),//禁止滚动
                itemCount:titleList.length,
                itemBuilder:(context,index){
                  var title = titleList[index];
                  int limit = title['type'] == 1 ? 5 : 6;
                  Widget pageVideoModule = FirstPageVideoModule(topicId:title['id'],topicImg: title['image'],topic:title['name'],showType:title['type'],pageNum:Constant.first_page_num,limit: limit,);
                  return pageVideoModule;
                }
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    print('********************构建视频模块已经结束************************');
    super.dispose();
  }

  @override
  TitlePagePresenter createPresenter() {
    return TitlePagePresenter();
  }

}