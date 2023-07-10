import 'package:caihong_app/presenter/topicPage_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../base/view/base_state.dart';
import '../views/topicImg.dart';

/**
 * 专题首页
 */
class TopicPage extends StatefulWidget {
  @override
  TopicPageState createState() => TopicPageState();

}

class TopicPageState extends BaseState<TopicPage, TopicPagePresenter>{

  List topicList = [];

  int page = 1;

  int limit = 4;

  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    refreshData();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        refreshData();
      }
    });
  }

  /// 请求接口后刷新数据
  Future refreshData() async {
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
    }
    Future<dynamic> dataFuture = mPresenter.getTopicList(page++, limit);

    setState(() {
      isLoading = false;
      dataFuture.then((value) => topicList.addAll(value));
    });
    return dataFuture;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Color(0xFF060123),
      padding: EdgeInsets.only(left: 21,right: 18),
      constraints: BoxConstraints(
        minWidth: size.width,
        minHeight: size.height,
      ),
      child: FutureBuilder(
        future: refreshData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<Widget> list = getTopicList(topicList);
            return ListView.builder(
              controller: _scrollController,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                return list[index];
              },
            );
          }else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  List<Widget> getTopicList(List dataList){
    List<Widget> list = [];

    Widget topicWidget = Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 14),
      child: Text('专题',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
    );
    list.add(topicWidget);

    list.add(SizedBox(height: 32,));

    if(topicList == null || topicList.isEmpty){
      return list;
    }

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double imgWidth = width - 39;
    double imgHeight = imgWidth * 189 / 336;
    print('imgHeight ============$imgHeight');

    topicList.forEach((topic) {
      Widget widget = Row(
        children: [
          TopicImg(topicId: topic['id'],imgWidth: imgWidth,imgHeight: imgHeight,totalVideo: topic['totalVideo'],imgUrl: topic['cover'],title: topic['name'],),
        ],
      );
      list.add(widget);
      //间距
      list.add(SizedBox(height: 12,));
    });
    return list;
  }

  @override
  TopicPagePresenter createPresenter() {
    return TopicPagePresenter();
  }




}