import 'package:flutter/material.dart';
import '../utils/stringUtils.dart';

class SignItem extends StatefulWidget {

  SignItem({
    Key key,
    this.topTxt,
    this.middleIcon,
    this.bottomTxt,
    this.isSelect,

  }) : super(key: key);

  final String topTxt;

  final String middleIcon;

  final String bottomTxt;

  final bool isSelect;

  @override
  SignItemState createState() => SignItemState();

}

class SignItemState extends State<SignItem> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = (size.width-102)/4;
    double height = width * 80/63;
    return Container(
      width: (size.width-102)/4 ,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 9,),
      decoration: BoxDecoration(
        color: widget.isSelect ? Color(0xFF6205B3) : Color(0xFF3A067E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.topTxt,style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),

          Image.asset(widget.middleIcon,width: 25,height: 25,),

          Text(widget.isSelect ? '已领取' : widget.bottomTxt,softWrap: false,style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
        ],
      ),
    );
  }


}

