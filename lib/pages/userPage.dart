import 'package:caihong_app/base/view/base_state.dart';
import 'package:caihong_app/mock/video.dart';
import 'package:caihong_app/pages/myCollection.dart';
import 'package:caihong_app/pages/sharePage.dart';
import 'package:caihong_app/presenter/user_presenter.dart';
import 'package:caihong_app/style/style.dart';
import 'package:caihong_app/views/inviteCodePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import '../network/api/network_api.dart';
import '../utils/PreferenceUtils.dart';
import '../utils/alertDialogUtil.dart';
import '../utils/dialogUtil.dart';
import '../views/tiktokTabBar.dart';
import '../views/versionInfo.dart';
import 'blankPage.dart';
import 'buyVipPage.dart';
import 'chargePage.dart';
import 'homePage.dart';
import 'loginPage.dart';
import 'myBuyVideoPage.dart';

List<UserVideo> videoDataList = [];

@override
void dispose() {
  // TODO: implement dispose
}

class UserPage extends StatefulWidget {
  final bool canPop;
  final Function onPop;
  final Function onSwitch;

  const UserPage({Key key, this.canPop: false, this.onPop, this.onSwitch})
      : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends BaseState<UserPage, UserPresenter> {
  String account = "";

  String userVipMsg = '';

  int vipStatus;
  int cronNum;
  String userId;

  String version;

  @override
  void initState() {
    super.initState();
    // mPresenter.checkLoginStatus();
    getUserInfo();
  }

  void getUserInfo() async {



    await Future.wait([
        /// 当前用户是否是VIP，还是普通用户，金币余额
        PreferenceUtils.instance.getInteger('vipStatus').then((val){
          vipStatus = val;
        }),

        /// 当前用户的金币
        PreferenceUtils.instance.getInteger('cronNum').then((val){
          cronNum = val;
        }),

      /// 当前用户的ID
      PreferenceUtils.instance.getString('userId').then((val){
        userId = val;
      }),

      PackageInfo.fromPlatform().then((val) {
        version = val.version.split('.')[2];//获取当前的版本号
      }),

    ]).then((res){
      setState(() {
          if(vipStatus == 0){
            userVipMsg = '尊敬的非VIP用户，你当前的金币余额是 $cronNum';
          }else{
            userVipMsg = '尊敬的VIP用户，你当前的金币余额是 $cronNum';
          }
      });
    }).catchError((e){
      print('$e');
    });
  }

  void jumpLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (cxt) => LoginPage(),
    ));
  }

  void showAccount(String account) {
    setState(() {
      this.account = account;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetList = [];

    // 头像基本个人信息
    Widget avatar = Container(
      height: 90 + MediaQuery.of(context).padding.top,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20,top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              color: Colors.black,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif",
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: 140,
              height: 50,
              margin: EdgeInsets.only(left: 10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('隔壁老王',style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF)),),
                  SizedBox(height: 10),
                  Text('ID: $userId',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'PingFang SC-Medium',color: Color(0x80FFFFFF)),),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(right: 0,top: 18,bottom: 18,),
            padding: EdgeInsets.only(left: 16,right: 15,bottom: 8,top: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC560E7),
                  Color(0xFFD93B9F),
                ],
                stops: [0.1, 1.0],
              ),
            ),
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('绑定手机',style: TextStyle(fontSize: 16,fontWeight:FontWeight.w400,fontFamily: 'PingFang SC-Medium',color: Color(0xFFFFFFFF)),),
                  SizedBox(width: 8.5,),
                  Image.asset('lib/assets/images/next.png',width: 13,height: 13,),
                ],
              ),
            ),
          ),

        ],
      ),
    );
    widgetList.add(avatar);



    Widget goldText = Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(left: 100,top: 0,bottom: 12,right: 20,),
      child: Text(userVipMsg,style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400,fontFamily: 'PingFang SC-Medium',color: Color(0x80FFFFFF)),),
    );
    widgetList.add(goldText);

    // VIP 限时特惠广告
    Widget openVip = Container(
      height: 66,
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(left: 20,right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4F442A),
            Color(0xFFE2D3B1),
          ],
          stops: [0.1, 1.0],
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(width:0.2),
        image: DecorationImage(
          image: AssetImage('lib/assets/images/user_vip_background.png'),
          fit: BoxFit.fill, // 完全填充
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>BuyVipPage()));
            },
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 16,top: 8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text('VIP限时特惠  畅看全场',style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF)),),
                    SizedBox(height: 4,),
                    Text('开通VIP全场畅看  剩余可下载次数 0',style: TextStyle(fontSize: 12,color: Color(0xFFAC5AFF),fontWeight:FontWeight.w400,fontFamily: 'PingFang SC-Medium',),),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
    widgetList.add(openVip);

    // 金币充值 分享邀请  推广赚现金
    double shareItemWidth = (MediaQuery.of(context).size.width - 10 * 2 - 18 * 2)/3;
    Widget shareWidget = Container(
      margin: EdgeInsets.only(top: 12,left: 20,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        //交叉轴的布局方式，对于column来说就是水平方向的布局方式
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (cxt) => ChargePage(),
                  )
              );
            },
            child: Container(
              height: shareItemWidth,
              width: shareItemWidth,
              decoration: BoxDecoration(
                color: Color(0xFF211D38),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: Color(0xFFA25BF4),width:0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 9.5,),
                  Container(
                    width: 40.5,
                    child: Image.asset('lib/assets/images/share_earn_money.png',fit: BoxFit.cover,),
                  ),
                  SizedBox(height: 2,),
                  Text('金币充值',style: TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold,),),
                  SizedBox(height: 3,),
                  Text('冲得多送得多',textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Color(0xFFAC5AFF),fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,),),
                  SizedBox(height: 12.5,),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>SharePage()));
            },
            child: Container(
              height: shareItemWidth,
              width: shareItemWidth,
              decoration: BoxDecoration(
                color: Color(0xFF211D38),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: Color(0xFFA25BF4),width:0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    child: Image.asset('lib/assets/images/gold_medal.png',fit: BoxFit.cover,),
                  ),
                  SizedBox(height: 2,),
                  Text('分享邀请',style: TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold,),),
                  SizedBox(height: 3,),
                  Text('邀请好友可领VIP',style: TextStyle(fontSize: 12,color: Color(0xFFAC5AFF),fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,),),
                  SizedBox(height: 12.5,),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
            },
            child: Container(
              height: shareItemWidth,
              width: shareItemWidth,
              decoration: BoxDecoration(
                color: Color(0xFF211D38),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: Color(0xFFA25BF4),width:0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 9.5,),
                  Container(
                    width: 40,
                    child: Image.asset('lib/assets/images/gift.png',fit: BoxFit.cover,),
                  ),
                  SizedBox(height: 2,),
                  Text('推广赚现金',style: TextStyle(fontSize: 14,fontFamily: 'PingFang SC-Bold',color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold,),),
                  SizedBox(height: 2,),
                  Text('最高70%分成',style: TextStyle(fontSize: 12,color: Color(0xFFAC5AFF),fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,),),
                  SizedBox(height: 11.5,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    widgetList.add(shareWidget);

    // 我的帖子  我的收藏  我的关注  原创入驻
    Widget mineModule = Container(
      height: 70,
      margin: EdgeInsets.only(top: 12,left: 20,right: 20),
      decoration: BoxDecoration(
        color: Color(0xFF211D38),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(width:0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/camera.png',width: 30,height: 30,),
                Text('我的帖子',style: TextStyle(fontSize: 14,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,),)
              ],
            ),
          ),


          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>MyCollection(),));
            },
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/collect.png',width: 30,height: 30,),
                Text('我的收藏',style: TextStyle(fontSize: 14,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,),),
              ],
            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
            },
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/user.png',width: 30,height: 30,),
                Text('我的关注',style: TextStyle(fontSize: 14,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,),)
              ],
            ),
          ),


          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
            },
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/video_icon.png',width: 30,height: 30,),
                Text('原创入驻',style: TextStyle(fontSize: 14,color: Color(0xFFFFFFFF),fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,),)
              ],
            ),
          ),
        ],
      ),
    );
    widgetList.add(mineModule);

    // 我的购买 下载缓存 填写邀请码 填写兑换码 帮助反馈 官方交流群
    List<Widget> itemList = [
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>MyBuyVideoPage(),));
        },
        child: ListTile(
          leading: Image.asset('lib/assets/images/shopping_car.png',width: 24,height: 24,),
          title: Text('我的购买'),
          trailing: Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
        ),
      ),
      Container(
          child: Divider(height: 1.0,indent: 0.0,color: Color(0x33FFFFFF),),
      ),


      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
        },
        child: ListTile(
          leading: Image.asset('lib/assets/images/down_load.png',width: 24,height: 24,),
          title: Text('下载缓存'),
          trailing: Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
        ),
      ),
      Container(
        child: Divider(height: 1.0,indent: 0.0,color: Color(0x33FFFFFF),),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>InviteCodePage()));
        },
        child: ListTile(
          leading: Image.asset('lib/assets/images/invite_num.png',width: 24,height: 24,),
          title: Text('填写邀请码'),
          trailing: Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
        ),
      ),
      Container(
        child: Divider(height: 1.0,indent: 0.0,color: Color(0x33FFFFFF),),
      ),
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
        },
        child: ListTile(
          leading: Image.asset('lib/assets/images/exchange.png',width: 24,height: 24,),
          title: Text('填写兑换码'),
          trailing: Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
        ),
      ),
      Container(
        child: Divider(height: 1.0,indent: 0.0,color: Color(0x33FFFFFF),),
      ),
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
        },
        child: ListTile(
          leading: Image.asset('lib/assets/images/help.png',width: 24,height: 24,),
          title: Text('帮助反馈'),
          trailing: Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
        ),
      ),
      Container(
        child: Divider(height: 1.0,indent: 0.0,color: Color(0x33FFFFFF),),
      ),
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
        },
        child: ListTile(
          leading: Image.asset('lib/assets/images/telegram.png',width: 24,height: 24,),
          title: Text('官方交流群'),
          trailing: Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
        ),
      ),
      Container(
        child: Divider(height: 1.0,indent: 0.0,color: Color(0x33FFFFFF),),
      ),
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>Blank()));
        },
        child: ListTile(
          leading: Image.asset('lib/assets/images/setting.png',width: 24,height: 24,),
          title: Text('设置'),
          trailing: Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
        ),
      ),
      Container(
        child: Divider(height: 1.0,indent: 0.0,color: Color(0x33FFFFFF),),
      ),
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>VersionInfo(channel: Api.cno,version: version,)));
        },
        child: ListTile(
          leading: Icon(Icons.voicemail,),//Image.asset('lib/assets/images/setting.png',width: 24,height: 24,),
          title: Text('版本信息'),
          trailing: Image.asset('lib/assets/images/next.png',width: 18,height: 18,),
        ),
      ),
    ];
    Widget bottomContain = ListView.builder(
      shrinkWrap:true,//范围内进行包裹（内容多高ListView就多高）
      physics:NeverScrollableScrollPhysics(),//禁止滚动
      itemCount:itemList.length,
      itemBuilder:(context,index){
        return itemList[index];
      }
    );

    widgetList.add(
      Container(
        color: Color(0xFF211D38),
        margin: EdgeInsets.only(left: 20,right: 20,top: 12,bottom: 10),
        child: bottomContain,
      ),
    );

    Size size = MediaQuery.of(context).size;


    return WillPopScope(
      onWillPop: (){
        Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (context) => new HomePage(type: TikTokPageTag.firstPage)),
              (route) => route == null,
        );
        return Future(() => true);
      },
      child: Container(
        color: Color(0xFF060123),
        constraints: BoxConstraints(
          minWidth: size.width,
          minHeight: size.height,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: widgetList,
          ),
        ),
      ),
    );
  }

  @override
  UserPresenter createPresenter() {
    return UserPresenter();
  }
}

class _UserTag extends StatelessWidget {
  final String tag;

  const _UserTag({
    Key key,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag ?? '标签',
        style: StandardTextStyle.smallWithOpacity,
      ),
    );
  }
}

class _UserVideoTable extends StatelessWidget {
  const _UserVideoTable({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget gd = GridView.count(
      //水平子Widget之间间距
      crossAxisSpacing: 10.0,
      //垂直子Widget之间间距
      mainAxisSpacing: 10.0,
      //GridView内边距
      padding: EdgeInsets.all(20.0),
      //一行的Widget数量
      crossAxisCount: 2,
      //子Widget宽高比例
      childAspectRatio: 1.0,
      //子Widget列表
      children: getWidgetList(),
    );

    return Column(
      children: <Widget>[
        Container(
          color: ColorPlate.back1,
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _PointSelectTextButton(true, '作品'),
              _PointSelectTextButton(false, '关注'),
              _PointSelectTextButton(false, '喜欢'),
            ],
          ),
        ),
        Container(height: 300, width: double.infinity, child: gd),
      ],
    );
  }
}

class _PointSelectTextButton extends StatelessWidget {
  final bool isSelect;
  final String title;
  final Function onTap;

  const _PointSelectTextButton(
    this.isSelect,
    this.title, {
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isSelect
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: ColorPlate.orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                )
              : Container(),
          Container(
            padding: EdgeInsets.only(left: 2),
            child: Text(
              title,
              style: isSelect
                  ? StandardTextStyle.small
                  : StandardTextStyle.smallWithOpacity,
            ),
          )
        ],
      ),
    );
  }
}

List<String> getDataList() {
  List<String> list = [];
  for (int i = 0; i < 100; i++) {
    list.add(i.toString());
  }
  return list;
}

List<Widget> getWidgetList() {
  return getDataList().map((item) => getItemContainer(item)).toList();
}

Widget getItemContainer(String item) {
  return Container(
    child: AspectRatio(
      aspectRatio: 3 / 4.0,
      child: Container(
        decoration: BoxDecoration(
          color: ColorPlate.darkGray,
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(
          '作品',
          style: TextStyle(
            color: Colors.white.withOpacity(0.1),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ),
  );
}

class TextGroup extends StatelessWidget {
  final String title, tag;
  final Color color;

  const TextGroup(
    this.title,
    this.tag, {
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: StandardTextStyle.big.apply(color: color),
          ),
          Container(width: 4),
          Text(
            tag,
            style: StandardTextStyle.smallWithOpacity.apply(
              color: color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
