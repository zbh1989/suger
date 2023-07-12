import 'dart:math';

import 'package:flutter/material.dart';
import '../utils/stringUtils.dart';

class VideoImg extends StatelessWidget {
  final String imgUrl;

  const VideoImg({
    Key key,
    @required this.imgUrl,
    @required this.imgWidth,
    @required this.imgHeight,
    this.duration : '',
    @required this.showLevel,
    @required this.videoId,
    this.gold : 0,
    this.desc : '',
    this.onTapPlayer,
    this.playNum:27876
  }) : super(key: key);
  final double imgWidth;
  final double imgHeight;
  final String duration;
  final int showLevel;
  final int gold;
  final String desc;
  final String videoId;
  final Function onTapPlayer; // 点击播放视频回调
  final int playNum;

  @override
  Widget build(BuildContext context) {
    Widget imgWidget = Stack(
      alignment: const FractionalOffset(0.0,0.0),//0.5,0.89
      children: <Widget>[
        Container(
          width: imgWidth,
          height: imgHeight,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(width: 0,color: Color(0xFF060123)),
            // border: BoxBorder.,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            imgUrl,
            width: imgWidth,
            height: imgHeight,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
              return Opacity(
                opacity: 0.3,
                child: Image.asset('lib/assets/images/logo.png',width: imgWidth * 0.5,height: imgHeight * 0.5,),
              );
            },
          ),
        ),

        getShowLevelIcon(showLevel, gold),

        Positioned(
          right: 5,
          bottom: -5,
          child: Container(
            height: 32,
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,3),
            child: Row(
              children: [
                Icon(Icons.remove_red_eye,size: 12,color: Color(0xFFFFFFFF),),
                SizedBox(width: 5,),
                Text((Random().nextInt(1000) + playNum).toString(),style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400,),)
              ],
            ),
          ),
        ),

        Positioned(
          left: -8,
          bottom: -6,
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0,3),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 1],         //[渐变起始点, 渐变结束点]
                    //渐变颜色[始点颜色, 结束颜色]
                    colors: [Color(0xFF000000), Color(0x00000000)]
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: EdgeInsets.only(left: 8,bottom: 1),
                child: Text(duration ?? '',style: TextStyle(fontSize: 8,fontFamily: 'Inter V-Regular',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400,),)
              ),
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

          SizedBox(height: 8,),

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
      onTap: onTapPlayer.call,
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

