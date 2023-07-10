import 'dart:math';

import 'package:flutter/material.dart';

import '../base/view/base_state.dart';
import '../presenter/videoOperationPresenter.dart';

/**
 * 视频播放页面操作（点赞，收藏，下载，线路切换）
 */
class VideoOperation extends StatefulWidget {

  VideoOperation({this.isCollect,this.isFavorite,this.favoriteTotal,this.collectTotal,this.level,this.videoId});

  // 是否对此视频点过赞
  int isFavorite;

  // 此视频点赞总数
  String favoriteTotal;

  // 是否对此视频收藏过
  int isCollect;

  // 此视频收藏总数
  String collectTotal;

  // 当前用户等级 (1,普通用户，2,金币用户 3，VIP用户)
  int level;

  final String videoId;

  @override
  VideoOperationState createState() => VideoOperationState();

}

class VideoOperationState extends BaseState<VideoOperation,VideoOperationPresenter>{

  @override
  void initState(){
    super.initState();
    requestData();
  }

  void requestData(){
    mPresenter.query(widget.videoId, 1);
    mPresenter.query(widget.videoId, 3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 29),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.ltr,
            verticalDirection: VerticalDirection.down,
            children: [
              GestureDetector(
                child: Image.asset(widget.isFavorite == 1 ? 'lib/assets/images/favorite_red.png' : 'lib/assets/images/favorite_white.png',width: 30,height: 30,),
                onTap: (){
                  if(widget.isFavorite == 1){
                    mPresenter.cancel(widget.videoId, 1);
                    widget.favoriteTotal = (int.parse(widget.favoriteTotal == null ? 1 : widget.favoriteTotal) - 1).toString();
                  }else{
                    mPresenter.update(widget.videoId, 1);
                    widget.favoriteTotal = (int.parse(widget.favoriteTotal == null ? 0 : widget.favoriteTotal) + 1).toString();
                  }
                },
              ),
              SizedBox(height: 7,),
              Text(widget.favoriteTotal,style: TextStyle(fontSize: 12,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400),)
            ],
          ),


          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.ltr,
            verticalDirection: VerticalDirection.down,
            children: [
              GestureDetector(
                child: Image.asset(widget.isCollect == 1 ? 'lib/assets/images/star_yellow.png' : 'lib/assets/images/star_white.png',width: 30,height: 30,),
                onTap: (){
                  if(widget.isCollect == 1){
                    mPresenter.cancel(widget.videoId, 3);
                    widget.collectTotal = (int.parse(widget.collectTotal == null ? 1 : widget.collectTotal) - 1).toString();
                  }else{
                    mPresenter.update(widget.videoId, 3);
                    widget.collectTotal = (int.parse(widget.collectTotal == null ? 0 : widget.collectTotal) + 1).toString();
                  }
                },
              ),
              SizedBox(height: 7,),
              Text(widget.collectTotal,style: TextStyle(fontSize: 12,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400),)
            ],
          ),


          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.ltr,
            verticalDirection: VerticalDirection.down,
            children: [
              Image.asset('lib/assets/images/cache_down_load.png',width: 30,height: 30,),
              SizedBox(height: 7,),
              Text('缓存下载',style: TextStyle(fontSize: 12,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400),)
            ],
          ),


          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.ltr,
            verticalDirection: VerticalDirection.down,
            children: [
              Image.asset('lib/assets/images/switch.png',width: 30,height: 30,),
              SizedBox(height: 7,),
              Text(widget.level == 3 ? 'VIP线路' : '普通路线',
                style: TextStyle(fontSize: 12,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400),
              )
            ],
          ),

        ],
      ),
    );
  }

  void refreshPage(int bizType,bool res){
    if(mounted){
      if(bizType == 1 && res != null){
        widget.isFavorite = res ? 1 : 2;
        if(res && widget.favoriteTotal == '0'){
          widget.favoriteTotal = Random().nextInt(1000).toString();
        }
      }else if(bizType == 3 && res != null){
        widget.isCollect = res ? 1 : 2;
        if(res && widget.collectTotal == '0'){
          widget.collectTotal = Random().nextInt(1000).toString();
        }
      }
      setState(() { });
    }
  }

  @override
  VideoOperationPresenter createPresenter() {
    return VideoOperationPresenter();
  }

}