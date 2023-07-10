import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 广告点击展示页面
 */
class ShowSwiperPage extends StatelessWidget {


  final String imgUrl;

  ShowSwiperPage(this.imgUrl);

  void initData(){

  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height = size.height;
    return Container(
      height: height,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 10,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imgUrl,
            width: width-20,
            height: height - 30,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

}