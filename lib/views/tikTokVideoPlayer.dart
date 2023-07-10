import 'package:caihong_app/mock/video.dart';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

class VideoListController {
  /// 构造方法
  VideoListController();

  /// 目前的视频序号
  ValueNotifier<int> index = ValueNotifier<int>(0);

  /// 视频列表
  List<FijkPlayer> playerList = [];

  FijkPlayer currentPlayer;

  bool isPlaying;

  Map<String,dynamic> currentVideoInfo = Map();

  /// 捕捉滑动，实现翻页
  void setPageContrller(PageController pageController) {
    pageController.addListener(() {
      var p = pageController.page;
      if (p % 1 == 0) {
        int target = p ~/ 1;
        if (index.value == target) return;
        // 播放当前的，暂停其他的
        var oldIndex = index.value;
        var newIndex = target;
        playerOfIndex(oldIndex).seekTo(0);
        playerOfIndex(oldIndex).pause();
        playerOfIndex(newIndex).start();
        // 完成
        index.value = target;
      }
    });
  }

  /// 获取指定index的player
  FijkPlayer playerOfIndex(int index) => playerList[index];

  /// 视频总数目
  int get videoCount => playerList.length;

  /// 在当前的list后面继续增加视频，并预加载封面
    addVideoInfo(List<Map<String,dynamic>> shortVideoInfoList) {
      shortVideoInfoList.forEach((ele) {
        playerList.add(
          FijkPlayer()
            ..setDataSource(
              ele['videoUrl'],
              autoPlay: playerList.length == 0,
              showCover: true,
            )
            ..setLoop(0),
        );
      });

  }

  /// 初始化
  init(PageController pageController, List<Map<String,dynamic>> shortVideoInfoList) {
    // addVideoInfo(shortVideoInfoList);
    setPageContrller(pageController);

    if (index.value != null) {
      currentPlayer = playerList[index.value];
      isPlaying = currentPlayer.state == FijkState.started;
    }
  }

  /// 销毁全部
  void dispose() {
    // 销毁全部
    for (var player in playerList) {
      player.dispose();
      player.release();
    }
    playerList = [];
  }
}
