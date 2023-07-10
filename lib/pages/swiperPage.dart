import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:caihong_app/pages/showSwiperPage.dart';

import '../base/view/base_state.dart';
import '../presenter/swiperPagePresenter.dart';

class SwiperPage extends StatefulWidget {

  final double width;

  final double height;

  List imgList = [];

  SwiperPage({this.width,this.height,this.imgList,});

  @override
  SwiperPageState createState() => SwiperPageState();
}

class SwiperPageState extends BaseState<SwiperPage,SwiperPagePresenter> {

  @override
  void initState(){
    requestData();
    super.initState();
  }

  void requestData() async {
    if(widget.imgList == null || widget.imgList.length <= 0){
      widget.imgList = [];
      mPresenter.getSwipInfo();
    }
  }

  void refreshData(List swipList){
    setState(() {
      widget.imgList.addAll(swipList);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.imgList == null || widget.imgList.length <= 0){
      return Container();
    }

    return Container(
        margin: EdgeInsets.only(top: 16,bottom: 16,left: 20,right: 20,),
        width: widget.width ?? MediaQuery.of(context).size.width - 40,
        height: widget.height ?? (MediaQuery.of(context).size.width - 40)*9/16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(
                widget.imgList[index]["img"],
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: widget.imgList.length,
          pagination: new SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: Colors.black54,
                activeColor: Colors.white,
              )),
          //control: new SwiperControl(),
          scrollDirection: Axis.horizontal,
          autoplay: true,
          duration:200,
          onTap: (index) {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ShowSwiperPage(widget.imgList[index]["img"]);
            }));
          },
        ));
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.network(
        widget.imgList[index]["url"],
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  SwiperPagePresenter createPresenter() {
    return SwiperPagePresenter();
  }

}