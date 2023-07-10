import 'dart:async';
import 'package:caihong_app/style/style.dart';
import 'package:caihong_app/views/openVipDialog.dart';
import 'package:caihong_app/views/tikTokVideoGesture.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/dialogUtil.dart';

///
/// TikTok风格的一个视频页组件，覆盖在video上，提供以下功能：
/// 播放按钮的遮罩
/// 单击事件
/// 点赞事件回调（每次）
/// 长宽比控制
/// 底部padding（用于适配有沉浸式底部状态栏时）
///
class TikTokVideoPage extends StatefulWidget {

  final Map<String,dynamic> videoInfo;
  final double aspectRatio;
  final String tag;
  final double bottomPadding;

  final Widget rightButtonColumn;
  final Widget userInfoWidget;

  final bool hidePauseIcon;

  final Function onAddFavorite;
  final backgroundImage;
  final bool hasPermission;
  final int videoStartTime;
  final int videoEndTime;

  const TikTokVideoPage({
    Key key,
    this.bottomPadding: 16,
    this.tag,
    this.rightButtonColumn,
    this.userInfoWidget,
    this.onAddFavorite,
    this.videoInfo,
    this.aspectRatio: 9 / 16.0,
    this.hidePauseIcon: false,
    this.backgroundImage,
    this.hasPermission,
    this.videoStartTime,
    this.videoEndTime,
  }) : super(key: key);


  @override
  TikTokVideoPageState createState() => TikTokVideoPageState();
}

class TikTokVideoPageState extends State<TikTokVideoPage> {

  final FijkPlayer player = FijkPlayer();

  /// 流监听器
  StreamSubscription _currentPosSubs;

  bool isShowDialog = false;

  int showTime = 0;

  int defaultVideoStartTime = 0;

  int defaultVideoEndTime = 30;

  @override
  void initState(){
    super.initState();

    player.addListener(_playerListener);

    // 设置播放视频地址，非自动播放，渲染视频第一帧
    player.setDataSource(widget.videoInfo['playPath'],autoPlay: true,showCover: true,);
    if(widget.videoStartTime != null && widget.videoStartTime > 0 && widget.videoEndTime != null && widget.videoEndTime > 0){
      player.seekTo(widget.videoStartTime*1000);
      defaultVideoEndTime = widget.videoEndTime;
    }else{
      player.seekTo(135*1000);
      defaultVideoEndTime = 45;
    }
  }

  void _playerListener() {
    /// 获取展示的时长

    String currentDuration;

    /// 接收流
    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      currentDuration = v.toString().substring(0,v.toString().indexOf("."));
      // 获取播放秒数
      String second = currentDuration.split(":")[2];
      if(double.parse(second) == defaultVideoEndTime && !isShowDialog){
        /// 播放状态
        if (player.value.state == FijkState.started){
          setState(() {
            player.pause();
            isShowDialog = true;
            showTime++;
          });
        }
      }

      if (isShowDialog && showTime == 1){
        getShowDialog(context);
        showTime++;
      }

    });
  }

  @override
  void dispose() {
    super.dispose();
    player.removeListener(_playerListener);
    player.release();
    if(_currentPosSubs != null){
      _currentPosSubs.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {

    // 右边的按钮列表
    Widget rightButtons = widget.rightButtonColumn ?? Container();
    // 用户信息
    Widget userInfo = widget.userInfoWidget ??
        VideoUserInfo(
          bottomPadding: widget.bottomPadding,
        );
    // 视频加载的动画
    // Widget videoLoading = VideoLoadingPlaceHolder(tag: widget.tag);
    // 视频播放页
    Widget videoContainer = TikTokVideoGesture(
      onAddFavorite: widget.onAddFavorite,
      onSingleTap: () async {
        if (isShowDialog){
          if (player.state == FijkState.started) {
            player.pause();
          }
          getShowDialog(context);

          showTime++;
        }else{
          if (player.state == FijkState.started) {
            await player.pause();
          } else {
            await player.start();
          }
          setState(() {});
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            color: Color(0xFF060123),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Center(
                  child: FijkView(
                    fit: FijkFit.contain,
                    player: player,
                    color: Colors.black,
                    panelBuilder: (_, __, ___, ____, _____) => Container(),
                  ),
                ),
              ),
            ),
          ),
          // TODO:状态问题
          // hidePauseIcon
          //     ? Container()
          //     : Container(
          //         height: double.infinity,
          //         width: double.infinity,
          //         alignment: Alignment.center,
          //         child: Icon(
          //           Icons.play_circle_outline,
          //           size: 120,
          //           color: Colors.white.withOpacity(0.4),
          //         ),
          //       ),
        ],
      ),
    );
    Widget body = Container(
      child: Stack(
        children: <Widget>[
          videoContainer,
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomRight,
            child: rightButtons,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            child: userInfo,
          ),
        ],
      ),
    );
    return body;
  }


  /// 开通会员弹窗内容
  void getShowDialog(BuildContext context){
    Size size = MediaQuery.of(context).size;
    EdgeInsets ei = MediaQuery.of(context).padding;
    double width = size.width;
    double imgWidth = width - 35;
    double imgHeight = imgWidth * 468 / 348;
    showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogUtil(
          marginTop: (size.height + ei.top + ei.bottom - imgHeight)/2 + 30,
          content: OpenVipDialog(),
          onClose: (){Navigator.of(context).pop();},
        );
      },
    );
  }

}



class VideoLoadingPlaceHolder extends StatelessWidget {
  const VideoLoadingPlaceHolder({
    Key key,
    @required this.tag,
  }) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: <Color>[
            Colors.blue,
            Colors.green,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitWave(
            size: 36,
            color: Colors.white.withOpacity(0.3),
          ),
          Container(
            padding: EdgeInsets.all(50),
            child: Text(
              tag ?? 'Unknown Tag',
              style: StandardTextStyle.normalWithOpacity,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoUserInfo extends StatelessWidget {
  final String desc;

  const VideoUserInfo({
    Key key,
    @required this.bottomPadding,
    this.desc,
  }) : super(key: key);

  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        bottom: bottomPadding,
      ),
      margin: EdgeInsets.only(right: 80,bottom: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '@隔壁老王',
            style: StandardTextStyle.big,
          ),
          Container(height: 10),
          Text(
            desc ?? '',
            style: StandardTextStyle.normal,
          ),
          Container(height: 6),
        ],
      ),
    );
  }

}