import 'package:caihong_app/pages/searchBar.dart';
import 'package:caihong_app/pages/watchVideoPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/menuTopicPagePresenter.dart';
import '../views/topMenu.dart';
import '../views/videoImg.dart';

/**
 * 顶部菜单专题页面
 */
class MenuTopicPage extends StatefulWidget {

  MenuTopicPage({@required this.menuId,this.menuName,@required this.showType});

  final String menuId;

  final String menuName;

  final int showType;

  @override
  MenuTopPageState createState() => MenuTopPageState();
}

class MenuTopPageState extends BaseState<MenuTopicPage,MenuTopicPagePresenter> with WidgetsBindingObserver{
  int select = 0;
  TabController controller;

  // 当前选中的顶部菜单
  String currentMenuId;

  // 视频和广告板块信息
  List titleList = [];

  // 顶部菜单列表
  List topMenu = [];

  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  int pageNum = 1;

  Future resultFuture = Future(() => null);

  List dataList = [];

  List<Widget> list = [];

  //自定义 RefreshIndicatorState 类型的 Key
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  @override
  void initState(){
    super.initState();

    //必须在组件挂载运行的第一帧后执行，否则 _refreshKey 还没有与组件状态关联起来
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //关键代码，直接触发下拉刷新
      _refreshKey.currentState?.show();
    });

    currentMenuId = widget.menuId;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        initVideoData();
      }
    });

    // initData();
    // initVideoData();
  }

  Future<void> initVideoData() async {
    print(1);
    mPresenter.getVideoList(widget.menuId,widget.menuName,pageNum++,14);
    print(2);
  }

  void refreshVideoData(List videoList){
    if(videoList.length > 0){
      dataList.addAll(videoList);
      if(mounted){
        setState(() {

        });
      }

    }
  }

  void rebuildPage(){
    list.clear();

    // 视频和广告板块
    // 视频主体部分 和广告部分
    list.addAll(getViews());

    list.add(SizedBox(height: 50,));
  }

  @override
  Widget build(BuildContext context) {

    rebuildPage();
  /*  return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index){
          return list[index];
        },
      ),
      resizeToAvoidBottomInset: false,
    );*/

    return RefreshIndicator(
      key: _refreshKey,    //自定义 key，需要通过 key 获取到对应的 State
      onRefresh: initVideoData,
      child: Scaffold(
        body: ListView.builder(
          controller: _scrollController,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index){
            return list[index];
          },
        ),
        resizeToAvoidBottomInset: false,
      )
    );

  }

  List<Widget> getViews(){

    if(dataList.isEmpty || dataList.length <= 0){
      return [];
    }

    List<Widget> rowList = [];
    List rowData = [];
    for(int i = 0; i < dataList.length; i++){
      if(widget.showType == 1){ // 横着放，一行放两个
        if(i % 7 != 0){
          rowData.add(dataList[i]);
          if(rowData.length == 2 || i == (dataList.length - 1)){
            rowList.add(buildRow(rowData,false));
            rowData.clear();
          }
        }else{
          rowData.add(dataList[i]);
          rowList.add(buildRow(rowData,true));
          rowData.clear();
        }
      }else{ // 竖着放，一行放三个
        if(i > 0 && i % 2 != 0){
          rowData.add(dataList[i]);
          if(rowData.length == 2 || i == (dataList.length - 1)){
            rowList.add(buildRow(rowData,false));
            rowData.clear();
          }
        }else{
          rowData.add(dataList[i]);
          if(dataList.length < 2 && i == dataList.length - 1){
            rowList.add(buildRow(rowData,false));
            rowData.clear();
          }
        }
      }
    }
    return rowList;
  }

  // 构建一行视图
  Widget buildRow(List list,bool isMain){ // 横着放大图片，只有showType = 1 为true，其他false
    final size =MediaQuery.of(context).size;
    final width =size.width;
    double imgWidth = (width - 55)/2;  // 横着放图片宽度
    double imgHeight = imgWidth * 9 / 16; // 按照间距 和 宽高比例计算
    double bigImgWidth = width - 40;// 横着放，上面的图片要大图片
    double bigImgHeight = bigImgWidth * 8 / 16; // 横着放，大图片高度
    if(widget.showType == 2){
      imgWidth = (width - 60)/3; // 竖着放图片的宽度
      imgHeight = imgWidth * 28 / 21;

      bigImgWidth = (bigImgWidth - 15)/2;
      bigImgHeight = bigImgWidth * 28 / 21;
    }

    List<Widget> viewList = [];
    list.forEach((data) {
      int showType = data['hcover'] != '' ? 1 : 2;

      int gold = data['price'] ?? 0;
      int showLevel = data['toll'];
      String imgUrl = showType == 1 ? data['hcover'] : data['vcover'];
      String desc = data['title'];
      String videoId = data['id'] ?? '0';
      String playPath = data['playPath'];

      // 标题
      String title = data['title'];

      // 点赞数
      int likeNum = data['likeNum'];

      //播放数
      int playNum = data['playNum'];

      // 时长
      String duration = data['duration'];

      // 视频标签;#分割
      String tags = data['tags'];

      String createTime = data['createTime'];
      // 收藏次数
      int favNum = data['favNum'];

      int videoEndTime = data['videoEndTime'];

      int videoStartTime = data['videoStartTime'];

      // 视频图片
      Widget view = VideoImg(imgUrl:imgUrl,imgWidth:(isMain || widget.showType == 2) ? bigImgWidth : imgWidth,imgHeight:(isMain || widget.showType == 2) ? bigImgHeight : imgHeight,duration:duration,showLevel:showLevel,gold: gold,desc:desc,videoId:videoId,
        onTapPlayer: (){
          //处理点击事件
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context) => WatchVideoPage(videoId:videoId,videoUrl: playPath,title: title,likeNum: likeNum,playNum: playNum,
                duration: duration,tags: tags,createTime: createTime,gold: gold,showLevel: showLevel,favNum: favNum,videoStartTime: videoStartTime,videoEndTime: videoEndTime,),
            ),
          );
        },
      );
      viewList.add(view);
    });

    return Container(
      margin: EdgeInsets.only(top: 16,left: 20,right: 20),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: viewList,
      ),
    );

  }

  @override
  MenuTopicPagePresenter createPresenter() {
    return MenuTopicPagePresenter();
  }


}