import 'dart:math';

import 'package:caihong_app/views/videoImg.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

import '../base/view/base_state.dart';
import '../pages/watchVideoPage.dart';
import '../presenter/GuessLikePagePresenter.dart';

/**
 * 猜你喜欢
 */
class GuessLikePage extends StatefulWidget {

  GuessLikePage({this.dataList,this.showType,this.player,this.reloadData,});

  final List dataList;

  final int showType;

  final FijkPlayer player;

  final reloadData;

  @override
  GuessLikePageState createState() => GuessLikePageState();

}

class GuessLikePageState extends BaseState<GuessLikePage,GuessLikePagePresenter> {

  bool isLoaded = false;

  List guessLikeVideos = [];


  @override
  void initState(){

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 7.5,top: 18),
            child: Row(
              children: [
                Image.asset('lib/assets/images/title_icon.png',height: 25,width: 5,),
                SizedBox(width: 7.5,),
                Text('猜你喜欢',style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Medium',),),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 20,right: 20,top: 16),
            child: GridView.count(
              //如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
              primary: false,
              //禁止滚动
              physics: NeverScrollableScrollPhysics(),
              //是否允许内容适配
              shrinkWrap: true,
              //水平子Widget之间间距
              crossAxisSpacing: widget.showType == 1 ? 15 : 10,
              //垂直子Widget之间间距
              mainAxisSpacing: 16,
              //GridView内边距
              padding: EdgeInsets.all(0.0),
              //一行的Widget数量  showType: 1 横着放， 2 竖着放
              crossAxisCount: widget.showType == 1 ? 2 : 3,
              //子Widget宽高比例
              childAspectRatio: widget.showType == 1 ? 160/118 : 105/168,
              //子Widget列表
              children:  getWidgetList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getWidgetList(){
    List<Widget> list = [];
    if(widget.dataList != null && widget.dataList.length > 0){
      widget.dataList.forEach((item) {
        list.add(getItemContainer(item));
      });
    }
    return list;
  }

  Widget getItemContainer(Map item) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    double imgWidth = (width - 55)/2; // 默认按照横着放
    double imgHeight = imgWidth * 9/16; // 按照间距 和 宽高比例计算
    if(widget.showType == 2){
      imgWidth = (width - 60)/3; // 竖着放图片的宽度
      imgHeight = imgWidth * 28 / 21;
    }
    String imgUrl = widget.showType == 1 ? item['hcover'] : item['vcover'];
    String duration = item['duration'];
    int showLevel = item['toll'];
    int gold = item['price']??0;
    String desc = item['title'];
    String videoId = item['id'] ?? '0';
    String playPath = item['playPath'];

    // 标题
    String title = item['title'];

    // 点赞数
    int likeNum = item['likeNum'];
    // 收藏数
    int favNum = item['favNum'];

    //播放数
    int playNum = item['playNum'];
    if(playNum == null || playNum == 0){
      playNum = Random().nextInt(20000) + 2000;
    }

    // 视频标签;#分割
    String tags = item['tags'];

    String createTime = item['createTime'];

    int videoStartTime = item['videoStartTime'];

    int videoEndTime = item['videoEndTime'];



    //视频图片
    return VideoImg(imgUrl:imgUrl,imgWidth:imgWidth,imgHeight:imgHeight,duration:duration,showLevel:showLevel,gold: gold,desc:desc,videoId:videoId,playNum: playNum,
        onTapPlayer:(){
          widget.player.release();
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context) => WatchVideoPage(videoId:videoId,videoUrl: playPath,title: title,likeNum: likeNum,playNum: playNum,duration: duration,tags: tags,createTime: createTime,gold: gold,showLevel: showLevel,favNum:favNum,videoStartTime: videoStartTime,videoEndTime: videoEndTime,),
            ),
          );
        }
    );
  }

  @override
  GuessLikePagePresenter createPresenter() {
    return GuessLikePagePresenter();
  }

}