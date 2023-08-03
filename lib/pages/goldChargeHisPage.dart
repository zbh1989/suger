import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../mock/homePageData.dart';
import '../presenter/GoldChargeHisPresenter.dart';

/**
 * 充值历史记录页面
 * 布局页面
 */
class GoldChargeHisPage extends StatefulWidget{

  @override
  GoldChargeHisPageState createState() => GoldChargeHisPageState();

}

class GoldChargeHisPageState extends BaseState<GoldChargeHisPage,GoldChargeHisPresenter>{

  GoldChargeHisPageState();

  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;

  int pageNum = 1;

  int pageSize = 10;


  List<Map<String,dynamic>> chargeGoldDataList = [];

  @override
  void initState(){
    refreshData();
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        refreshData();
      }
    });
  }

  void refreshData(){
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
    }
    /*List<Map<String,dynamic>> dataList = getChargeGoldHis(pageNum++,pageSize,1);
    setState(() {
      isLoading = false;
      if(dataList.length > 0){
        chargeGoldDataList.addAll(dataList);
      }
    });*/
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
          Expanded(child: Center(child:Text('金币明细',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),))
        ],
      ),
    );

    List<Widget> list = [];

    chargeGoldDataList.forEach((ele) {
      list.add(ChargeRecordItem(data: ele,));
    });


    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,title: header,backgroundColor:Color(0xFF060123)),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return list[index];
        },
      ),
    );
  }

  @override
  GoldChargeHisPresenter createPresenter() {
    return GoldChargeHisPresenter();
  }
}


class ChargeRecordItem extends StatelessWidget {

  ChargeRecordItem({this.data});

  final Map<String,dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      margin: EdgeInsets.only(left: 20,right: 20,top:12 ),
      decoration: BoxDecoration(
        color: Color(0xFF200E37),
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('账户充值',style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
              SizedBox(height: 12,),
              Text(data['dateTime'] ?? '',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF)),),
            ],
          ),
          Row(
            children: [
              Text('+' + data['gold'].toString(),style: TextStyle(fontSize: 16,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFAC5AFF)),),
              SizedBox(width: 11.5,),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFFD96B),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 20,
                height: 20,
                // padding: EdgeInsets.all(5),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFF9B721),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 16,
                  height: 16,
                  child: Text('￥',style: TextStyle(fontSize: 13,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFBF790A)),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
