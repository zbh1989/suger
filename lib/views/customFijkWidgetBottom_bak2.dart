import 'dart:async';
import 'dart:math';
import 'package:caihong_app/pages/buyVipPage.dart';
import 'package:caihong_app/utils/dialogUtil.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'openVipDialog.dart';

class CustomFijkWidgetBottom2 extends StatefulWidget {

  final FijkPlayer player;
  final BuildContext buildContext;
  final Size viewSize;
  final Rect texturePos;
  // 播放器点击事件回调
  ValueChanged onTapPlayer;
  // 全屏点击事件回调
  ValueChanged onEntryFullScreen;
  // 是否全屏
  final bool isFullScreen;
  /// 播放器状态
  final FijkState oldFijkstate;
  /// 是否有权限观看
  final bool hasPermission;

  CustomFijkWidgetBottom2({
    @required this.player,
    this.buildContext,
    this.viewSize,
    this.texturePos,
    this.onTapPlayer,
    this.onEntryFullScreen,
    this.isFullScreen,
    this.oldFijkstate,
    this.hasPermission : false,
  });

  @override
  _CustomFijkWidgetBottomState createState() => _CustomFijkWidgetBottomState();
}

class _CustomFijkWidgetBottomState extends State<CustomFijkWidgetBottom2 > {

  FijkPlayer get player => widget.player;
  /// 播放状态
  bool _playing = false;
  /// 是否显示状态栏+菜单栏
  bool isPlayShowCont = true;
  /// 总时长
  String duration = "00:00:00";
  /// 已播放时长
  String durrentPos = "00:00:00";
  /// 进度条总长度
  double maxDurations = 0.0;
  /// 流监听器
  StreamSubscription _currentPosSubs;
  /// 定时器
  Timer _timer;
  /// 进度条当前进度
  double sliderValue = 0.0;
  /// 显示弹窗提示
  bool isShowDialog = false;
  /// 弹窗展示次数
  int showTime = 0;

  @override
  void initState() {
    /// 提前加载
    /// 进行监听
    widget.player.addListener(_playerValueChanged);
    /// 接收流
    _currentPosSubs = widget.player.onCurrentPosUpdate.listen((v) {
      setState(() {
        /// 实时获取当前播放进度（进度条）
        this.sliderValue = v.inMilliseconds.toDouble();
        /// 实时获取当前播放进度（数字展示）
        durrentPos = v.toString().substring(0,v.toString().indexOf("."));
        /// 获取播放秒数
        String second = durrentPos.split(":")[2];
        if(double.parse(second) >= 30.0 && !isShowDialog && !widget.hasPermission){
          player.seekTo(30000);
          /// 播放状态
          if (player.value.state == FijkState.started){
            player.pause();
            isShowDialog = true;
            showTime++;
          }
        }
        if (isShowDialog && showTime == 1){
          showTime++;

          getShowDialog(context);

          // DialogUtil.buildPlayerDialog(context);
          /*Size size = MediaQuery.of(context).size;
          EdgeInsets ei = MediaQuery.of(context).padding;
          DialogUtil(
            marginTop: (size.height + ei.top + ei.bottom - 472)/2,
            content: buildPlayerDialogBody(context),
            onClose: (){Navigator.of(context).pop();},
          );*/
        }

      });
    });
    /// 初始化
    super.initState();

    /// 判断之前的播放状态，如果是播放状态，恢复播放
    if(widget.oldFijkstate == FijkState.started){
      player.start();
    }
  }

  /// 监听器
  void _playerValueChanged() {
    FijkValue value = player.value;
    /// 获取进度条总时长
    maxDurations = value.duration.inMilliseconds.toDouble();
    /// 获取展示的时长
    duration = value.duration.toString().substring(0,value.duration.toString().indexOf("."));
    /// 播放状态
    bool playing = (value.state == FijkState.started);
    if (playing != _playing) setState(() =>_playing = playing);

  }

  @override
  Widget build(BuildContext context) {
    Rect rect = Rect.fromLTRB(
      max(0.0, widget.texturePos.left),
      max(0.0, widget.texturePos.top),
      min(widget.viewSize.width, widget.texturePos.right),
      min(widget.viewSize.height, widget.texturePos.bottom),
    );
    Size size = MediaQuery.of(context).size;
    EdgeInsets ei = MediaQuery.of(context).padding;

    return Positioned.fromRect(
      rect: rect,
      child: GestureDetector(
        onTap: (){
          widget.onTapPlayer(player.state);
          setState(() {
            /// 显示 、隐藏  进度条+标题栏
            isPlayShowCont = !isPlayShowCont;
            /// 如果显示了  , 3秒后 隐藏进度条+标题栏
            if(isPlayShowCont) _timer = Timer(Duration(seconds: 3),()=>isPlayShowCont = false);

            if (isShowDialog && !widget.hasPermission){
              if (player.state == FijkState.started) {
                player.pause();
              }
              // DialogUtil.buildPlayerDialog(context);
              /*DialogUtil(
                marginTop: (size.height + ei.top + ei.bottom - 472)/2,
                content: buildPlayerDialogBody(context),
                onClose: (){Navigator.of(context).pop();},
              );*/

              getShowDialog(context);
              showTime++;
            }else{
              if (player.state == FijkState.started) {
                player.pause();
              } else {
                player.start();
              }
            }

          });
        },
        child:Container(
            color: Color.fromRGBO(0, 0, 0, 0.0),
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.symmetric(horizontal: 2),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                /// 标题栏
                !isPlayShowCont ? SizedBox() :Container(
                  color: Color.fromRGBO(0, 0, 0, 0.65),
                  height: 28,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        // color: Colors.green,
                        child: IconButton(icon: Icon(Icons.chevron_left,color: Colors.white,), onPressed: (){
                          // Navigator.pop(context);
                          Map<String,dynamic> map = Map();
                          map['isFullScreen'] = widget.isFullScreen;
                          map['playerState'] = player.state;
                          widget.onEntryFullScreen(map);
                        }),
                      )

                    ],
                  ),
                ),
                /// 控制条
                !isPlayShowCont ? SizedBox() : Container(
                  color: Color.fromRGBO(0, 0, 0, 0.65),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            _playing ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () => {
                            setState(() {
                              if (isShowDialog && !widget.hasPermission){
                                // DialogUtil.buildPlayerDialog(context);
                              }else{
                                widget.onTapPlayer(player.state);
                                _playing ? widget.player.pause() : widget.player.start();
                              }
                            }),
                          }
                      ),
                      Text("${durrentPos}",style: TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Medium'),),
                      /// 进度条 使用Slider滑动组件实现
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            //已拖动的颜色
                            activeTrackColor: Color(0xFFFFFFFF),
                            //未拖动的颜色
                            inactiveTrackColor: Color(0x80FFFFFF),
                            //提示进度的气泡的背景色
                            valueIndicatorColor: Colors.green,
                            //提示进度的气泡文本的颜色
                            valueIndicatorTextStyle: TextStyle(
                              color:Colors.white,
                            ),
                            //滑块中心的颜色
                            thumbColor: Color(0xFFFFFFFF),
                            //滑块边缘的颜色
                            overlayColor: Colors.white,
                            //对进度线分割后，断续线中间间隔的颜色
                            inactiveTickMarkColor: Colors.white,
                          ),
                          child: Slider(
                            value: this.sliderValue,
                            label: '${int.parse((this.sliderValue  / 3600000).toStringAsFixed(0))<10?'0'+(this.sliderValue  / 3600000).toStringAsFixed(0):(this.sliderValue  / 3600000).toStringAsFixed(0)}:${int.parse(((this.sliderValue  % 3600000) /  60000).toStringAsFixed(0))<10?'0'+((this.sliderValue  % 3600000) /  60000).toStringAsFixed(0):((this.sliderValue  % 3600000) /  60000).toStringAsFixed(0)}:${int.parse(((this.sliderValue  % 60000) /  1000).toStringAsFixed(0))<10?'0'+((this.sliderValue % 60000) /  1000).toStringAsFixed(0):((this.sliderValue  % 60000) /  1000).toStringAsFixed(0)}',
                            min: 0.0,
                            max: maxDurations,
                            divisions: 1000,
                            onChanged: (val){
                              ///转化成double
                              setState(() => this.sliderValue = val.floorToDouble());
                              /// 设置进度
                              player.seekTo(this.sliderValue.toInt());
                              //                            print(this.sliderValue);
                            },
                          ),
                        ),
                      ),
                      Text("${duration}",style: TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.w400,fontFamily: 'PingFang SC-Medium'),),
                      IconButton(
                          onPressed: (){

                            Map<String,dynamic> map = Map();
                            map['isFullScreen'] = widget.isFullScreen;
                            map['playerState'] = player.state;
                            widget.onEntryFullScreen(map);

                            /*setState(() {

                          });*/
                          },
                          icon: widget.isFullScreen ? Icon(Icons.fullscreen_exit) : Icon(Icons.fullscreen)
                      ),

                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// 关闭监听
    player.removeListener(_playerValueChanged);
    /// 关闭流回调
    _currentPosSubs?.cancel();
    super.dispose();
  }

  /// 开通会员弹窗内容
  Widget buildPlayerDialogBody(BuildContext context){
    Widget body = Stack(
      children: [
        Image.asset('lib/assets/images/vip_dialog_img.png',width: 348,height: 420,),
        Positioned(
          left: 79,
          top:158,
          child: Column(
            children: [
              Text('充值VIP，观看完整视频邀请好友，领取免费VIP',softWrap: true,style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFF7E3B0C),),),
              Text('颜射视频',style: TextStyle(fontSize: 12,fontFamily: 'PingFang SC-Medium',fontWeight: FontWeight.w400,color: Color(0xFF7E3B0C),),),
            ],
          ),
        ),
        Positioned(
          left: 89.5,
          top:353.5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 39,vertical: 10,),
            child:Text('开通会员',style: TextStyle(fontSize: 18,fontFamily: 'PingFang SC-Bold',fontWeight: FontWeight.bold,color: Color(0xFF7E3B0C),),),
          ),
        ),
      ],
    );
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
          content: BuyVipPage(),
          onClose: (){Navigator.of(context).pop();},
        );
      },
    );
  }


}