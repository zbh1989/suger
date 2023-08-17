import 'package:flutter/material.dart';

class VipCardPageView extends StatefulWidget {

  VipCardPageView({this.dataList,this.getCardItemInfo,this.openPayDialog,});

  ValueChanged getCardItemInfo;

  VoidCallback openPayDialog;

  final List dataList;

  @override
  VipCardPageViewState createState() => new VipCardPageViewState();
}

class VipCardPageViewState extends State<VipCardPageView> {

  static bool _isAddGradient = false;

  PageController controller = PageController(viewportFraction: 0.8, keepPage: true,initialPage: 1);


  /// 中间页下标
  int _cur = 0;

  List vipCardList;

  List<Widget> list = [];

  bool loaded = false;

  var decorationBox = DecoratedBox(
    decoration: _isAddGradient
        ? BoxDecoration(
      gradient: LinearGradient(
        begin: FractionalOffset.bottomRight,
        end: FractionalOffset.topLeft,
        colors: [
          Color(0x00000000).withOpacity(0.9),
          Color(0xff000000).withOpacity(0.01),
        ],
      ),
    )
        : BoxDecoration(),
  );

  @override
  void initState(){
    super.initState();
    vipCardList = widget.dataList;
    list.clear();
    list.add(Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 8.0,),
      child: GestureDetector(
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              VipCardItem(cardInfo: vipCardList[vipCardList.length - 1],openPayDialog:widget.openPayDialog),
            ],
          ),
        ),
      ),
    ));

    vipCardList.forEach((ele) {
      Widget eleWidget = Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 8.0,),
        child: GestureDetector(
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                VipCardItem(cardInfo: ele,openPayDialog:widget.openPayDialog),
              ],
            ),
          ),
        ),
      );
      list.add(eleWidget);
    });

    list.add(Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 8.0,),
      child: GestureDetector(
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              VipCardItem(cardInfo: vipCardList[0],openPayDialog:widget.openPayDialog),
            ],
          ),
        ),
      ),
    ));
    widget.getCardItemInfo(vipCardList[_cur]);
  }



  @override
  Widget build(BuildContext context) {


    Widget child = PageView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      onPageChanged: changePage,
      children: list,
    );

    Size size = MediaQuery.of(context).size;
    double imgWidth = (size.width - 48) * 0.8;
    double imgHeight = imgWidth * 152/319    ;

    return Container(
      // color: Colors.purpleAccent,
      child: SizedBox.fromSize(
        size: Size.fromHeight(imgHeight),
        child: child,
      ),
    );
  }

  //前页
  int preNum(){
    return _cur - 1>=0 ? _cur-1 : vipCardList.length - 1;
  }
//后页
  int nextNum(){
    return _cur + 1 < vipCardList.length ? _cur + 1 : 0;
  }

  void changePage(int page){
    int newIndex;
    if (page == list.length - 1 ) {
      newIndex = 1;
      controller.jumpToPage(newIndex);
    } else if (page == 0) {
      newIndex = list.length - 2;
      controller.jumpToPage(newIndex);
    } else {
      newIndex = page;
    }
    setState(() {
      _cur = newIndex - 1;
      widget.getCardItemInfo(vipCardList[_cur]);
    });
  }



  Color getVipCardColorInfo(int level){
    Color c;
    switch(level){
      case 1:
        c = Color(0xFF46454D);
        break;
      case 2:
        c = Color(0xFF6B76B9);
        break;
      case 3:
        c = Color(0xFF46454D);
        break;
      case 4:
        c = Color(0xFF8F6536);
        break;
      case 5:
        c = Color(0xFF51419A);
        break;
      case 6:
        c = Color(0xFFFFD96B);
        break;
      default:
        c = Colors.white60;
    }
    return c;
    /*return [
      {
        'name':'三日体验卡',
        'money': 19,
        'originalPrice': 39.9,
        'cardUrl':'lib/assets/images/vip/three_day_vip.png',
        'color':Color(0xFF46454D),
      },
      {
        'name':'周卡会员',
        'money': 50,
        'originalPrice': 72,
        'cardUrl':'lib/assets/images/vip/week_vip.png',
        'color':Color(0xFF6B76B9),
      },
      {
        'name':'月卡会员',
        'money': 88,
        'originalPrice': 168,
        'cardUrl':'lib/assets/images/vip/month_vip.png',
        'color':Color(0xFF46454D),
      },
      {
        'name':'季卡会员',
        'money': 100,
        'originalPrice': 300,
        'cardUrl':'lib/assets/images/vip/season_vip.png',
        'color':Color(0xFF8F6536),
      },
      {
        'name':'年卡会员',
        'money': 288,
        'originalPrice': 1098,
        'cardUrl':'lib/assets/images/vip/year_vip.png',
        'color':Color(0xFF51419A),
      },
      {
        'name':'至尊永久',
        'money': 398,
        'originalPrice': 1399,
        'cardUrl':'lib/assets/images/vip/superior_vip.png',
        'color':Color(0xFFFFD96B),
      },
    ];*/
  }

}


/**
 * VIP 卡片
 */
class VipCardItem extends StatelessWidget {

  VipCardItem({this.cardInfo,this.openPayDialog,});

  final Map<String,dynamic> cardInfo;


  VoidCallback openPayDialog;


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double imgWidth = (size.width - 48) * 0.8;
    double imgHeight = imgWidth * 152/319    ;

    Widget stack = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            // color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          width: imgWidth,
          height: imgHeight,
          margin: EdgeInsets.only(left: 0,right: 0,),
        ),
         Positioned(
          left: 0,
          top: 0,
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(cardInfo['icon'],height: imgHeight,width: imgWidth,fit: BoxFit.cover,),
          )
        ),
        Positioned(
          left: 24.5,
          top: 66,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(text: '￥',style: TextStyle(fontFamily:'PingFang SC-Medium',color: getVipCardColorInfo(cardInfo['levelNumber']),fontSize: 14,fontWeight: FontWeight.w400),),
                      TextSpan(text: cardInfo['sellingPrice'].toString(),style: TextStyle(fontFamily:'Swis721 BlkCn BT-Black',color: getVipCardColorInfo(cardInfo['levelNumber']),fontSize: 32,fontWeight: FontWeight.bold),),
                      TextSpan(text: '  原价:',style: TextStyle(fontFamily:'PingFang SC-Medium',color: getVipCardColorInfo(cardInfo['levelNumber']),fontSize: 8,fontWeight: FontWeight.w400),),
                      TextSpan(text: '￥'+ cardInfo['price'].toString(),style: TextStyle(fontFamily:'PingFang SC-Medium',color: getVipCardColorInfo(cardInfo['levelNumber']),fontSize: 8,fontWeight: FontWeight.w400,decoration: TextDecoration.lineThrough,decorationStyle: TextDecorationStyle.solid,decorationColor: getVipCardColorInfo(cardInfo['levelNumber'])),),
                    ]
                ),
                textDirection: TextDirection.ltr,
              ),

              Text('优惠价',style:TextStyle(fontFamily:'PingFang SC-Medium',color: getVipCardColorInfo(cardInfo['levelNumber']),fontSize: 12,fontWeight: FontWeight.w400),),
            ],
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: (){
        openPayDialog.call();
      },
      child: stack,
    );
  }


  Color getVipCardColorInfo(int level){
    Color c;
    switch(level){
      case 1:
        c = Color(0xFF46454D);
        break;
      case 2:
        c = Color(0xFF6B76B9);
        break;
      case 3:
        c = Color(0xFF46454D);
        break;
      case 4:
        c = Color(0xFF8F6536);
        break;
      case 5:
        c = Color(0xFF51419A);
        break;
      case 6:
        c = Color(0xFFFFD96B);
        break;
      default:
        c = Colors.white60;
    }
    return c;
  }


}