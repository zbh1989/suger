import 'package:flutter/material.dart';
import '../../pages/leftSlideActions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage2(),
    );
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  static const int _itemNum = 20;
  final List<String> _itemTextList = [];
  final Map<String, VoidCallback> _mapForHideActions = {};

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= _itemNum; i++) {
      _itemTextList.add(i.toString());
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
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
      itemCount: _itemTextList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index < _itemTextList.length) {
          final String tempStr = _itemTextList[index];
          return LeftSlideActions(
            key: Key(tempStr),
            actionsWidth: 60,
            actions: [
              _buildDeleteBtn(index),
            ],
            child: _buildListItem(index),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
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
        return const SizedBox(height: 10);
      },
      // 添加下面这句 内容未充满的时候也可以滚动。
      physics: const AlwaysScrollableScrollPhysics(),
      // 添加下面这句 是为了GridView的高度自适应, 否则GridView需要包裹在固定宽高的容器中。
      //shrinkWrap: true,
    );

    list.add(view);


    return Scaffold(
      body: Container(
        // physics: const BouncingScrollPhysics(),
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

  Widget _buildListItem(final int index) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        // color: Colors.green,
        boxShadow: [
          BoxShadow(
            // 阴影颜色。
            color: Color(0x66EBEBEB),
            // 阴影xy轴偏移量。
            offset: Offset(0.0, 0.0),
            // 阴影模糊程度。
            blurRadius: 6.0,
            // 阴影扩散程度。
            spreadRadius: 4.0,
          ),
        ],
      ),
        child: Container(
          color: Color(0xFF060123),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: const FractionalOffset(0.0,0.0),//0.5,0.89
                children: <Widget>[
                  Container(
                    width: 160,
                    height: 90,
                    child: Image.network(
                      'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',width: 90,height: 90,
                      fit: BoxFit.cover,
                      /*errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                        return Text('Your error widget...');
                      },*/
                    ),
                  ),

                  // getShowLevelIcon(1, 30),

                ],
              ),
              SizedBox(width: 20,),
              Text('xxxxxxxxxxxx',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
            ],
          ),
        )
    );
  }

  Widget _buildDeleteBtn(final int index) {
    return GestureDetector(
      onTap: () {
        // 省略: 弹出是否删除的确认对话框。
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
}