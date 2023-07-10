import 'package:caihong_app/presenter/watchPagePresenter.dart';
import 'package:caihong_app/views/tiktokTabBar.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import '../base/view/base_state.dart';
import '../pages/homePage.dart';
import '../utils/dialogUtil.dart';
import 'customFijkPanel.dart';
import 'openVipDialog.dart';

/**
 * 视频播放页面
 */
class WatchPage extends StatefulWidget {

  WatchPage({this.videoHeight,this.width,this.player,this.hasPermission,this.showLevel,});

  double videoHeight;

  double width;

  FijkPlayer player;

  bool hasPermission;

  int showLevel;

  @override
  WatchPageState createState() => WatchPageState();

}


class WatchPageState extends BaseState<WatchPage,WatchPagePresenter>{
  @override
  Widget build(BuildContext context) {
    return FijkView(
      height: widget.videoHeight,
      width: widget.width,
      player: widget.player,
      color: Colors.black,//Colors.purpleAccent,
      fit: FijkFit.contain,
      fsFit: FijkFit.contain,
      panelBuilder:  (FijkPlayer player, FijkData data, BuildContext context, Size viewSize, Rect texturePos) {
        return CustomFijkPanel(
          player: player,
          buildContext: context,
          viewSize: viewSize,
          texturePos: texturePos,
          videoTitle: 'xxx',
          isPlayAd: false,
          isNextNumber: false,
          hasPermission: widget.hasPermission,
          onPlayAd: () {
            /// 播放广告 isPlayAd true 才会显示点击后处理播放后再开始播放视频
          },
          onError: () async {
            await player.reset();
          },
          onBack: () {
            if(player.value.fullScreen){
              player.exitFullScreen();
            }else{
              Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(
                    builder: (context) => new HomePage(type: TikTokPageTag.firstPage)),
                    (route) => route == null,
              );
            }

            // Navigator.pop(context); // 如果需要做拦截返回则在此判断
          },
          onVideoEnd: () async {
            // 视频结束最后一集的时候会有个UI层显示出来可以触发重新开始
            await player.reset();
          },
          onVideoTimeChange: () {
            // 视频时间变动则触发一次，可以保存视频历史如不想频繁触发则在里修改 sendCount % 50 == 0
          },
          onVideoPrepared: () async {
            // 视频初始化完毕，如有历史记录时间段则可以触发快进
          },
          noPermissionDialog: () async {
            // 没有权限播放完整视频弹窗提示:
            setState(() {
              if(widget.showLevel == 2){
                // UseGoldDialog(gold: widget.gold,);

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

              }else if(widget.showLevel == 3){
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
            });
          },
        );
      },
      // panelBuilder: (FijkPlayer player, FijkData data, BuildContext context, Size viewSize, Rect texturePos) => Container(),
      /*panelBuilder:  (FijkPlayer player, FijkData data, BuildContext context, Size viewSize, Rect texturePos) {
        /// 使用自定义的布局
        return CustomFijkWidgetBottom(
          player: player,
          buildContext: context,
          viewSize: viewSize,
          texturePos: texturePos,
          onTapPlayer: (playerState){
            oldFijkstate = playerState;
          },
          onEntryFullScreen:(map){
            bool _isFullScreen = player.value.fullScreen;
            oldFijkstate = map['playerState'];

            setState(() {
              if (player.state == FijkState.started) {
                player.pause();
                /// 播放状态，进度条一直刷新，需要暂停播放器，让进度条暂时不刷新
                oldFijkstate = player.state;
              }

              if(_isFullScreen){
                player.exitFullScreen();
              }else{
                player.enterFullScreen();
              }
              isFullScreen = !_isFullScreen;
            });
          },
          isFullScreen: isFullScreen,
          oldFijkstate:oldFijkstate,
          hasPermission: hasPermission,
        );
      },*/
    );
  }

  @override
  WatchPagePresenter createPresenter() {
    return WatchPagePresenter();
  }

}