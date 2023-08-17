
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base/view/base_state.dart';
import '../presenter/BindPhonePagePresenter.dart';
import '../presenter/InviteCodePagePresenter.dart';

/**
 * 绑定手机页面
 */
class BindPhonePage extends StatefulWidget {

  @override
  BindPhonePageState createState() => BindPhonePageState();

}

class BindPhonePageState extends BaseState<BindPhonePage,BindPhonePagePresenter> {

  TextEditingController _searchContentController = TextEditingController();

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
          Text('绑定手机',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          SizedBox(width: 10,),
        ],
      ),
    );
    list.add(header);

    list.add(Container(
      margin: EdgeInsets.only(left: 20,top: 30,),
      child: Text('绑定手机',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
    ));


    /// 邀请码输入框
    Widget inputWidget = Container(
      height: 44,
      width: size.width - 40,
      color: Color(0xFF211D38),
      margin: EdgeInsets.only(left: 20,right: 20,top: 12,),
      child: TextField(
        onSubmitted: (String value){
          if(value != null){
            _searchContentController.value = _searchContentController.value.copyWith(
              text: value,
              selection:
              TextSelection(baseOffset: value.length, extentOffset: value.length),
              composing: TextRange.empty,
            );
          }
        },
        textAlign: TextAlign.left,
        decoration: InputDecoration(hintText: '请填写手机号码',border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 16,color: Color(0x80FFFFFF),fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,),),
        style: TextStyle(fontSize: 18,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Regular',fontWeight: FontWeight.w400,decoration: TextDecoration.none,),
        controller: _searchContentController,
      ),
    );
    list.add(inputWidget);

    Widget btn = GestureDetector(
        onTap: (){
          mPresenter.bindPhone(_searchContentController.text,callback:(){Navigator.of(context).pop();});
        },
        child: Container(
          margin: EdgeInsets.only(top: 40,left: 20,right: 20,),
          padding: EdgeInsets.symmetric(horizontal: (size.width - 76)/2,vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFC560E7),
                Color(0xFFD93B9F),
              ],
              stops: [0.0, 0.8],
            ),
          ),
          child: Text('提交',style: TextStyle(fontSize: 16,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,decoration: TextDecoration.none),),
        )
    );
    list.add(btn);

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
          children: list,
        ),
      ),
    );
  }

  @override
  BindPhonePagePresenter createPresenter() {
    return BindPhonePagePresenter();
  }


}