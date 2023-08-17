import 'dart:math';

import 'package:caihong_app/pages/topicDetailPage.dart';
import 'package:caihong_app/pages/watchVideoPage.dart';
import 'package:caihong_app/views/videoImg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/firstPageVideoModulePresenter.dart';


class FirstPageVideoModule extends StatefulWidget {

  final String topicId;

  final String topic;

  final String topicImg;

  final int showType;

  final int pageNum;

  final int limit;

  final List dataList;


  FirstPageVideoModule({this.topicId,this.topic,this.showType,this.pageNum,this.limit,this.dataList,this.topicImg,});

  @override
  FirtPageVideoModuleState createState() => FirtPageVideoModuleState(topicId,topic,showType,pageNum);

}

class FirtPageVideoModuleState extends BaseState<FirstPageVideoModule,FirstPageVideoModulePresenter>{

  final String topicId;

  final String topic;

  final int showType;

  int pageNum = 1;

  List dataList = [];

  List<Widget> videoList = [];

  Future dataFuture = Future(() => null);

  FirtPageVideoModuleState(this.topicId,this.topic,this.showType,this.pageNum);

  @override
  void initState(){
    requestData();
    super.initState();
    print('加载模块$topic : $topicId');
    // dataList = widget.dataList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void requestData() async {
    mPresenter.getVideoList(widget.topicId, pageNum++, widget.limit);
  }

  void refreshData(List list) {
    if(list != null && list.length > 0){
      dataList.clear();
      videoList.clear();
      dataList.addAll(list);
      if(mounted){
        setState(() { });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(dataList.length > 0){
      buildViews(context);
    }
    return Container(
      child: Column(
        children:videoList.length > 0 ? videoList : [],
      ),
    );

  }



  void buildViews(BuildContext context){
    videoList.clear();
    print('开始构建$topic模块 $pageNum');
    final size =MediaQuery.of(context).size;
    final width = min(size.width,size.height);

    // topic 标题
    Widget topicWidget = Container(
      height: 25,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(left: 7.5,right: 20,top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('lib/assets/images/title_icon.png',height: 25,width: 5,),
              SizedBox(width: 7.5,),
              Text(this.topic,style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Medium',),),
            ],
          ),
          GestureDetector(
            child: Row(
              children: [
                Text("更多",style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14.0,fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Medium',),),
                SizedBox(width: 3,),
                Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
              ],
            ),
            onTap: (){
              print('点击更多' + this.topicId.toString());
              Navigator.push(context, MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context){
                    return TopicDetailPage(topicId:topicId,showType: showType,topicHeaderImg: widget.topicImg,);
                  }
              ));
            },
          ),
        ],
      ),
    );
    videoList.add(topicWidget);

    // 视频图片模块
    if(dataList != null && dataList.length > 0){
      videoList.addAll(getViews());
    }


    // 切换按钮，更多按钮
    Widget toggleWidget = Container(
      margin: EdgeInsets.only(top: 16,left: 20,right: 20),
      // color: Colors.red,
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              requestData();
            },
            child: Container(
              width:(width - 55)/2,
              padding: EdgeInsets.only(top: 8,bottom: 8,left: 43,right: 43),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Color(0x33AC5AFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/images/fresh.png',width: 24,height: 24,),
                  SizedBox(width: width*8/375,),
                  Text('换一批',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(
                      0xFFAC5AFF)),),
                ],
              ),
            ),
          ),


          GestureDetector(
            onTap: (){
              print('更多');
              Navigator.push(context, MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context){
                    return TopicDetailPage(topicId:topicId,showType: showType,topicHeaderImg: widget.topicImg,);
                  }
              ));
            },
            child: Container(
              width:(width - 55)/2,
              padding: EdgeInsets.only(top: 8,bottom: 8,left: 43,right: 43),
              // margin: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Color(0x33AC5AFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/images/player_pause.png',width: 24,height: 24,),
                  SizedBox(width: width*8/375,),
                  Text('看更多',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFFAC5AFF)),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    videoList.add(toggleWidget);

    print('构建$topic模块完成，视频数量 ' + videoList.length.toString());
  }


  List<Widget> getViews(){

    if(dataList.isEmpty || dataList.length <= 0){
      return [];
    }

    List<Widget> rowList = [];
    List rowData = [];
    for(int i = 0; i < dataList.length; i++){
      if(showType == 1){ // 横着放，一行放两个
        if(i == 0){
          rowData.add(dataList[i]);
          rowList.add(buildRow(rowData,true));
          rowData.clear();
        }else{
          if(i % 2 != 1){
            rowData.add(dataList[i]);
            if(rowData.length == 2 || i == (dataList.length - 1)){
              rowList.add(buildRow(rowData,false));
              rowData.clear();
            }
          }else{
            rowData.add(dataList[i]);
            if(dataList.length < 3 && i == dataList.length - 1){
              rowList.add(buildRow(rowData,false));
              rowData.clear();
            }
          }
        }
      }else{ // 竖着放，一行放三个
        if(i > 0 && i % 3 != 0){
          rowData.add(dataList[i]);
          if(rowData.length == 3 || i == (dataList.length - 1)){
            rowList.add(buildRow(rowData,false));
            rowData.clear();
          }
        }else{
          rowData.add(dataList[i]);
          if(dataList.length < 3 && i == dataList.length - 1){
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
    final width =min(size.width,size.height);
    double imgWidth = (width - 55)/2;  // 横着放图片宽度
    double imgHeight = imgWidth * 9 / 16; // 按照间距 和 宽高比例计算
    double bigImgWidth = width - 40;// 横着放，上面的图片要大图片
    double bigImgHeight = bigImgWidth * 8 / 16; // 横着放，大图片高度
    if(showType == 2){
      imgWidth = (width - 60)/3; // 竖着放图片的宽度
      imgHeight = imgWidth * 28 / 21;
    }

    List<Widget> viewList = [];
    list.forEach((data) {

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
      if(playNum == null || playNum == 0){
        playNum = Random().nextInt(20000) + 2000;
      }

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
      Widget view = VideoImg(imgUrl:imgUrl,imgWidth:isMain ? bigImgWidth : imgWidth,imgHeight:isMain ? bigImgHeight : imgHeight,duration:duration,showLevel:showLevel,gold: gold,desc:desc,videoId:videoId,playNum: playNum,
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

  // 读取图片上标记 VIP， 免费， 金币
  Widget getShowLevelIcon(int showLevel,int gold){
    Widget iconWidget = Positioned(left: 0,top: 0,);
    if(showLevel == 1){
      iconWidget = Positioned(
        left: -4,
        top: -1,
        child: Container(
          width: 43,
          height: 19,
          child: Container(
              child: Image.asset('lib/assets/images/free_show_level.png')
          ),
        ),
      );
    }else if(showLevel == 2){
      iconWidget = Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: 39,
          height: 16,
          child: Stack(
            children: [
              Image.asset('lib/assets/images/show_level_icon.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/images/gold_icon.png',width: 12,height: 12,),
                  SizedBox(width: 2,),
                  Text(gold.toString(),style: TextStyle(fontSize: 12,color: Color(0xFF7E3B0C),fontWeight: FontWeight.w500,),)
                ],
              ),
            ],
          ),
        ),
      );

    }else if(showLevel == 3){
      iconWidget = Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: 39,
          height: 16,
          child: Container(
              child: Image.asset('lib/assets/images/vip_show_level.png')
          ),
        ),
      );
    };
    return iconWidget;
  }

  @override
  FirstPageVideoModulePresenter createPresenter() {
    return FirstPageVideoModulePresenter();
  }

}