import 'dart:async';
import 'dart:math';

import 'package:caihong_app/utils/toast.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

import '../utils/dialogUtil.dart';
import 'fijkPanelCenterController.dart';
import 'openVipDialog.dart';

class CustomFijkPanel extends StatefulWidget {
  final FijkPlayer player;
  final BuildContext buildContext;
  final Size viewSize;
  final Rect texturePos;
  final String videoTitle;
  final bool isNextNumber;
  final bool isPlayAd;
  final bool hasPermission;
  final int showLevel;
  final int videoStartTime;
  final int videoEndTime;
  final int baseVideoStartTime;
  final int baseVideoEndTime;
  final String videoUrl;
  final void Function() onPlayAd;
  final void Function() onBack;
  final void Function() onError;
  final void Function() onVideoEnd;
  final void Function() onVideoPrepared;
  final void Function() onVideoTimeChange;
  final void Function() noPermissionDialog;

  // ValueChanged noPermissionDialog;

  /// 播放器控制器具体到源代码目录查看参考fijkplayer\lib\ui\panel.dart
  /// ```
  /// @param {FijkPlayer} player -
  /// @param {BuildContext} buildContext -
  /// @param {Size} viewSize -
  /// @param {Rect} texturePos -
  /// @param {String} videoTitle -
  /// @param {bool} isNextNumber - 全屏后是否显示下一集按钮
  /// @param {bool} isPlayAd - 是否显示广告按钮
  /// @param {void Function()?} onPlayAd - 播放广告
  /// @param {void Function()?} onBack - 返回按钮
  /// @param {void Function()?} onError - 视频错误点击刷新
  /// @param {void Function()?} onVideoEnd - 视频结束
  /// @param {void Function()?} onVideoPrepared - 视频完成后台任务到稳定期
  /// @param {void Function()?} onVideoTimeChange - 视频时间更新
  /// @param hasPermission;  是否有权限观看全部视频
  /// ```
  CustomFijkPanel({
    @required this.player,
    @required this.buildContext,
    @required this.viewSize,
    @required this.texturePos,
    @required this.videoTitle,
    this.showLevel,
    this.hasPermission,
    this.isNextNumber = false,
    this.isPlayAd = false,
    this.onPlayAd,
    this.onBack,
    this.onError,
    this.onVideoEnd,
    this.onVideoPrepared,
    this.onVideoTimeChange,
    this.noPermissionDialog,
    this.baseVideoStartTime,
    this.baseVideoEndTime,
    this.videoStartTime,
    this.videoEndTime,
    this.videoUrl,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomFijkPanelState();
  }
}

class _CustomFijkPanelState extends State<CustomFijkPanel> {
  FijkPlayer get player => widget.player;

  bool get isFullScreen => player.value.fullScreen;

  /// 总时间
  Duration _duration = Duration();

  /// 动画时间
  Duration get _animatedTime => Duration(milliseconds: 400);

  /// 是否在播放
  bool _playing = false;

  /// 是否显示暂停按钮
  bool _offstage = true;

  /// 后台任务是否初步执行完成是用于正在加载中的状态
  bool _prepared = false;

  /// 视频状态是否执行完成成为稳定状态与_prepared不一致
  bool _playStatePrepared = false;

  bool _isPlayCompleted = false;

  /// 是否在加载中
  bool _buffering = false;
  int _bufferingPro = 0;
  StreamSubscription _bufferingSubs;

  /// 拖动快进的时间 -1不显示
  double _seekPos = -1;

  /// 当前时间
  Duration _currentPos = Duration();
  StreamSubscription _currentPosSubs;

  /// 预加载时间
  Duration _bufferPos = Duration();
  StreamSubscription _bufferPosSubs;
  StreamSubscription<int> _bufferPercunt;

  /// 控制器隐藏
  Timer _hideTimer;
  bool _hideStuff = true;

  /// 视频错误
  bool _isPlayError = false;

  /// 声音 0-1范围
  double _currentVolume = 0;
  bool _showVolume = false;

  /// 屏幕亮度 0-1范围
  double _currentBrightness = 0;
  bool _showBrightness = false;

  int sendCount = 0;

  ///二倍速播放
  bool isShowDouble = false;

  /// 显示弹窗提示
  bool isShowDialog = false;

  /// 弹窗展示次数
  int showTime = 0;

  /// 默认试看结束时间
  int defaultEndTime = 30;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData(){
    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;
    _prepared = player.value.prepared;
    var playerState = player.state;
    _playing = playerState == FijkState.started;
    _isPlayError = playerState == FijkState.error;
    _isPlayCompleted = playerState == FijkState.completed;
    _playStatePrepared = playerState == FijkState.prepared;
    _buffering = player.isBuffering;
    initScreenBrightness();
    // FijkVolume.setUIMode(FijkVolume.hideUIWhenPlayable);
    /*VolumeController().getVolume().then((volume) {
      print("多媒体声音$volume");
      _currentVolume = volume;
    });*/

    /// 由于变化太小无法监听到基本监听物理按键调整的情况
    /*VolumeController().listener((volume) {
      print("多媒体声音变化$volume");
      _currentVolume = volume;
    });*/
    player.addListener(_playerValueChanged);

    /// 当前进度
    _currentPosSubs = player.onCurrentPosUpdate.listen((value) {
      setState(() {
        _currentPos = value;
        if (_buffering == true) {
          _buffering = false; // 避免有可能出现已经播放时还在显示缓冲中
        }
        if (_playing == false) {
          _playing = true; // 避免播放在false时导致bug
        }

        /// 金币无权限没有试看
        if(widget.showLevel == 2){
          if(!widget.hasPermission){
            if(_playing){
              player.pause();
            }
            if(player.value.fullScreen){
              player.exitFullScreen();
            }
            widget.onVideoTimeChange?.call();
          }
        }else if(widget.showLevel == 3){
          /// 试看30秒，超过提示
          String durrentPos = value.toString().substring(0,value.toString().indexOf("."));
          /// 获取播放秒数
          var timeArr = durrentPos.split(":");
          String second = timeArr[2];
          String minute = timeArr[1];
          String hour = timeArr[0];
          double totalSecond = 0;
          if(hour != null ){
            totalSecond += double.parse(hour) * 3600;
          }
          if(minute != null){
            totalSecond += double.parse(minute) * 60;
          }
          if(second != null){
            totalSecond += double.parse(second);
          }
          if(totalSecond >= defaultEndTime && !widget.hasPermission && showTime == 0){
            /// 播放状态
            if (player.value.state == FijkState.started){
              player.pause();
            }
            if(player.value.fullScreen){
              player.exitFullScreen();
            }
            widget.noPermissionDialog.call();
            isShowDialog = true;
            showTime++;
          }
        }


      });

      // 每n次才进入一次不然太频繁发送处理业务太复杂则会增加消耗
      if (sendCount % 50 == 0) {
        widget.onVideoTimeChange?.call();
      }
      sendCount++;

    });

    /// 视频预加载进度
    _bufferPosSubs = player.onBufferPosUpdate.listen((value) {
      setState(() {
        _bufferPos = value;
      });
    });

    /// 视频卡顿回调
    _bufferingSubs = player.onBufferStateUpdate.listen((value) {
      print("视频加载中$value");
      if (value == false && _playing == false) {
        _playOrPause();
      }
      setState(() {
        _buffering = value;
      });
    });

    /// 视频卡顿当缓冲量回调
    _bufferPercunt = player.onBufferPercentUpdate.listen((value) {
      setState(() {
        _bufferingPro = value;
      });
    });

  }

  @override
  void dispose() {
    player.removeListener(_playerValueChanged);
    VolumeController().removeListener();
    _hideTimer?.cancel();
    _currentPosSubs.cancel();
    _bufferPosSubs.cancel();
    _bufferingSubs.cancel();
    _bufferPercunt.cancel();
    ScreenBrightness.resetScreenBrightness().catchError((error) {
      print("重置亮度-异常$error");
    });
    super.dispose();
  }

  Future<void> initScreenBrightness() async {
    double _brightness = 0.5;
    try {
      _brightness = await ScreenBrightness.initial;
      // print("获取屏幕亮度$_brightness");
    } catch (error) {
      print("获取屏幕亮度-异常$error");
    }
    setState(() {
      _currentBrightness = _brightness;
    });
  }

  void _playerValueChanged() {
    var value =   player.value;
    if (value.duration != _duration) {
      setState(() {
        _duration = value.duration;
      });
    }

    if(player.state == FijkState.prepared){
      if(!widget.hasPermission){
        if(widget.videoStartTime >= 0 && widget.videoEndTime > 0){
          defaultEndTime = widget.videoEndTime;
        }else if(widget.baseVideoStartTime >= 0 && widget.baseVideoEndTime > 0){
          defaultEndTime = widget.baseVideoEndTime;
        }
      }
    }
    var valueState = value.state;

    var playing = (valueState == FijkState.started);
    var prepared = value.prepared;
    var isPlayError = valueState == FijkState.error;
    var completed = valueState == FijkState.completed;
    if (isPlayError != _isPlayError ||
        playing != _playing ||
        prepared != _prepared ||
        completed != _isPlayCompleted) {
      setState(() {
        _isPlayError = isPlayError;
        _playing = playing;
        _prepared = prepared;
        _isPlayCompleted = completed;
      });
    }

    /// [value.prepared]不会等于[playStatePrepared]所以单独判断
    bool playStatePrepared = valueState == FijkState.prepared;
    if (_playStatePrepared != playStatePrepared) {
      if (playStatePrepared) {
        widget.onVideoPrepared?.call();
      }
      _playStatePrepared = playStatePrepared;
    }
    bool isPlayCompleted = valueState == FijkState.completed;
    if (isPlayCompleted) {
      print("视频状态结束是否还有下一集${widget.isNextNumber}");
      if (widget.isNextNumber) {
        widget.onVideoEnd?.call();
      } else {
        _isPlayCompleted = isPlayCompleted;
      }
    }
  }

  /// 播放开始
  void _playOrPause() {
    if(widget.showLevel == 2){ /// 金币播放
      if(!widget.hasPermission){
        widget.noPermissionDialog.call();
      }else{
        if (_playing == true) {
          player.pause();
          _offstage = false;
        } else {
          player.start();
          _offstage = true;
        }
      }
    }else if(widget.showLevel == 3){  ///  vip播放
      if (isShowDialog){
        if (_playing == true) {
          player.pause();
          _offstage = false;
        }
        if(player.value.fullScreen){
          player.exitFullScreen();
        }
        widget.noPermissionDialog.call();
        showTime++;

      }else{
        if (_playing == true) {
          player.pause();
          _offstage = false;
        } else {
          player.start();
          _offstage = true;
        }
      }
    }else{ /// 免费
      if (_playing == true) {
        player.pause();
        _offstage = false;
      } else {
        player.start();
        _offstage = true;
      }
    }


    /// 原来逻辑，上面为新加逻辑
    /*if (_playing == true) {
      player.pause();
    } else {
      player.start();
    }*/

  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 10), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  /// 控制器显示隐藏
  void _cancelAndRestartTimer() {
    if (_hideStuff == true) {
      _startHideTimer();
    }
    setState(() {
      _hideStuff = !_hideStuff;
    });
  }

  /// 时间转换显示
  String _duration2String(Duration duration) {
    if (duration.inMilliseconds < 0) {
      return "00:00";
    }
    String twoDigits(int n) {
      if (n >= 10) {
        return "$n";
      } else {
        return "0$n";
      }
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    int inHours = duration.inHours;
    if (inHours > 0) {
      return "$inHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  /// 快进视频时间
  void _onVideoTimeChangeUpdate(double value) {
    if(widget.hasPermission){
      return;
    }
    if (_duration.inMilliseconds < 0 ||
        value < 0 ||
        value > _duration.inMilliseconds) {
      return;
    }
    _startHideTimer();
    setState(() {
      _seekPos = value;
    });
  }

  /// 快进视频松手开始跳时间
  void _onVideoTimeChangeEnd(double value) {
    if(!widget.hasPermission){
      return;
    }

    var time = _seekPos.toInt();

    /// 拖拽超过30秒提示充值
    if(time >= defaultEndTime){
      if (!widget.hasPermission){
        if (_playing == true) {
          player.pause();
        }
        if(player.value.fullScreen){
          player.exitFullScreen();
          isShowDialog = true;
          widget.noPermissionDialog();
          showTime++;
        }else{
          isShowDialog = true;
          widget.noPermissionDialog();
          showTime++;
        }
        return ;
      }
    }

    _currentPos = Duration(milliseconds: time);
    print("跳转时间$time ${_duration.inMilliseconds}");
    player.seekTo(time).then((value) {
      if (!_playing && widget.hasPermission) {
        player.start();
      }
    });

    setState(() {
      _seekPos = -1;
    });
  }

  /// 获取视频当前时间, 如拖动快进时间则显示快进的时间
  double getCurrentVideoValue() {
    double duration = _duration.inMilliseconds.toDouble();
    double currentValue;
    if (_seekPos > 0) {
      currentValue = _seekPos;
    } else {
      currentValue = _currentPos.inMilliseconds.toDouble();
    }
    currentValue = min(currentValue, duration);
    currentValue = max(currentValue, 0);
    return currentValue;
  }

  /// 顶部栏
  Widget _buildTopmBar() {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          opacity: _hideStuff ? 0 : 1,
          duration: _animatedTime,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // 渐变位置
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0], // [渐变起始点, 渐变结束点]
                // 渐变颜色[始点颜色, 结束颜色]
                colors: [
                  Color.fromRGBO(0, 0, 0, 1),
                  Color.fromRGBO(0, 0, 0, 0),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                !isFullScreen ? Container(width: 40) : _backBtn(),
                //标题
                // Expanded(
                //   child: Text(
                //     widget.videoTitle,
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 14,
                //     ),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
              ],
            ),
          ),
        ),

        /// 返回按钮 小屏幕状态下显示 或者错误播放等情况
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            children: <Widget>[
              isFullScreen ? Container() : _backBtn(),
            ],
          ),
        ),
      ],
    );
  }

  /// 中间区域
  Widget _buildCentetContext() {
    double currentValue = getCurrentVideoValue();
    return FijkPanelCenterController(
      size: Size(double.infinity, double.infinity),
      onTap: _playOrPause,
      onDoubleTap: _cancelAndRestartTimer,
      currentTime: currentValue,
      onTapUp: (e) {
        setState(() {

          if (isShowDialog && !widget.hasPermission){
            if (_playing == true) {
              player.pause();
              _offstage = false;
            }
            widget.noPermissionDialog();
            showTime++;
          }else{
            if (_playing == true) {
              player.pause();
              _offstage = false;
            }else{
              player.start();
              _offstage = true;
            }
          }

          isShowDouble = false;
          player.setSpeed(1.0);

        });
      },
      onTapDown: (e) {
        setState(() {
          isShowDouble = true;
          player.setSpeed(2.0);
        });
      },
      onHorizontalStart: _onVideoTimeChangeUpdate,
      onHorizontalChange: _onVideoTimeChangeUpdate,
      onHorizontalEnd: _onVideoTimeChangeEnd,
      currentBrightness: _currentBrightness,
      onLeftVerticalStart: (value) {
        setState(() {
          _showBrightness = true;
        });
      },
      onLeftVerticalChange: (value) {
        ScreenBrightness.setScreenBrightness(value);
        setState(() {
          _currentBrightness = value;
        });
      },
      currentVolume: _currentVolume,
      onLeftVerticalEnd: (value) {
        setState(() {
          _showBrightness = false;
        });
      },
      onRightVerticalStart: (value) {
        setState(() {
          _showVolume = true;
        });
      },
      onRightVerticalChange: (value) {
        VolumeController().setVolume(value, showSystemUI: false);
        // FijkVolume.setVol(value);
        setState(() {
          _currentVolume = value;
        });
      },
      onRightVerticalEnd: (value) {
        setState(() {
          _showVolume = false;
        });
      },
      builderChild: (context) {
        Widget videoLoading = Container(); // 视频缓冲
        if (_buffering) {
          videoLoading = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 25,
                height: 25,
                margin: EdgeInsets.only(bottom: 10),
                child: CircularProgressIndicator(
                  backgroundColor: Color.fromRGBO(250, 250, 250, 0.5),
                  valueColor: AlwaysStoppedAnimation(Colors.white70),
                ),
              ),
              Text(
                "缓冲中 $_bufferingPro %",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }
        return Stack(
          children: <Widget>[
            /// 中间内容目前没有东西展示
            AnimatedOpacity(
              opacity: _hideStuff ? 0 : 1,
              duration: _animatedTime,
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: videoLoading,
            ),

            /// 暂停按钮
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Offstage(
                offstage: _offstage,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset('lib/assets/images/video_pause.png',width: 40,height: 40,),
                  ),
                ),
              ),
            ),

            /// 快进时间
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Offstage(
                offstage: _seekPos == -1,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "${_duration2String(
                        Duration(milliseconds: _seekPos.toInt()),
                      )} / ${_duration2String(_duration)}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            /// 声音
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _showVolume ? 1 : 0,
                duration: _animatedTime,
                child: _buildVolumeOrBrightnessProgress(
                  type: 1,
                  value: _currentVolume,
                  maxValue: 1,
                ),
              ),
            ),

            /// 亮度
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _showBrightness ? 1 : 0,
                duration: _animatedTime,
                child: _buildVolumeOrBrightnessProgress(
                  type: 2,
                  value: _currentBrightness,
                  maxValue: 1,
                ),
              ),
            ),
            _getFlex(),
          ],
        );
      },
    );
  }

  _getFlex() {
    if (isShowDouble) {
      return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '倍速播放中',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.white,),//primary
            ),
          ]);
    } else {
      return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: []);
    }
  }

  /// 声音或亮度进度
  Widget _buildVolumeOrBrightnessProgress({
    @required int type,
    @required double value,
    @required double maxValue,
  }) {
    IconData iconData;
    if (type == 1) {
      iconData = value <= 0 ? Icons.volume_off_sharp : Icons.volume_up;
    } else {
      iconData = Icons.brightness_4;
    }
    double maxProgressWidth = 90;
    return Center(
      child: Container(
        width: 130,
        padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  iconData,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: maxProgressWidth,
              height: 3,
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: value / maxValue * maxProgressWidth,
                    height: 3,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 视频时间进度条
  Widget _buildVideoTimeBar() {
    double currentValue = getCurrentVideoValue();
    return FijkSlider(
      min: 0,
      max: _duration.inMilliseconds.toDouble(),
      value: currentValue,
      cacheValue: _bufferPos.inMilliseconds.toDouble(),
      colors: FijkSliderColors(
        playedColor: Color(0xff4075d1),
        cursorColor: Colors.white,
        baselineColor: Color(0xff807e7c),
        bufferedColor: Color(0xff6494e6),
      ),
      // onChangeStart: _onVideoTimeChangeUpdate,
      onChanged: _onVideoTimeChangeUpdate,
      onChangeEnd: _onVideoTimeChangeEnd,
    );
  }

  /// 底部栏
  AnimatedOpacity _buildBottomBar() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0 : 1,
      duration: _animatedTime,
      child: Container(
        height: isFullScreen ? 80 : 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // 渐变位置
            end: Alignment.bottomCenter,
            stops: [0, 1], // [渐变起始点, 渐变结束点]
            colors: [
              Color.fromRGBO(0, 0, 0, 0),
              Color.fromRGBO(0, 0, 0, 1),
            ], // 渐变颜色[始点颜色, 结束颜色]
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: isFullScreen ? 25 : 0,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: isFullScreen ? _buildVideoTimeBar() : null,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  /// 播放按钮
                  GestureDetector(
                    onTap: _playOrPause,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      color: Colors.transparent,
                      height: double.infinity,
                      child: Icon(
                        _playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  /// 下一集按钮(全屏下可以看到)
                  Offstage(
                    offstage: !widget.isNextNumber || !isFullScreen,
                    child: GestureDetector(
                      onTap: widget.onVideoEnd,
                      child: Container(
                        padding: EdgeInsets.only(right: 15),
                        color: Colors.transparent,
                        height: double.infinity,
                        child: Icon(
                          Icons.skip_next_sharp,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  /// 当前时长
                  Text(
                    _duration2String(_currentPos),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: !isFullScreen ? _buildVideoTimeBar() : null,
                    ),
                  ),

                  /// 总时长
                  Text(
                    _duration2String(_duration),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),

                  /// 全屏按钮
                  isFullScreen
                      ? SizedBox(width: 30)
                      : GestureDetector(
                    onTap: () {
                      player.enterFullScreen();
                      Future.delayed(Duration(seconds: 1), () {
                        setViewStatusBar(true);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      color: Colors.transparent,
                      height: double.infinity,
                      child: Icon(
                        isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 返回按钮
  Widget _backBtn() {
    return GestureDetector(
      onTap: widget.onBack,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Icon(
          Icons.chevron_left,
          size: 34,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 视频异常状态
  Widget _renderVideoStatusView() {
    var bgImg = BoxDecoration(
      color: Colors.black,
      // image: DecorationImage(
      //   fit: BoxFit.cover,
      //   image: AssetImage(
      //     "xxx.jpg", // 可以设置一个背景图
      //   ),
      // ),
    );
    if (_isPlayError) {
      /// 错误
      return GestureDetector(
        onTap: widget.onError,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: bgImg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Icon(
                  Icons.error_rounded,
                  color: Colors.white70,
                  size: 70,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "播放异常！",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: "刷新",
                      style: TextStyle(
                        color: Color(0xff79b0ff),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (widget.isPlayAd) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: bgImg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "要看广告",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "播放一段视频广告",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.5,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: widget.onPlayAd,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Color(0xff2d73ed),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "点击广告",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (!_prepared) {
      /// 加载中
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: bgImg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(bottom: 20),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white70,
                valueColor: AlwaysStoppedAnimation(Color(0xff79b0ff)),
              ),
            ),
            Text(
              "努力加载中...",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else if (_isPlayCompleted) {
      /// 是否显示播放完
      return GestureDetector(
        onTap: () {
          player.start();
          setState(() {
            _isPlayCompleted = false;
          });
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromRGBO(0, 0, 0, 0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.play_circle_outline_outlined,
                size: 30,
                color: Colors.white70,
              ),
              SizedBox(height: 10),
              Text(
                "重新播放",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  /// 设置页面全屏化显示隐藏状态栏和虚拟按键
  setViewStatusBar(bool isHide) {
    if (isHide) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays([
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPlayError || !_prepared || _isPlayCompleted || widget.isPlayAd) {
      /// 错误播放 | 没加载好 | 播放完成没有下一集
      return Stack(
        children: <Widget>[
          _renderVideoStatusView(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: _backBtn(),
            ),
          ),
        ],
      );
    } else {
      var viewSize = widget.viewSize;
      return Positioned.fromRect(
        rect: Rect.fromLTWH(0, 0, viewSize.width, viewSize.height),
        child: Column(
          children: <Widget>[
            _buildTopmBar(),
            Expanded(
              child: _buildCentetContext(),
            ),
            _buildBottomBar(),
          ],
        ),
      );
    }
  }



}