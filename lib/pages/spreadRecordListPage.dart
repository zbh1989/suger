import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../mock/homePageData.dart';
import '../presenter/GoldChargeHisPresenter.dart';
import '../presenter/SpreadRecordListPresenter.dart';

/**
 * 推广记录
 */
class SpreadRecordListPage extends StatefulWidget{

  @override
  SpreadRecordListPageState createState() => SpreadRecordListPageState();

}

class SpreadRecordListPageState extends BaseState<SpreadRecordListPage,SpreadRecordListPresenter>{

  List recordList = [];

  @override
  void initState(){
    mPresenter.query();
    super.initState();
  }

  void refreshData(List dataList){
    setState(() {
      if(dataList.length > 0){
        recordList.addAll(dataList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget header = Container(
      child: Row(
        
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left_outlined,),
          ),
          Expanded(child: Center(child:Text('推广用户',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),))
        ],
      ),
    );

    List<Widget> list = [];

    recordList.forEach((ele) {
      list.add(RecordItem(data: ele,));
    });


    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,title: header,backgroundColor:Color(0xFF060123)),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return list[index];
        },
      ),
    );
  }

  @override
  SpreadRecordListPresenter createPresenter() {
    return SpreadRecordListPresenter();
  }
}


class RecordItem extends StatelessWidget {

  RecordItem({this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 20,right: 20,top:12 ),
      decoration: BoxDecoration(
        color: Color(0xFF200E37),
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('id : ' + data['id'].toString(),style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFAC5AFF)),),
          // SizedBox(width: 11.5,),
          Text('用户名 : ' + data['username'].toString(),style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFAC5AFF)),),
        ],
      ),
    );
  }

}
