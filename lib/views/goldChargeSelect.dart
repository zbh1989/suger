import 'package:flutter/material.dart';

import '../mock/homePageData.dart';
import 'goldChargeItem.dart';

class GoldChargeSelect extends StatefulWidget {

  GoldChargeSelect({this.setSelectMoney,this.dataList,});

  final List dataList;

  ValueChanged setSelectMoney;


  @override
  GoldChargeSelectState createState() => GoldChargeSelectState();

}

class GoldChargeSelectState extends State<GoldChargeSelect> {


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*if(widget.dataList !=null && widget.dataList.length > 0){
      widget.dataList.forEach((element) {
        if(element['isSelect'] == 1){
          widget.setSelectMoney(element);
        }else{
          element['isSelect'] = 2;
        }
      });
    }*/

    return Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 16),
      child: GridView.count(
        //如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动。
        primary: false,
        //禁止滚动
        physics: NeverScrollableScrollPhysics(),
        //是否允许内容适配
        shrinkWrap: true,
        //水平子Widget之间间距
        crossAxisSpacing: 5,
        //垂直子Widget之间间距
        mainAxisSpacing: 16,
        //GridView内边距
        padding: EdgeInsets.all(0.0),
        //一行的Widget数量  showType: 1 横着放， 2 竖着放
        crossAxisCount: 3,
        //子Widget宽高比例
        childAspectRatio: 1/1,
        //子Widget列表
        children: widget.dataList == null ? [] : getChooseItems(),
      ),
    );
  }

  List<Widget> getChooseItems(){
    List<Widget> list = [];
    widget.dataList.forEach((ele) {
      var giftNo = ele['giftNo'];
      Widget goldChargeItem = GoldChargeItem(money:int.parse(ele['price']),gold:ele['goldNo'],extraGold: giftNo,desc:'赠送$giftNo金币',isSelect: ele['isSelect'],
        selectItem:(map){
          widget.setSelectMoney(map);
          setState(() {
            widget.dataList.forEach((data) {
              if(int.parse(data['price']) == map['money']){
                data['isSelect'] = 1;
              }else{
                data['isSelect'] = 2;
              }
            });
          });
        },
      );
      list.add(goldChargeItem);
    });
    return list;
  }

}

