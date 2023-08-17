
import 'dart:math';

import 'package:caihong_app/mock/homePageData.dart';
import 'package:caihong_app/pages/watchVideoPage.dart';
import 'package:flutter/material.dart';

import '../base/view/base_state.dart';
import '../presenter/searchPagePresenter.dart';
import '../utils/PreferenceUtils.dart';
import '../views/tiktokTabBar.dart';
import '../views/videoImg.dart';
import 'homePage.dart';

class SearchPage extends StatefulWidget {
  final Function onPop;

  const SearchPage({
    Key key,
    this.onPop,
  }) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends BaseState<SearchPage,SearchPagePresenter> {

  List<String> hisSearch = []; // = ['将夜','漫长的季节','将夜','将夜2','完美世界','漫长的季节','将夜',]
  // List<String> hotSearch = ['三分野','妻子的新世界','公诉','奔跑吧','斗破苍穹年翻','斗罗大陆','漫长的季节',];

  /// 搜索页面的数据 , 热门搜索，热门推荐
  Map searchPaegInfo;

  /// 搜索出来的数据
  Map searchResult = Map();

  /// 当前搜索的输入内容
  String searchTxt;

  /// 是否已经搜索过
  bool isSearched = false;

  /// 搜索内容是否有结果
  bool hasSearchResult = false;

  /// 当前搜索视频记录选中 1.长视频，2.短视频
  int active;

  List recommandVideos = [];

  List hotSearchList = [];

  bool isSearching = false;

  @override
  void initState(){
    searchResult['longVideoList'] = [];
    searchResult['shortVideoList'] = [];
    super.initState();
    // searchPaegInfo = getSearchPageInfo();

    requestData();

    PreferenceUtils.instance.getStringList("hisSearch", hisSearch).then((value)  {
      setState(() {
        hisSearch.addAll(value);
      });
    });
  }

  void requestData() async {
    mPresenter.getRecommandVideos(1,10);
  }

  void refreshPage(List videoList){
    if(mounted){
      setState(() {
        recommandVideos.clear();
        recommandVideos.addAll(videoList);
      });
    }
  }

  /**
   * 检索视频
   */
  void searchByKey(String key) async{
    isSearching = true;
    searchResult['longVideoList'].clear();
    searchResult['shortVideoList'].clear();
    mPresenter.searchByKey(key);
  }

  void refreshSearchResult(List videoList){
    if(mounted){
      setState(() {
        searchResult['longVideoList'].addAll(videoList);
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    Widget search = HeadSearch(
      submitSearch: (text){
        isSearched = true;
        print('搜索内容是 $text');
        searchTxt = text;
        // 发送HTTP请求 TODO:
        searchByKey(text);

        if(!hisSearch.contains(text)){
          hisSearch.add(text);
          PreferenceUtils.instance.saveStringList("hisSearch", hisSearch).then((value) => hisSearch.addAll(value),);
        }
        // setState(() { });
      },
      searchTxt:searchTxt,
    );
    list.add(search);

    /// 如果有搜索数据
    List longVideoList = searchResult['longVideoList'];
    List shortVideoList = searchResult['shortVideoList'];
    bool haveLongVideo = longVideoList != null && longVideoList.length > 0;
    if((longVideoList != null && longVideoList.length > 0) || (shortVideoList != null && shortVideoList.length > 0)){
      active = active == null ? (haveLongVideo ? 1 : 2) : active;
      list.add(Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20,right: 20,top: 24,),
        child: Text('搜索"$searchTxt"的结果',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF)),),
      ));
      list.add(HaveSearchResult(searchResult:searchResult,active: active,updateChooseVideoItem:(v){
        setState(() {
          active = v;
        });
      },));
    }else{
      if(!isSearching){
        setNoSearchResultData(list);
      }
    }

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: list,
        ),
      ),
    );
  }

  /// 没有搜索数据的时候返回页面
  void setNoSearchResultData(List<Widget> list){
    if( isSearched){
      list.add(
        Container(
          margin: EdgeInsets.only(top: 14,left: 20,right: 20),
          alignment: Alignment.centerLeft,
          child: Text('对不起，没有找到关于"$searchTxt"的内容',style:TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF)),),
        ),
      );

      list.add(
          Center(child: Image.asset('lib/assets/images/search_no_result.png',height: 230,width: 230,),)
      );

      list.add(
          Center(child: Text('没有找到内容，换个词试试吧～',style:TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF)),),)
      );

      /*Widget searchResultWidget = Container(
        margin: EdgeInsets.only(top: 14,left: 20,right: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text('对不起，没有找到关于"$searchTxt"的内容',style:TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF)),),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: Image.asset('lib/assets/images/search_no_result.png',height: 110,width: 110,),
              ),
            ),
            // Image.asset('lib/assets/images/search_no_result.png',height: 110,width: 110,),
            Container(
              alignment: Alignment.topCenter,
              child: Text('没有找到内容，换个词试试吧～',style:TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF)),),
            ),
          ],
        ),
      );
      list.add(searchResultWidget);*/
    }else{
      if(hisSearch !=null && hisSearch.isNotEmpty){
        Widget hisSearchTitle = Container(
          margin: EdgeInsets.only(top: 14,left: 20,right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('历史搜索',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
              IconButton(onPressed: (){
                setState(() {
                  hisSearch = [];
                  PreferenceUtils.instance.saveStringList("hisSearch", hisSearch);
                });
              }, icon: Icon(Icons.delete,color: Color(0xFFFFFFFF),)),
            ],
          ),
        );
        list.add(hisSearchTitle);
        list.add(
            HisSearchList(
              hisSearch:hisSearch,
              onTapHis: (text){
                isSearched = true;
                searchTxt = text;
                // 发送HTTP请求 TODO:
                searchByKey(text);

                if(!hisSearch.contains(text)){
                  hisSearch.add(text);
                  PreferenceUtils.instance.saveStringList("hisSearch", hisSearch).then((value) => hisSearch.addAll(value),);
                }
                // setState(() {});
              },
            )
        );
      }
    }

    // 历史搜索记录选项
    /*List<Widget> hisWidget = [];
    hisSearch.forEach((ele) {
      hisWidget.add(
          Container(
            margin: EdgeInsets.only(right: 8,bottom: 10,),
            padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
            height: 32,
            decoration: BoxDecoration(
              color: Color(0xFF2E0169),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(ele, style : TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold'),),
          ),
      );
    });

    // 历史记录块
    Widget hisSearchBody = Container(
      // height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15,left: 20,right: 5),
      child: Wrap(
        children: hisWidget,
      ),
    );
    list.add(hisSearchBody);

    //展开 收起
    Widget showHideHis = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('收起',style : TextStyle(color: Color(0x80FFFFFF),fontSize: 16,fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Regular'),),
          Icon(Icons.expand_less,color: Color(0x80FFFFFF),),
        ],
      ),
    );
    list.add(showHideHis);*/




    // 热门搜索选项
    List<Widget> hotWidget = [];
    if(hotSearchList != null && hotSearchList.length > 0){

      // 热门搜索标题
      Widget hotSearchTitle = Container(
        alignment: Alignment.bottomLeft,
        margin: EdgeInsets.only(top: 32,left: 20,),
        child:Text('热门搜索',style : TextStyle(color: Color(0x80FFFFFF),fontSize: 16,fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Regular'),),
      );
      list.add(hotSearchTitle);

      hotSearchList.forEach((ele) {
        hotWidget.add(
          Container(
            margin: EdgeInsets.only(right: 8,bottom: 10),
            padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
            height: 32,
            decoration: BoxDecoration(
              color: Color(0x80FF5E7C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: (){
                isSearched = true;
                searchTxt = ele;
                // 发送HTTP请求 TODO:
                searchByKey(ele);

                if(!hisSearch.contains(ele)){
                  hisSearch.add(ele);
                  PreferenceUtils.instance.saveStringList("hisSearch", hisSearch).then((value) => hisSearch.addAll(value),);
                }
                // setState(() {});
              },
              child: Text(ele, style : TextStyle(color: Color(0xFFFFFFFF),fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'PingFang SC-Semibold'),
              ),),
          ),
        );
      });

      // 热门搜索块
      Widget hotSearchBody = Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 15,left: 20),
        child: Wrap(
          children: hotWidget,
        ),
      );
      list.add(hotSearchBody);

    }




    // 热门推荐标题
    Widget hotRecommandTitle = Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(top: 22,left: 20),
      child:Text('热门推荐',style : TextStyle(color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Bold'),),
    );
    list.add(hotRecommandTitle);

    //热门推荐图片表格
    Widget hotRecommandVideoWidget = Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 16),
      child: GridView.count(
        //如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
        primary: false,
        //禁止滚动
        physics: NeverScrollableScrollPhysics(),
        //是否允许内容适配
        shrinkWrap: true,
        //水平子Widget之间间距
        crossAxisSpacing: 15,
        //垂直子Widget之间间距
        mainAxisSpacing: 16,
        //GridView内边距
        padding: EdgeInsets.all(0.0),
        //一行的Widget数量  showType: 1 横着放， 2 竖着放
        crossAxisCount: 2,
        //子Widget宽高比例
        childAspectRatio: 160/118,
        //子Widget列表
        children:  getWidgetList(),
      ),
    );
    list.add(hotRecommandVideoWidget);
  }

  //热门推荐表格数据
  List<Widget> getWidgetList(){
    List<Widget> list = [];
    if(recommandVideos.length > 0){
      recommandVideos.forEach((item) {
        list.add(getItemContainer(item));
      });
    }
    return list;
  }

  Widget getItemContainer(Map<String,dynamic> item) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    double imgWidth = (width - 55)/2; // 默认按照横着放
    double imgHeight = imgWidth * 9/16; // 按照间距 和 宽高比例计算
    String imgUrl = item['hcover'] ?? item['vcover'];
    String duration = item['duration'];
    int showLevel = item['toll'];
    int gold = item['price'];
    String desc = item['title'];
    String videoId = item['id'];
    String playPath = item['playPath'];
    // 标题
    String title = item['title'];
    // 点赞数
    int likeNum = item['likeNum'];
    //播放数
    int playNum = item['playNum'];
    if(playNum == null || playNum == 0){
      playNum = Random().nextInt(20000) + 2000;
    }
    // 视频标签;#分割
    String tags = item['tags'];

    String createTime = item['createTime'];
    // 收藏次数
    int favNum = item['favNum'];

    int videoEndTime = item['videoEndTime'];

    int videoStartTime = item['videoStartTime'];

    //视频图片
    return VideoImg(imgUrl:imgUrl,imgWidth:imgWidth,imgHeight:imgHeight,duration:duration,showLevel:showLevel,gold: gold,desc:desc,videoId:videoId,playNum: playNum,
        onTapPlayer:(){
          //处理点击事件
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context) => WatchVideoPage(videoId:videoId,videoUrl: playPath,title: title,likeNum: likeNum,playNum: playNum,duration: duration,
                tags: tags,createTime: createTime,gold: gold,showLevel: showLevel,favNum:favNum,videoStartTime: videoStartTime,videoEndTime: videoEndTime,),
            ),
          );
        }
    );
  }

  @override
  SearchPagePresenter createPresenter() {
    return SearchPagePresenter();
  }


}

/**
 * 搜索框
 */
class HeadSearch extends StatelessWidget {

  HeadSearch({this.submitSearch,this.searchTxt : ''});

  ValueChanged submitSearch;

  final String searchTxt;

  TextEditingController _searchContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(searchTxt != null){
      _searchContentController.value = _searchContentController.value.copyWith(
        text: searchTxt,
        selection:
        TextSelection(baseOffset: searchTxt.length, extentOffset: searchTxt.length),
        composing: TextRange.empty,
      );
    }
    Widget search = Container(
      height: 40,
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Opacity(
        opacity: 0.99,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16,top: 10,bottom: 10),
              child: Image.asset('lib/assets/images/search.png',width: 20,height: 20,),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 122,
              child: Container(
                margin: EdgeInsets.only(left: 4),
                child: TextField(
                  onSubmitted: (String value){
                    submitSearch(value);
                  },
                  decoration: InputDecoration(hintText: '请输入你要搜索的内容',border: InputBorder.none,hintStyle: TextStyle(fontSize: 13,color: Color(0x80FFFFFF),fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400),),
                  style: TextStyle(fontSize: 13,color: Color(0x80FFFFFF),fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400),
                  controller: _searchContentController,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return WillPopScope(
      onWillPop: (){
        Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => new HomePage()),
              (route) => route == null,
        );
        return Future.value(true);
      },
      child: Container(
        margin: EdgeInsets.only(left: 20,right: 20,top: 14,),
        child: Row(
          children: [
            Expanded(child: search,),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text('取消',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  new MaterialPageRoute(builder: (context) => new HomePage()),
                      (route) => route == null,
                );
              },
            ),
          ],
        ),
      ),
    );

    /*return Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 14,),
      child: Row(
        children: [
          Expanded(child: search,),
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text('取消',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(builder: (context) => new HomePage()),
                    (route) => route == null,
              );
            },
          ),
        ],
      ),
    );*/
  }

}

/**
 * 历史搜索记录
 */
class HisSearchList extends StatelessWidget {

  HisSearchList({this.hisSearch, this.onTapHis});

  final List<String> hisSearch;

  ValueChanged onTapHis;

  @override
  Widget build(BuildContext context) {
    // 历史搜索记录选项
    List<Widget> hisWidget = [];
    hisSearch.forEach((ele) {
      hisWidget.add(
        GestureDetector(
          onTap: () {
            onTapHis(ele);
          },
          child: Container(
            margin: EdgeInsets.only(right: 8, bottom: 10,),
            padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
            height: 32,
            decoration: BoxDecoration(
              color: Color(0xFF2E0169),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(ele, style: TextStyle(color: Color(0xFFFFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'PingFang SC-Semibold'),),
          ),
        ),
      );
    });

    // 历史记录块
    return Container(
      // height: 100,
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: EdgeInsets.only(top: 15, left: 20, right: 5),
      child: Wrap(
        children: hisWidget,
      ),
    );
  }
}


/**
 * 搜索视频数据展示
 */
class HaveSearchResult extends StatefulWidget {

  HaveSearchResult({this.searchResult,this.active,this.updateChooseVideoItem});

  final Map searchResult;

  /// 默认选中长视频 1: 长视频，2: 短视频
  int active;

  ValueChanged updateChooseVideoItem;

  @override
  HaveSearchResultState createState() => HaveSearchResultState();
}

/**
 * 搜索视频数据展示
 */
class HaveSearchResultState extends State<HaveSearchResult> {
  @override
  Widget build(BuildContext context) {
    List longVideoList = widget.searchResult['longVideoList'];
    List shortVideoList = widget.searchResult['shortVideoList'];
    bool haveLongVideo = longVideoList != null && longVideoList.length > 0;
    bool haveShortVideo = shortVideoList != null && shortVideoList.length > 0;
    widget.active = widget.active == null ? (haveLongVideo ? 1 : 2) : widget.active;
    Widget title = Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 15,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          haveLongVideo ?
          GestureDetector(
            onTap: (){
              if(widget.active == 2){
                setState(() {
                  widget.updateChooseVideoItem(1);
                });
              }
            },
            child: Text('长视频',style: TextStyle(fontSize: 13,color: widget.active == 1 ? Color(0xFFFFFFFF) : Color(0x80FFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400),) ,
          )
              : Container(),
          haveLongVideo ? SizedBox(width: 24,) : Container(),
          haveShortVideo ?
          GestureDetector(
            onTap: (){
              if(widget.active == 1){
                setState(() {
                  widget.updateChooseVideoItem(2);
                });
              }
            },
            child: Text('短视频',style: TextStyle(fontSize: 13,color: widget.active == 2 ? Color(0xFFFFFFFF) : Color(0x80FFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400),) ,
          )
          : Container(),
        ],
      ),
    );

    /// 视频展示
    Widget videoWidget = Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 16),
      child: GridView.count(
        //如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
        primary: false,
        //禁止滚动
        physics: NeverScrollableScrollPhysics(),
        //是否允许内容适配
        shrinkWrap: true,
        //水平子Widget之间间距
        crossAxisSpacing: widget.active == 1 ? 15 : 10,
        //垂直子Widget之间间距
        mainAxisSpacing: 16,
        //GridView内边距
        padding: EdgeInsets.all(0.0),
        //一行的Widget数量  showType: 1 横着放， 2 竖着放
        crossAxisCount: widget.active == 1 ? 2 : 3,
        //子Widget宽高比例
        childAspectRatio: widget.active == 1 ? 160/118 : 105/168,
        //子Widget列表
        children:  getWidgetList(widget.active == 1 ? longVideoList : shortVideoList),
      ),
    );
    return Container(
      child: Column(
        children: [
          title,
          videoWidget,
        ],
      ),
    );
  }

  List<Widget> getWidgetList(List dataList){
    List<Widget> list = [];
    if(dataList.length > 0){
      dataList.forEach((item) {
        list.add(getItemContainer(item));
      });
    }
    return list;
  }

  Widget getItemContainer(Map item) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    double imgWidth = (width - 55)/2; // 默认按照横着放
    double imgHeight = imgWidth * 9/16; // 按照间距 和 宽高比例计算
    if(widget.active == 2){
      imgWidth = (width - 60)/3; // 竖着放图片的宽度
      imgHeight = imgWidth * 28 / 21;
    }
    String imgUrl = item['hcover'] ?? item['vcover'];
    String duration = item['duration'];
    int showLevel = item['toll'];
    int gold = item['price'];
    String desc = item['title'];
    String videoId = item['id'];
    String playPath = item['playPath'];
    // 标题
    String title = item['title'];
    // 点赞数
    int likeNum = item['likeNum'];
    //播放数
    int playNum = item['playNum'];
    if(playNum == null || playNum == 0){
      playNum = Random().nextInt(20000) + 2000;
    }
    // 视频标签;#分割
    String tags = item['tags'];

    String createTime = item['createTime'];
    // 收藏次数
    int favNum = item['favNum'];

    int videoEndTime = item['videoEndTime'];

    int videoStartTime = item['videoStartTime'];


    //视频图片
    return VideoImg(imgUrl:imgUrl,imgWidth:imgWidth,imgHeight:imgHeight,duration:duration,showLevel:showLevel,gold: gold,desc:desc,videoId:videoId,
        onTapPlayer:(){
          if(widget.active == 1){
            //处理点击事件
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: false,
                builder: (context) => WatchVideoPage(videoId:videoId,videoUrl: playPath,title: title,likeNum: likeNum,playNum: playNum,duration: duration,
                    tags: tags,createTime: createTime,gold: gold,showLevel: showLevel,favNum:favNum,videoStartTime: videoStartTime,videoEndTime: videoEndTime,),
              ),
            );
          }else{
            //处理点击事件
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: false,
                builder: (context) => HomePage(videoId:videoId,type:TikTokPageTag.shortVideo),
              ),
            );
          }
        }
    );
  }

}
