import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:caihong_app/mock/homePageData.dart';
import 'package:caihong_app/pages/swiperPage.dart';
import 'package:caihong_app/common/constant.dart';
import '../style/style.dart';
import 'firstPageAd.dart';
import 'firstPageVideoModule.dart';


class FirstPageItem extends StatefulWidget {

  final int topMenuId;

  FirstPageItem(this.topMenuId);

  @override
  FirstPageItemState createState() => FirstPageItemState();

}


class FirstPageItemState extends State<FirstPageItem> {

  Map<String,dynamic> swiperData;

  List titleList;

  FirstPageItemState();

  @override
  void initState(){
    super.initState();
    initData();
  }

  void initData(){
    // TODO: 发送请求，参数为 topMenuId, 查询当前页面的数据
    titleList = getTitleList(widget.topMenuId);
    // 查询轮播图广告信息
    swiperData = getSwiperInfo();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return _getListView();
  }

  ListView _getListView(){
    List<Widget> list = [];
    final size =MediaQuery.of(context).size;

    // 轮播图开关打开，添加轮播图
    if(swiperData['swiperFlag'] == Constant.swiper_open){
      list.add(Container(
        height: 250,
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(top: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SwiperPage(imgList:swiperData['imgList']),
      ));
    }

    // 加载4大版块
    // 每日推荐   一元秒杀     合集导航      开通会员
    Widget module4 = Container(
      margin: EdgeInsets.only(top: 28,bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          GestureDetector(
            onTap: (){
              print('出发每日推荐事件');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              verticalDirection: VerticalDirection.down,
              children: [
                Container(
                  // color: Colors.red,
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Image.asset('lib/assets/images/recommend.png'),
                  ),
                ),
                SizedBox(height: 10,),
                Text('每日推荐',style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  fontSize: SysSize.big,
                  inherit: true,
                ),)
              ],
            ),
          ),


        GestureDetector(
          onTap: (){
            print('出发一元秒杀事件');
          },
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.ltr,
            verticalDirection: VerticalDirection.down,
            children: [
              Container(
                // color: Colors.red,
                child: Container(
                  width: 70,
                  height: 70,
                  child: Image.asset('lib/assets/images/grocery_card.png'),
                ),
              ),
              SizedBox(height: 10,),
              Text('一元秒杀',style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w400,
                fontSize: SysSize.big,
                inherit: true,
              ),)
            ],
          ),
        ),

          GestureDetector(
            onTap: (){
              print('出发合集导航事件');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              verticalDirection: VerticalDirection.down,
              children: [
                Container(
                  // color: Colors.red,
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Image.asset('lib/assets/images/group.png'),
                  ),
                ),
                SizedBox(height: 10,),
                Text('导航合集',style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  fontSize: SysSize.big,
                  inherit: true,
                ),)
              ],
            ),
          ),


          GestureDetector(
            onTap: (){
              print('出发开通会员事件');
            },
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              verticalDirection: VerticalDirection.down,
              children: [
                Container(
                  // color: Colors.red,
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Image.asset('lib/assets/images/vip_user.png'),
                  ),
                ),
                SizedBox(height: 10,),
                Text('开通会员',style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  fontSize: SysSize.big,
                  inherit: true,
                ),)
              ],
            ),
          ),
        ],
      ),
    );
    list.add(module4);


    // 视频主体部分 和广告部分
    if(titleList.length > 0){
      titleList.forEach((video){
        // 如果是视频板块
        if(video['topicType'] == Constant.topic_type_video){
          // list.add(FirstPageVideoModule(video['topicId'],video['topic'],video['showType'],Constant.first_page_num,null));
        }else{// 广告板块
          list.add(FirstPageAd(video['topicId']));
        }
      });
    }
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: list
    );
  }
}