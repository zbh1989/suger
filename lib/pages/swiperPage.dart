import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:caihong_app/pages/showSwiperPage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../base/view/base_state.dart';
import '../presenter/swiperPagePresenter.dart';
import '../utils/toast.dart';

class SwiperPage extends StatefulWidget {

  final double width;

  final double height;

  final bool needFullScreen;

  List imgList = [];

  SwiperPage({this.width,this.height,this.imgList,this.needFullScreen:false,});

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
        margin: widget.needFullScreen ? EdgeInsets.only(top: 0,bottom: 0,left: 0,right: 0,) : EdgeInsets.only(top: 16,bottom: 16,left: 20,right: 20,),
        width: widget.width ?? MediaQuery.of(context).size.width - 40,
        height: widget.height ?? (MediaQuery.of(context).size.width - 40)*9/16,
        decoration: BoxDecoration(
          borderRadius: widget.needFullScreen ? BorderRadius.circular(0) : BorderRadius.circular(16),
        ),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: widget.needFullScreen ? BorderRadius.circular(0) : BorderRadius.circular(20),
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
            var title = widget.imgList[index]["title"];
            if(title == '1'){
              String url = 'https://fds.bjbsst.com';
              canLaunch(url).then((canOpen){
                if(canOpen){
                  launch(url);
                }else{
                  Toast.show('无法打开网页地址: $url');
                }
              });
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return ShowSwiperPage(widget.imgList[index]["img"]);
              }));
            }
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