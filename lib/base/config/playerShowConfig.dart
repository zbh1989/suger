import 'package:fijkplayer_skin/fijkplayer_skin.dart';

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