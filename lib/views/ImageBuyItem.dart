import 'package:flutter/material.dart';

import '../network/api/network_api.dart';
import '../pages/watchVideoPage.dart';

class ImageBuyItem extends StatelessWidget {
  final String imgUrl;

  const ImageBuyItem({
    Key key,
    @required this.imgUrl,
    @required this.imgWidth,
    @required this.imgHeight,
    @required this.showLevel,
    @required this.videoUrl,
    @required this.videoId,
    this.likeNum,
    this.playNum,
    this.duration,
    this.tags,
    this.createTime,
    this.gold : 0,
    this.desc : '',
    this.favNum,
    this.videoStartTime,
    this.videoEndTime,
  }) : super(key: key);
  final double imgWidth;
  final double imgHeight;
  final int showLevel;
  final int gold;
  final String desc;
  final String videoUrl;
  final String videoId;
  final int likeNum;
  final int playNum;
  final String duration;
  final String tags;
  final String createTime;
  // 收藏次数
  final int favNum;
  final int videoEndTime;
  final int videoStartTime;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF060123),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: const FractionalOffset(0.0,0.0),//0.5,0.89
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  //处理点击事件
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: false,
                      builder: (context) => WatchVideoPage(videoId:videoId,videoUrl: videoUrl,title: desc,likeNum: likeNum,playNum: playNum,duration: duration,tags: tags,createTime: createTime,showLevel: showLevel,gold: gold,favNum: favNum,videoStartTime: videoStartTime,videoEndTime: videoEndTime,),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Image.network(imgUrl,width: imgWidth,height: imgHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                      return Text('Your error widget...');
                    },
                  ),
                ),
              ),

              getShowLevelIcon(showLevel, gold),

              // getShowLevelIcon(1, 30),

            ],
          ),
          SizedBox(width: 20,),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$desc',maxLines: 2  ,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
                  Text('购买金币: $gold' ,style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
                  Text('购买时间: $createTime' ,style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
                ],
              )
          ),
        ],
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

}

