import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../presenter/MyCollectionPresenter.dart';
import '../views/ImageShowItem.dart';
import 'leftSlideActions.dart';


/**
 * 我的收藏
 */
class MyCollection extends StatefulWidget{

  @override
  MyCollectionState createState() => MyCollectionState();

}

class MyCollectionState extends BaseState <MyCollection,MyCollectionPresenter>{

  int page = 1;

  int limit = 20;

  List dataList = [];

  final List<String> _itemTextList = [];

  final Map<String, VoidCallback> _mapForHideActions = {};

  ScrollController _scrollController = new ScrollController();

  @override
  void initState(){
    requestData();
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        requestData();
      }
    });
  }

  void requestData(){
    mPresenter.getCollectionVideos(page++, limit);

  }

  void refreshData(List videoList){
    if(videoList != null && videoList.length > 0){
      dataList.addAll(videoList);
      for (int i = 1; i <= dataList.length; i++) {
        _itemTextList.add(i.toString());
      }
      setState(() { });
    }
  }



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    List<Widget> list = [];
    /// 头部
    Widget header = Container(
      margin: EdgeInsets.only(top: 14,left: 14,right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left_outlined),
          ),
          Text('我收藏的视频',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          SizedBox(width: 10,),
        ],
      ),
    );
    list.add(header);

    /// 数据
    Widget view = ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.fromLTRB(20, 32, 35, 30),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index < _itemTextList.length) {
          final String tempStr = _itemTextList[index];
          Map data = dataList[index];
          return LeftSlideActions(
            key: Key(tempStr),
            actionsWidth: 60,
            actions: [
              _buildDeleteBtn(index,data),
            ],
            child: ImageShowItem(imgUrl: data['hcover'] == '' ? data['vcover'] : data['hcover'],videoId:data['videoId'],videoUrl:data['playPath'],imgWidth: 160,imgHeight:90,showLevel: data['toll'],gold: data['price'],
              desc: data['title'],likeNum: data['likeNum'],playNum: data['playNum'],duration: data['duration'],tags: data['tags'],createTime: data['createTime'],videoStartTime: data['videoStartTime'],videoEndTime: data['videoEndTime'],),

            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            actionsWillShow: () {
              // 隐藏其他列表项的行为。
              for (int i = 0; i < _itemTextList.length; i++) {
                if (index == i) {
                  continue;
                }
                String tempKey = _itemTextList[i];
                VoidCallback hideActions = _mapForHideActions[tempKey];
                if (hideActions != null) {
                  hideActions();
                }
              }
            },
            exportHideActions: (hideActions) {
              _mapForHideActions[tempStr] = hideActions;
            },
          );
        }
        return const SizedBox.shrink();
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 1.0, color: Color(0xFF2E0169));

        /*return Container(
          height: 0.5,
            color: Color(0xFF2E0169)
        );*/
      },
      // 添加下面这句 内容未充满的时候也可以滚动。
      physics: const AlwaysScrollableScrollPhysics(),
      // 添加下面这句 是为了GridView的高度自适应, 否则GridView需要包裹在固定宽高的容器中。
      //shrinkWrap: true,
    );

    list.add(view);


    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          height: 30,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0x001A0258),
                Color(0xFF3D0363),
              ],
            ),
          ),
        ),
        preferredSize:  Size(MediaQuery.of(context).size.width, 45),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Expanded(child:view),
          ],
        ),
      ),
    );
  }


  Widget _buildDeleteBtn(final int index,Map data) {
    return GestureDetector(
      onTap: () {
        // 省略: 弹出是否删除的确认对话框。
        mPresenter.deleteCollection(data['videoId']);
        setState(() {
          _itemTextList.removeAt(index);
        });
      },
      child: Container(
        width: 60,
        color: const Color(0xFFFF0000),
        alignment: Alignment.center,
        child: const Text(
          '删除',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }


  @override
  MyCollectionPresenter createPresenter() {
    return MyCollectionPresenter();
  }

}

/*

class CollectionItem extends StatelessWidget {

  CollectionItem({this.imgUrl,this.imgWidth,this.imgHeight,this.showLevel,this.gold,this.desc,});

  final String imgUrl;

  final double imgWidth;

  final double imgHeight;

  final int showLevel;

  final int gold;

  final String desc;

  @override
  Widget build(BuildContext context) {

    //视频图片
    Widget videoImg = ImageShowItem(imgUrl:imgUrl,imgWidth:imgWidth,imgHeight:imgHeight,showLevel:showLevel,gold: gold,desc:desc,);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          videoImg,
          Text(desc,style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
        ],
      ),
    );

  }





}*/
