import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:caihong_app/pages/showSwiperPage.dart';

/**
 * 首页广告创建
 */
class FirstPageAd extends StatelessWidget {

  final int topicId;

  String imgUrl;

  FirstPageAd(this.topicId);

  void initData(){
    imgUrl = 'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg';
  }

  @override
  Widget build(BuildContext context) {
    initData();
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height = (width - 40)*120/335;
    return Container(
      height: height,
      margin: EdgeInsets.only(top: 16,left: 20,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child:Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child:Image.network(imgUrl,
                width: width - 40,
                height: height,
                fit: BoxFit.cover,
              ),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                fullscreenDialog: false,
                builder: (context){
                  return ShowSwiperPage(imgUrl);
                }
              ));
            },
          ),

        ],
      ),
    );
  }

}