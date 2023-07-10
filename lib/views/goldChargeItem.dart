import 'package:flutter/material.dart';

class GoldChargeItem extends StatelessWidget {

  GoldChargeItem({this.money,this.gold,this.extraGold,this.desc,this.isSelect:0,this.selectItem});

  final int money;

  final int gold;

  final int extraGold;

  final String desc;

  final int isSelect;

  final ValueChanged selectItem;

  @override
  Widget build(BuildContext context) {
    Widget item = Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width:0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(isSelect == 1 ? 0xFFC560E7 : 0xFF060123 ),
            Color(isSelect == 1 ? 0xFF481090 : 0xFF060123),
          ],
          stops: [0.1, 1.0],
        ),
      ),
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF200E37),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10,right: 10),
                decoration: BoxDecoration(
                  border: Border.all(width:1),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFC560E7),
                      Color(0xFF481090),
                    ],
                    stops: [0.1, 1.0],
                  ),
                ),
                child: Text(desc,style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD96B),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      width: 26,
                      height: 26,
                      // padding: EdgeInsets.all(5),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFF9B721),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        width: 18,
                        height: 18,
                        child: Text('￥',style: TextStyle(fontSize: 13,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFBF790A)),),
                      ),
                    ),
                    Text('$gold',style: TextStyle(fontSize: 24,fontFamily: 'DIN-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Text('¥$money',style: TextStyle(fontSize: 15,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
              )
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: (){
        if(isSelect == 1){
          return ;
        }else{
          selectItem({'money':money,'gold':gold,'extraGold':extraGold});
        }

      },
      child: item,
    );
  }

}