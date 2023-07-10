import 'package:caihong_app/pages/shortVideoPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:caihong_app/pages/searchBar.dart';
import 'package:caihong_app/pages/swiperPage.dart';
import 'package:caihong_app/style/MyUnderlineTabIndicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class SecondPageItem extends StatefulWidget {

  @override
  SecondPageItemState createState() => SecondPageItemState();

}


class SecondPageItemState extends State<SecondPageItem> {
  @override
  Widget build(BuildContext context) {
    return _listView(context);
  }

  ListView _listView(BuildContext context){
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final marginLeft = width / 20;
    final marginRight = width / 16;
    return ListView(
      children: [

        Container(
          height: 180,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(top:1),
          child: SwiperPage(),
        ),

        Container(
          height: 40,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(left: marginLeft,right: marginRight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('推荐视频'),
              Text("更多>")
            ],
          ),
        ),
        Container(
          child: getGridView(null),
        ),

        Container(
          height: 40,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: width/6,right: width/4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff7d40be)),
                ),
                child: Text(
                  '换一批',
                  style: const TextStyle(fontSize: 13.0, color: Colors.blue),
                ),
                onPressed: () {
                  print('换一批');
                },
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff7d40be)),
                ),
                child: Text(
                  '更多',
                  style: const TextStyle(fontSize: 13.0, color: Colors.blue),
                ),
                onPressed: () {
                  print('更多');
                },
              ),
            ],
          ),
        ),

        Container(
          height: 40,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(left: marginLeft,right: marginRight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('高颜值视频'),
              Text("更多>")
            ],
          ),
        ),
        Container(
          child:  getGridView(null),
        ),
        Container(
          height: 40,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: width/6,right: width/4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff7d40be)),
                ),
                child: Text(
                  '换一批',
                  style: const TextStyle(fontSize: 13.0, color: Colors.blue),
                ),
                onPressed: () {
                  print('换一批');
                },
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff7d40be)),
                ),
                child: Text(
                  '更多',
                  style: const TextStyle(fontSize: 13.0, color: Colors.blue),
                ),
                onPressed: () {
                  print('更多');
                },
              ),
            ],
          ),
        ),


        Container(
          height: 40,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(left: marginLeft,right: marginRight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('动漫视频'),
              Text("更多>")
            ],
          ),
        ),
        Container(
          child:  getGridView(null),
        ),
        Container(
          height: 40,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: width/6,right: width/4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff7d40be)),
                ),
                child: Text(
                  '换一批',
                  style: const TextStyle(fontSize: 13.0, color: Colors.blue),
                ),
                onPressed: () {
                  print('换一批');
                },
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff7d40be)),
                ),
                child: Text(
                  '更多',
                  style: const TextStyle(fontSize: 13.0, color: Colors.blue),
                ),
                onPressed: () {
                  print('更多');
                },
              ),
            ],
          ),
        ),

        Container(
          height: 40,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(left: marginLeft,right: marginRight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('主播秀'),
              Text("更多>")
            ],
          ),
        ),
        Container(
          child:  getGridView(null),
        ),
        Container(
          height: 40,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: width/6,right: width/4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff7d40be)),
                ),
                child: Text(
                  '换一批',
                  style: const TextStyle(fontSize: 13.0, color: Colors.blue),
                ),
                onPressed: () {
                  print('换一批');
                },
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff7d40be)),
                ),
                child: Text(
                  '更多',
                  style: const TextStyle(fontSize: 13.0, color: Colors.blue),
                ),
                onPressed: () {
                  print('更多');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget getGridView(List <Widget> gridChildren){
    return GridView.count(
      //如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
      primary: false,
      //禁止滚动
      physics: NeverScrollableScrollPhysics(),
      //是否允许内容适配
      shrinkWrap: true,
      //水平子Widget之间间距
      crossAxisSpacing: 10.0,
      //垂直子Widget之间间距
      mainAxisSpacing: 5.0,
      //GridView内边距
      padding: EdgeInsets.all(10.0),
      //一行的Widget数量
      crossAxisCount: 3,
      //子Widget宽高比例
      childAspectRatio: 2/3,
      //子Widget列表
      children: gridChildren ?? getWidgetList(),
    );
  }

  List<String> getDataList() {
    List<String> list = [];
    for (int i = 0; i < 6; i++) {
      list.add(i.toString());
    }
    return list;
  }

  List<Widget> getWidgetList() {
    return getDataList().map((item) => getItemContainer(item)).toList();
  }

  Widget getItemContainer(String item) {
    return new GestureDetector(
      onTap: () {
        //处理点击事件
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: false,
            builder: (context) => ShortVideoPage(),
          ),
        );
      },
      child: Column(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            Expanded(
                child: Image.network(
                  'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
                  width: 220,
                  height: 230,
                  fit: BoxFit.cover,
                )),
            Container(
                alignment: Alignment.center,
                height: 40,
                margin: const EdgeInsets.fromLTRB(3, 10, 25, 10),
                // padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "性感小姐姐11 ",textAlign:TextAlign.left, softWrap:false,style: TextStyle(fontSize: 13), //设置行距的方法
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('3小时前',style: TextStyle(fontSize: 11,color: Colors.grey),),
                        Text("评论0",style: TextStyle(fontSize: 11,color: Colors.grey),)
                      ],
                    ),
                  ],
                )),
          ]),
    );
  }

}