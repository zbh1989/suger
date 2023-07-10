import 'package:flutter/material.dart';
import '../pages/topicDetailPage.dart';


class TopicImg extends StatelessWidget {
  final String imgUrl;

  const TopicImg({
    Key key,
    @required this.imgUrl,
    @required this.imgWidth,
    @required this.imgHeight,
    @required this.topicId,
    this.title,
    this.totalVideo : 0,
  }) : super(key: key);
  final double imgWidth;
  final double imgHeight;
  final int totalVideo;
  final String topicId;
  final String title;

  @override
  Widget build(BuildContext context) {
    Widget widget = Stack(
      alignment: const FractionalOffset(0.0,0.0),//0.5,0.89
      children: <Widget>[
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            imgUrl,
            width: imgWidth,
            height: imgHeight,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          left: -6,
          bottom: -3,
          child: Container(
            height: 24,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(5.0, 3.0, 8.0,0),
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
                margin: EdgeInsets.only(left: 10,bottom: 2),
                child: Text(totalVideo.toString() + '部',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400,),)
              ),
            ),
          ),
        ),
      ],
    );


    return GestureDetector(
      onTap: (){
        print('当前主题ID = ' + topicId?.toString());

        Navigator.push(context, MaterialPageRoute(
            fullscreenDialog: false,
            builder: (context){
              return TopicDetailPage(topicId : topicId,topicHeaderImg: imgUrl,title:title,);
            }
        ));
      },
      child: widget,
    );

  }

}

