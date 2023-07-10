import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;
import 'package:flutter/material.dart';

import '../../views/customFijkWidgetBottom.dart';
import '../../views/customFijkWidgetBottom_bak2.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SimpleVideoPage(),
    );
  }
}

// show 表示只导出 VideoSourceFormat 类

class SimpleVideoPage extends StatefulWidget {
  const SimpleVideoPage({Key key}) : super(key: key);

  @override
  _SimpleVideoPageState createState() => _SimpleVideoPageState();
}

class _SimpleVideoPageState extends State<SimpleVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VideoDetailPage(),
      ),
    );
  }
}

//定制UI配置项
class PlayerShowConfig implements ShowConfigAbs {
  //自动播放下一个视频
  @override
  bool autoNext = false;
  //底部进度条
  @override
  bool bottomPro = true;
  //剧集显示
  @override
  bool drawerBtn = false;
  //进入页面自动播放
  @override
  bool isAutoPlay = false;
  //是否有锁
  @override
  bool lockBtn = false;
  //下一个按钮
  @override
  bool nextBtn = false;
  //显示封面 但是貌似没有效果
  @override
  bool showCover = true;
  //播放速度 1.0倍 2.0倍
  @override
  bool speedBtn = false;
  @override
  bool stateAuto = true;
  //顶部标题栏
  @override
  bool topBar = true;
}

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key key}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with SingleTickerProviderStateMixin {

  final FijkPlayer player = FijkPlayer();

  Map<String, List<Map<String, dynamic>>> videoList = {
    "video":[
      {
        "name":"线路资源一",
        "list":[
          {
            "url": "https://img.daili99.vip/SP/GC/XSLL/26/index.m3u8",
            "name": "视频名称"
          },
        ]
      }
    ]
  };

  VideoSourceFormat _videoSourceTabs;
  int _currTabIndex = 0;
  int _currActiveIdx  = 0;
  ShowConfigAbs vConfig = PlayerShowConfig();

  FijkFit ar4_3 = FijkFit(aspectRatio: 26 / 58);


  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //格式化json转对象
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    //这句不能省，必须有
    // speed = 1.0;

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FijkView(
          height: 260,
          color: Colors.black,
          fit: FijkFit.contain,
          player: player,
          panelBuilder: (
              FijkPlayer player,
              FijkData data,
              BuildContext context,
              Size viewSize,
              Rect texturePos){
            return CustomFijkWidgetBottom(
              player: player,
              buildContext: context,
              viewSize: viewSize,
              texturePos: texturePos,
              onTapPlayer: (playerState){
                // oldFijkstate = playerState;
              },
              onEntryFullScreen:(map){
                bool _isFullScreen = map['isFullScreen'];
                // oldFijkstate = map['playerState'];

                setState(() {
                  if (player.state == FijkState.started) {
                    player.pause();
                    /// 播放状态，进度条一直刷新，需要暂停播放器，让进度条暂时不刷新
                    // oldFijkstate = player.state;
                  }

                  if(_isFullScreen){
                    player.exitFullScreen();
                  }else{
                    player.enterFullScreen();
                  }
                  // isFullScreen = !_isFullScreen;
                });
              },
              // isFullScreen: isFullScreen,
              // oldFijkstate:oldFijkstate,
              hasPermission: false,
            );
          },
        )
      ],
    );
  }
}