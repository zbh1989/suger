import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../mock/homePageData.dart';
import '../presenter/GoldChargeHisPresenter.dart';
import '../presenter/VipChargeHisPresenter.dart';

/**
 * 充值历史记录页面
 * 布局页面
 */
class VipChargeHisPage extends StatefulWidget{

  @override
  VipChargeHisPageState createState() => VipChargeHisPageState();

}

class VipChargeHisPageState extends BaseState<VipChargeHisPage,VipChargeHisPresenter>{

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
    List<Map<String,dynamic>> dataList = getChargeGoldHis(pageNum++,pageSize,1);
    setState(() {
      isLoading = false;
      if(dataList.length > 0){
        chargeGoldDataList.addAll(dataList);
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
          Expanded(child: Center(child:Text('会员开通记录',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),))
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
  VipChargeHisPresenter createPresenter() {
    return VipChargeHisPresenter();
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
        color: Color(0xFF211D38),
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('颜射视频VIP',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFF5DA89)),),
              SizedBox(height: 16,),
              Text('您已成功开通颜射视频VIP服务，续费类型：周卡会员，有效期至：2023-05-12。感谢您对我们的支持与信赖，因为有您，我们才能并肩走的更远！',softWrap: true,style: TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
              SizedBox(height: 16,),
              Text('2023.05.1216:45',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,color: Color(0x80FFFFFF)),),
            ],
          )),
        ],
      ),
    );
  }

}
