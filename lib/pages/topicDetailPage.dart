import 'package:caihong_app/presenter/TopicDetailPagePresenter.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';

import '../views/topicDetailImg.dart';

/**
 * 专题明细页面
 */
class TopicDetailPage extends StatefulWidget {

  final String topicId;

  final String topicHeaderImg;

  final String title;

  final int showType;

  TopicDetailPage({@required this.topicId,this.topicHeaderImg,this.title,this.showType : 1,});

  @override
  TopicDetailPageState createState() => TopicDetailPageState();

}

class TopicDetailPageState extends BaseState<TopicDetailPage,TopicDetailPagePresenter>{

  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  int pageNum = 1;

  final int limit = 20;

  List dataList = [];

  @override
  void initState() {
    requestData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        requestData();
      }
    });
  }

  void requestData() {
    mPresenter.getTopicDetailList(pageNum++, limit, widget.topicId);
    /*Future.wait([
      mPresenter.getTopicDetailList(pageNum++, limit, widget.topicId).then((videoList){
        dataList.addAll(videoList);
      })
    ]).then((videoList){
      setState(() {

      });
    }).catchError((e){
      print('查询专题明细异常：$e');
    });*/
  }

  void refreshData(List videoList) {
    dataList.addAll(videoList);
    setState(() {

    });

    /*setState(() {
      isLoading = false;
      headerImg = topicDetailInfo['headerImg'];
      title = topicDetailInfo['title'];
      if(topicDetailInfo['detailList'].length > 0){
        dataList.addAll(topicDetailInfo['detailList']);
      }
    });*/

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> list = [];

    Widget headerTopic = Container(
      child: Image.network(
        widget.topicHeaderImg,
        width: MediaQuery.of(context).size.width,
        height: 211,
        fit: BoxFit.cover,
      ),
    );

    list.add(Stack(
      children: [
        headerTopic,
        Positioned(
          left: 5,
          top: 5,
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.black87,
              child: Icon(Icons.chevron_left_outlined,),
            ),
          ),
        ),
      ],
    ));

    list.add(Container(
      margin: EdgeInsets.only(top: 18,left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('lib/assets/images/movie.png',width: 24,height: 24,),
          SizedBox(width: 12,),
          Text(widget.title ?? '',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold'),)
        ],
      ),
    ));

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double imgWidth = width - 39;
    double imgHeight = imgWidth * 189 / 336;
    if(widget.showType == 2){
      imgWidth = (imgWidth - 15)/2;
      imgHeight = imgWidth*140/105;
    }

    List rowData = [];

    for(int i = 0; i < dataList.length; i++){
      if(widget.showType == 1){
        list.add(SizedBox(height: 16,));
        Map<String,dynamic> data = dataList[i];

        String imgUrl = dataList[i]['hcover'] ?? dataList[i]['vcover'];
        Widget topicWidget = TopicDetailImg(videoId:data['id'],videoUrl:data['playPath'],imgUrl:imgUrl,imgWidth: imgWidth,imgHeight: imgHeight,showLevel: data['toll'],
          gold: data['price'],duration: data['duration'],watchTimes: data['playNum'],desc: data['title'],likeNum: data['likeNum'],favNum: data['favNum'],videoStartTime: data['videoStartTime'],videoEndTime: data['videoEndTime'],);

        list.add(Container(
          margin: EdgeInsets.only(left: 21,right: 18),
          child: topicWidget,
        ));
      }else{/// 竖着放，一行放两张图片
        if(i % 2 == 0 && i > 0){
          rowData.clear();
          rowData.add(dataList[i]);
        }else{
          rowData.add(dataList[i]);
        }

        if(rowData.length == 2){
          list.add(SizedBox(height: 16,));
          Map<String,dynamic> data = rowData[0];
          Map<String,dynamic> data2 = rowData[1];

          String imgUrl = data['vcover'] ;
          Widget topicWidget = TopicDetailImg(videoId:data['id'],imgUrl:imgUrl,videoUrl: data['playPath'],imgWidth: imgWidth,imgHeight: imgHeight,
            showLevel: data['toll'],gold: data['price'],duration: data['duration'],watchTimes: data['playNum'],desc: data['title'],likeNum: data['likeNum'],favNum: data['favNum'],videoStartTime: data['videoStartTime'],videoEndTime: data['videoEndTime'],);

          String imgUrl2 = data2['vcover'] ;
          Widget topicWidget2 = TopicDetailImg(videoId:data2['id'],imgUrl:imgUrl2,videoUrl: data2['playPath'],imgWidth: imgWidth,imgHeight: imgHeight,
            showLevel: data2['toll'],gold: data2['price'],duration: data2['duration'],watchTimes: data2['playNum'],desc: data2['title'],likeNum: data['likeNum'],favNum: data['favNum'],videoStartTime: data['videoStartTime'],videoEndTime: data['videoEndTime'],);

          list.add(Container(
            margin: EdgeInsets.only(left: 21,right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                topicWidget,topicWidget2
              ],
            ),
          ));
        }


      }
    }

    list.add(SizedBox(height: 30,));


    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index){
          return list[index];
        },
      ),
      resizeToAvoidBottomInset: false,
    );;

  }

  @override
  TopicDetailPagePresenter createPresenter() {
    return TopicDetailPagePresenter();
  }

}