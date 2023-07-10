import 'package:flutter/material.dart';
import '../pages/watchVideoPage.dart';
import '../utils/stringUtils.dart';


class TopicDetailImg extends StatelessWidget {

  const TopicDetailImg({
    Key key,
    @required this.videoId,
    @required this.videoUrl,
    @required this.imgUrl,
    @required this.imgWidth,
    @required this.imgHeight,
    @required this.topicId,
    @required this.showLevel,
    this.gold: 0,
    @required this.duration,
    this.watchTimes: 0,
    this.desc: '',
    this.playNum,
    this.likeNum,
    this.tags,
    this.createTime,
    this.favNum,
    this.videoStartTime,
    this.videoEndTime,
  }) : super(key: key);

  final String videoId;
  final String imgUrl;
  final String videoUrl;
  final double imgWidth;
  final double imgHeight;
  final String topicId;
  final int showLevel;
  final int gold;
  final String duration;
  final int watchTimes;
  final String desc;

  // 点赞数
  final int likeNum;

  // 收藏数
  final int favNum;

  //播放数
  final int playNum;

  // 视频标签;#分割
  final String tags;

  final String createTime;

  final int videoEndTime;

  final int videoStartTime;

  @override
  Widget build(BuildContext context) {
    Widget imgWidget = Stack(
      alignment: const FractionalOffset(0.0,0.0),//0.5,0.89
      children: <Widget>[
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            imgUrl,
            width: imgWidth,
            height: imgHeight,
            fit: BoxFit.cover,
          ),
        ),

        getShowLevelIcon(showLevel, gold),

        Positioned(
          left: -9,
          bottom: -3,
          child: Container(
            height: 32,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,3),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 1],         //[渐变起始点, 渐变结束点]
                    //渐变颜色[始点颜色, 结束颜色]
                    colors: [
                      Color(0xFF000000),
                      Color(0x00000000)]
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                  margin: EdgeInsets.only(left: 10,bottom: 1),
                  child: Text(duration ?? '',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400,),)
              ),
            ),
          ),
        ),

        Positioned(
          right: 5,
          bottom: -3,
          child: Container(
            height: 32,
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,3),
            child: Row(
              children: [
                Icon(Icons.remove_red_eye,size: 12,color: Color(0xFFFFFFFF),),
                SizedBox(width: 5,),
                Text(watchTimes.toString(),style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400,),)
              ],
            ),
          ),
        ),

      ],
    );

    Widget view = Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          imgWidget,

          SizedBox(height: 10,),

          ConstrainedBox(
            constraints:BoxConstraints(maxWidth: imgWidth),
            child: Text( StringUtils.breakWord(desc),
              textAlign:TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 14,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Medium',decoration: TextDecoration.none),
            ),
          ),

        ]);

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            fullscreenDialog: false,
            builder: (context){
              return WatchVideoPage(videoId:videoId,videoUrl: videoUrl,title: desc,likeNum: likeNum,playNum: playNum,duration: duration,tags: tags,createTime: createTime,gold: gold,showLevel: showLevel,favNum:favNum,videoStartTime: videoStartTime,videoEndTime: videoEndTime,);
            }
        ));
      },
      child: view,
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
        left: -2,
        top: 0,
        child: Container(
          width: 46,
          height: 16,
          child: Stack(
            children: [
              Image.asset('lib/assets/images/show_level_icon.png',width: 46,height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/images/gold_icon.png',width: 12,height: 12,),
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

