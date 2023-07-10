import 'package:caihong_app/style/style.dart';
import 'package:caihong_app/views/tiktokTabBar.dart';
import 'package:flutter/material.dart';

class BottomText extends StatelessWidget {
  const BottomText({
    Key key,
    this.isSelect: true,
    this.tag,

  }) : super(key: key);

  final bool isSelect;
  final TikTokPageTag tag;

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> data = getImgUrl(tag, isSelect);
    print(data);
    return Container(
      // padding: EdgeInsets.only(top: 7),
      margin: EdgeInsets.only(top:7,bottom: 4),
      color: Colors.black.withOpacity(0),
      child: Column(
        children: [
          Image.asset(data['imgUrl'],width: 23,height: 23,),
          SizedBox(height: 4,),
          Text(
            data['title'] ?? '??',
            textAlign: TextAlign.center,
            style:
            isSelect ? TextStyle(fontSize: 10,color: Color(0xFFAC5AFF),fontWeight: FontWeight.w400)
                : TextStyle(fontSize: 10,color: Color(0x80FFFFFF),fontWeight: FontWeight.w400)
          )
        ],
      ),
    );
  }
}

/**
 * 获取首页底部导航图标
 */
Map<String,dynamic> getImgUrl(TikTokPageTag tag,bool isSelect){
  String imgUrl;
  String title;
  double imgWidth;
  double imgHeight;
  switch(tag){
    case TikTokPageTag.firstPage:
      imgUrl = isSelect ? 'lib/assets/images/home_2_active.png' : 'lib/assets/images/home_2_inactive.png';
      title = '首页';
      imgWidth = 18.83;
      imgHeight = 17.23;
      break;
    case TikTokPageTag.shortVideo:
      imgUrl = isSelect ? 'lib/assets/images/short_video_2_active.png' : 'lib/assets/images/short_video_2_inactive.png';
      title = '短视频';
      imgWidth = 19.26;
      imgHeight = 11.56;
      break;
    case TikTokPageTag.topic:
      imgUrl = isSelect ? 'lib/assets/images/topic_2_active.png' : 'lib/assets/images/topic_2_inactive.png';
      title = '专题';
      imgWidth = 14.96;
      imgHeight = 14.96;
      break;
    case TikTokPageTag.find:
      imgUrl = isSelect ? 'lib/assets/images/find_2_active.png' : 'lib/assets/images/find_2_inactive.png';
      title = '发现';
      imgWidth = 18.33;
      imgHeight = 18.33;
      break;
    case TikTokPageTag.me:
      imgUrl = isSelect ? 'lib/assets/images/mine_2_active.png' : 'lib/assets/images/mine_2_inactive.png';
      title = '我的';
      imgWidth = 17.74;
      imgHeight = 18.75;
      break;
  }

  return {'imgUrl':imgUrl,'title':title,'imgWidth':imgWidth,'imgHeight':imgHeight};
}
