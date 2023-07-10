import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Pager extends StatefulWidget {

  TextStyle activeTextStyle;  // 当前页码的文本样式
  Widget preWidget;  // 上一页的widget
  Widget nextWidget; // 下一页的widget
  int total;  // 总页码数量
  double containerWidth;  // 容器的宽度
  MainAxisAlignment mainAxisAlignment;  // 页码横主轴对齐方式
  TextStyle normalTextStyle;  // 其他页码的文本样式
  double pagerItemWidth;  // 页码item的宽度
  double pagerItemHeight; // 页码item的高度
  BoxDecoration pagerItemDecoration;  // 页码item的样式
  ValueChanged pageChange;   // 页码改变的回调
  EdgeInsetsGeometry pagerItemMargin;  // 页码item的边距

  Pager({
    Key key,
    TextStyle activeTextStyle,
    Widget preWidget,
    Widget nextWidget,
    this.total,
    double containerWidth,
    MainAxisAlignment mainAxisAlignment,
    TextStyle normalTextStyle,
    double pagerItemWidth,
    double pagerItemHeight,
    BoxDecoration pagerItemDecoration,
    this.pageChange,
    EdgeInsetsGeometry pagerItemMargin,
  }) :  activeTextStyle = activeTextStyle ?? TextStyle(color: Colors.white,
      fontSize: 14,decoration: TextDecoration.none,),
        preWidget = preWidget ?? Text('上一页',style: TextStyle(color: Colors.red,fontSize: 12),),
        nextWidget = nextWidget ?? Text('下一页',style: TextStyle(color: Colors.red,fontSize: 12),),
        containerWidth = containerWidth ?? double.infinity,
        mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.center,
        normalTextStyle = normalTextStyle ?? TextStyle(color: Colors.red, fontSize: 12,decoration: TextDecoration.none,),
        pagerItemWidth = pagerItemWidth ?? 42,
        pagerItemHeight = pagerItemHeight ?? 30,
        pagerItemDecoration = pagerItemDecoration ?? BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(3)),
        pagerItemMargin = pagerItemMargin ?? const EdgeInsets.all(0),
        super(key: key);

  @override
  State<Pager> createState() => _PagerState();
}

class _PagerState extends State<Pager> {
  int _pageIndex = 1;
  List _list = [];


  void manageList() {
    _list = [];
    if(widget.total <= 1) {
      return;
    }
    if(widget.total <= 7) {
      for(var i = 0; i < widget.total; i++) {
        _list.add(i+1);
      }
    } else if(_pageIndex <= 4) {
      _list = [1,2,3,4,5, "...", widget.total];
    } else if(_pageIndex > widget.total - 3) {
      _list = [1,2, "...", widget.total - 3, widget.total - 2, widget.total - 1,  widget.total];
    } else {
      _list = [1, "...", _pageIndex - 1, _pageIndex, _pageIndex + 1, "...", widget.total];
    }
    _list.insert(0, '上一页');
    _list.add('下一页');
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }


  Widget buildContent() {
    manageList();

    List<Widget> list = [];
    _list.forEach((item) {
      Widget itemWidget = Container();
      if(item == '上一页') {
        itemWidget = GestureDetector(
          onTap: () {
            if(_pageIndex > 1) {
              setState(() {
                _pageIndex--;
              });
            }
          },
          child: buildPagerItem(
              child: Text(
                "$item",
                style: item == _pageIndex ? TextStyle(color: Colors.white,fontSize: 11) : TextStyle(color: Colors.red, fontSize: 11),
              )
          ),
        );
      }else if(item == '下一页') {
        itemWidget = GestureDetector(
          onTap: () {
            if(_pageIndex < widget.total) {
              setState(() {
                _pageIndex++;
              });
            }
          },
          child: buildPagerItem(
              child: Text(
                "$item",
                style: item == _pageIndex ? TextStyle(color: Colors.white,fontSize: 11) : TextStyle(color: Colors.red, fontSize: 11),
              )
          ),
        );
      }else{
        itemWidget = GestureDetector(
          onTap: () {
            if(item != "...") {
              setState(() {
                if(_pageIndex != item) {
                  _pageIndex = item;
                }
              });
            }
          },
          child: buildPagerItem(
              child: Text(
                "$item",
                style: item == _pageIndex ? TextStyle(color: Colors.white,fontSize: 11) : TextStyle(color: Colors.red, fontSize: 11),
              )
          ),
        );
      }
      list.add(itemWidget);
    });

    return Container(
      // width: widget.containerWidth,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.mainAxisAlignment,
        children: _list.mapIndexed((index, ele) {
          if(index == 0) {
            return GestureDetector(
              onTap: () {
                if(_pageIndex > 1) {
                  setState(() {
                    _pageIndex--;
                    widget.pageChange(_pageIndex);
                  });
                }
              },
              child: Container(
                width: widget.pagerItemWidth,
                height: widget.pagerItemHeight,
                alignment: Alignment.center,
                decoration: widget.pagerItemDecoration,
                margin: widget.pagerItemMargin,
                child: Text(ele,style: ele == _pageIndex ? widget.activeTextStyle : widget.normalTextStyle,),
              ),
            );
          }else if(index == _list.length - 1) {
            return GestureDetector(
              onTap: () {
                if(_pageIndex < widget.total) {
                  setState(() {
                    _pageIndex++;
                    widget.pageChange(_pageIndex);
                  });
                }
              },
              child: Container(
                width: widget.pagerItemWidth,
                height: widget.pagerItemHeight,
                alignment: Alignment.center,
                decoration: widget.pagerItemDecoration,
                margin: widget.pagerItemMargin,
                child: Text(ele,style: ele == _pageIndex ? widget.activeTextStyle : widget.normalTextStyle,),



              ),
            );
          }else{
            return GestureDetector(
              onTap: () {
                if(ele != "...") {
                  setState(() {
                    if(_pageIndex != ele) {
                      _pageIndex = ele;
                      widget.pageChange(_pageIndex);
                    }
                  });
                }
              },
              child: Container(
                width: widget.pagerItemWidth,
                height: widget.pagerItemHeight,
                alignment: Alignment.center,
                decoration: widget.pagerItemDecoration,
                margin: widget.pagerItemMargin,
                child: Text(ele.toString(),style: ele == _pageIndex ? widget.activeTextStyle : widget.normalTextStyle,),
              ),
            );
          }

        }).toList(),
      ),
    );
  }


  Widget buildPagerItem({
    Widget child
  }) {
    return Container(
      width: widget.pagerItemWidth,
      height: widget.pagerItemHeight,
      alignment: Alignment.center,
      // decoration: widget.pagerItemDecoration,
      margin: widget.pagerItemMargin,
      child: child,
    );
  }
}