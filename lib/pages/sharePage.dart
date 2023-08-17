import 'dart:async';
import 'dart:ui' as ui;
import 'package:caihong_app/pages/spreadRecordListPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../base/view/base_state.dart';
import '../presenter/sharePagePresenter.dart';
import '../utils/PreferenceUtils.dart';
import '../utils/toast.dart';


/**
 * 分享页面
 */
class SharePage extends StatefulWidget{

  @override
  SharePageState createState() => SharePageState();

}

class SharePageState extends BaseState<SharePage,SharePagePresenter>{
  
  String spreadCode;
  
  int spreadNum;

  String landingPage = 'http://www.baidu.com';

  ui.Image logoIcon;

  GlobalKey globalKey = GlobalKey();

  @override
  void initState(){
    super.initState();
    requestData();
  }

  void requestData() async {
    Future.wait([
      PreferenceUtils.instance.getString("spreadCode").then((value) => spreadCode = value), // 推广码
      PreferenceUtils.instance.getInteger("spreadNum").then((value) => spreadNum = value), // 推广数量
      PreferenceUtils.instance.getString("landingPage").then((value) => landingPage = value), // 推广落地页
      _loadLogo().then((value) => logoIcon = value,),
    ]).then((res){
      setState(() { });
    });
  }

  void refreshPage(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    Size size  = MediaQuery.of(context).size;

    // 背景图片
    Widget backgroundImg = Container(
      width: size.width,
      height: 310,
      decoration: BoxDecoration(
        color: Colors.green,
        image: DecorationImage(
          image: AssetImage('lib/assets/images/share/header_background.png'),
          fit: BoxFit.fill, // 完全填充
        ),
      ),
    );

    // 顶部
    Widget topHeader = Container(
      height: 40,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3D0363),
            Color(0x001A0258),
          ],
        ),
      ),
    );
    // list.add(topHeader);


    // 头部
    Widget headerTab = Container(
      margin: EdgeInsets.only(left: 14,right: 20),
      width: size.width - 34,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left_outlined),
          ),
          Text('分享推广',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 18,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>SpreadRecordListPage()));
            },
            child: Text('推广记录',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 16,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          ),
        ],
      ),
    );

    /// 分享推广信息
    Widget shareContent = Container(
      width: size.width - 40,
      height: 393.5,
      padding: EdgeInsets.only(bottom: 15,),
      decoration: BoxDecoration(
        color: Color(0xFF211D38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('颜射视频',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 32,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          Text('全球最大的原创真人视频平台',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 16,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),
          RepaintBoundary(
            key: globalKey,
            // child: Image.asset('lib/assets/images/share/erweima.png',width: 160,height: 160,),

            child:CustomPaint(
              size: Size.square(160),
              painter: QrPainter(
                errorCorrectionLevel: QrErrorCorrectLevel.M,
                // color: Macro.colorPrimary,
                color: Colors.white,
                data: landingPage??'推广落地页',
                version: QrVersions.auto,
                embeddedImage: logoIcon,
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size.square(64),
                ),
              ),
            ),

          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "我的推广码，",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.w400),),
                TextSpan(text: " $spreadCode ",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFAC5AFF),fontSize: 16,fontWeight: FontWeight.w400),),
              ]
            ),
          ),


          Text('累计邀请人数：$spreadNum人',style: TextStyle(fontFamily: 'PingFang SC-Bold',fontSize: 16,color: Color(0xFFFFFFFF),fontWeight: FontWeight.w400),),

        ],
      ),
    );

    Widget header = Stack(
      children: [
        Container(
          width: size.width,
          height: 499.5,
        ),
        Positioned(
          left: 0,
          top: 0,
          child: backgroundImg,
        ),
        Positioned(
          left: 0,
          top: 0,
          child: topHeader,
        ),
        Positioned(
          left: 0,
          top: 40,
          child: headerTab,
        ),
        Positioned(
          left: 20,
          top: 106,
          child: shareContent,
        ),
      ],
    );

    list.add(header);

    /// 保存二维码按钮
    Widget erWeiMaBtn = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 35,right: 35,top: 12,bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
      child: Text('保存二维码',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
    );

    Widget saveErWeiMaBtn = GestureDetector(
      onTap: () async {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          print(status);
          return;
        }

        BuildContext buildContext = globalKey.currentContext;
        if (null != buildContext) {
          RenderRepaintBoundary boundary = buildContext.findRenderObject();

          ui.Image image = await boundary.toImage();

          ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

          final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(), quality: 100,name: 'Lead_Image' + DateTime.now().toString());
          if (result['isSuccess'].toString() == 'true') {
            Toast.show('保存二维码至相册成功');
          } else {
            Toast.show('保存失败');
          }
        }
      },
      child: erWeiMaBtn,
    );

    /// 复制推广链接按钮
    Widget copyLink = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 35,right: 35,top: 12,bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
      child: Text('复制推广链接',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),
    );

    Widget copyLinkBtn = GestureDetector(
      onTap: () async {
        Clipboard.setData(ClipboardData(text: '$landingPage'));
        Toast.show('复制成功');
      },
      child: copyLink,
    );

    Widget btnWidget = Container(
      margin: EdgeInsets.only(top: 20,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          saveErWeiMaBtn,
          copyLinkBtn,
        ],
      ),
    );
    list.add(btnWidget);

    /// 规则说明
    /// 1.邀请1名好友成功注册即可获得3天VIP
    /// 2.邀请好友产生充值可获充值最高70%返利收益
    /// 如:邀请好友A,A充值100元年卡VIP,即可获得70元收益,可提现!
    /// 3邀请说明:点击[保存二维码或复制推广连接],获取专属推广链接,推荐分享给他其他人下载即可！
    ///
    Widget rule = Container(
      padding: EdgeInsets.only(left: 20,right: 20,top: 42,bottom: 42),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('规则说明',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFFFFFFFF)),),

          SizedBox(height: 12,),

          RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: "1.邀请1名好友成功注册即可获得，",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.w400),),
                  TextSpan(text: "3天VIP ",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFF5DA89),fontSize: 16,fontWeight: FontWeight.w400),),
                ]
            ),
          ),

          RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: "2.邀请好友产生充值可获充值",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.w400),),
                  TextSpan(text: "最高70%返利收益 ",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFF5DA89),fontSize: 18,fontWeight: FontWeight.bold),),
                ]
            ),
          ),

          Text('如:邀请好友A,A充值100元年卡VIP,即可获得70元收益,可提现!',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.w400,color: Color(0xFFFFFFFF)),),

          RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: "3邀请说明:点击",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.w400),),
                  TextSpan(text: "[保存二维码或复制推广连接]",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFF5DA89),fontSize: 18,fontWeight: FontWeight.bold),),
                  TextSpan(text: ",获取专属推广链接,推荐分享给他其他人下载即可！",style: TextStyle(fontFamily:'PingFang SC-Medium',color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.w400),),
                ]
            ),
          ),
        ],
      ),
    );
    list.add(rule);


    return Scaffold(
      body: Container(
        color: Color(0xFF060123),
        constraints: BoxConstraints(
          minWidth: size.width,
          minHeight: size.height,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: list,
          ),
        ),
      ),
    );
  }

  @override
  SharePagePresenter createPresenter() {
    return SharePagePresenter();
  }

  Future<ui.Image> _loadLogo() async {
    final completer = Completer<ui.Image>();

    final byteData = await rootBundle.load('lib/assets/images/logo.png');

    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);

    return completer.future;
  }
  
}