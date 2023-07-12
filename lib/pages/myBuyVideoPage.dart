import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/MyBuyVideoPagePresenter.dart';
import '../presenter/MyCollectionPresenter.dart';
import '../views/ImageBuyItem.dart';
import '../views/ImageShowItem.dart';
import 'leftSlideActions.dart';


/**
 * 我的收藏
 */
class MyBuyVideoPage extends StatefulWidget{

  @override
  MyBuyVideoPageState createState() => MyBuyVideoPageState();

}

class MyBuyVideoPageState extends BaseState <MyBuyVideoPage,MyBuyVideoPagePresenter>{

  int page = 1;

  int limit = 20;

  List dataList = [];

  ScrollController _scrollController = new ScrollController();

  TextStyle activeStyle = TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold);
  TextStyle inActiveStyle = TextStyle(fontFamily: 'PingFang SC-Medium',fontSize: 16,color: Color(0x80FFFFFF),fontWeight: FontWeight.w400);

  int chooseItem = 1;  // 1 : 长视频 ， 2 : 短视频


  @override
  void initState(){
    requestData();
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        requestData();
      }
    });
  }

  void requestData(){
    mPresenter.getBuyVideos(page++, limit, chooseItem == 1 ? 1 : 2);
  }

  void refreshData(List videoList){
    if(videoList != null && videoList.length > 0){
      dataList.addAll(videoList);
      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> list = [];
    /// 头部
    Widget header = Container(
      margin: EdgeInsets.only(top: 14,left: 14,right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left_outlined),
          ),
          Text('我的购买',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          SizedBox(width: 10,),
        ],
      ),
    );
    list.add(header);

    // Tab
    Widget viewTitle = Container(
      margin: EdgeInsets.only(left: 20,top: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              chooseItem = 1;
              page = 1;
              dataList.clear();
              requestData();
            },
            child: Text('长视频',style: chooseItem == 1 ? activeStyle : inActiveStyle,),
          ),
          /*SizedBox(width: 5,),
          GestureDetector(
            onTap: (){
              chooseItem = 2;
              page = 1;
              dataList.clear();
              requestData();
            },
            child: Text('短视频',style: chooseItem == 2 ? activeStyle : inActiveStyle,),
          ),*/
        ],
      ),
    );
    list.add(viewTitle);

    /// 数据
    Widget view = ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.fromLTRB(20, 32, 35, 30),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
          Map data = dataList[index];
          return Container(
            margin: EdgeInsets.only(top: 16,bottom: 16,),
            child: ImageBuyItem(imgUrl:data['hcover'] == '' ? data['vcover'] : data['hcover'],videoUrl: data['playPath'],videoId: data['videoId'],
                desc:data['title'],showLevel: data['toll'],gold: data['price'],createTime: data['createTime'],videoStartTime: data['videoStartTime'],videoEndTime: data['videoEndTime'],),
          );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 1.0, color: Color(0xFF2E0169));
      },
      // 添加下面这句 内容未充满的时候也可以滚动。
      physics: const AlwaysScrollableScrollPhysics(),
      // 添加下面这句 是为了GridView的高度自适应, 否则GridView需要包裹在固定宽高的容器中。
      //shrinkWrap: true,
    );

    list.add(view);


    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          height: 30,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0x001A0258),
                Color(0xFF3D0363),
              ],
            ),
          ),
        ),
        preferredSize:  Size(MediaQuery.of(context).size.width, 45),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            viewTitle,
            Expanded(child:view),
          ],
        ),
      ),
    );

  }

  @override
  MyBuyVideoPagePresenter createPresenter() {
    return MyBuyVideoPagePresenter();
  }

}