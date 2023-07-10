import 'package:flutter/material.dart';

class FijkPanelCenterController extends StatefulWidget {
  final Size size;
  final void Function() onTap;
  final void Function() onDoubleTap;
  final void Function(TapUpDetails) onTapUp; //抬起
  final void Function(TapDownDetails) onTapDown; //按下
  final double currentTime;
  final void Function(double) onHorizontalStart;
  final void Function(double) onHorizontalChange;
  final void Function(double) onHorizontalEnd;
  final double currentBrightness;
  final void Function(double) onLeftVerticalStart;
  final void Function(double) onLeftVerticalChange;
  final void Function(double) onLeftVerticalEnd;
  final double currentVolume;
  final void Function(double) onRightVerticalStart;
  final void Function(double) onRightVerticalChange;
  final void Function(double) onRightVerticalEnd;
  final Widget Function(BuildContext context) builderChild;

  /// 自定义的触摸控制器
  /// @param {Size} size - 框大小
  /// @param {void Function()?} onTap -
  /// @param {void Function()?} onDoubleTap -
  /// @param {double} currentTime - 传入当前视频时间onHorizontal时计算用得到
  /// @param {void Function(double)?} onHorizontalStart -
  /// @param {void Function(double)?} onHorizontalChange -
  /// @param {void Function(double)?} onHorizontalEnd -
  /// @param {double} currentBrightness - 传入当前系统亮度onLeftVertical时计算用得到
  /// @param {void Function(double)?} onLeftVerticalStart - 左边上下拖动(亮度)
  /// @param {void Function(double)?} onLeftVerticalChange -
  /// @param {void Function(double)?} onLeftVerticalEnd -
  /// @param {double} currentVolume - 传入当前系统声音onRightVertical时计算用得到
  /// @param {void Function(double)?} onRightVerticalStart - 右边上下拖动(声音)
  /// @param {void Function(double)?} onRightVerticalChange -
  /// @param {void Function(double)?} onRightVerticalEnd -
  /// @param {Widget Function(BuildContext context)} builderChild - 子节点内容直接由外界传入
  /// ```
  const FijkPanelCenterController({
    @required this.size,
    this.onTap,
    this.onDoubleTap,
    this.onTapUp,
    this.onTapDown,
    @required this.currentTime,
    this.onHorizontalStart,
    this.onHorizontalChange,
    this.onHorizontalEnd,
    @required this.currentBrightness,
    this.onLeftVerticalStart,
    this.onLeftVerticalChange,
    this.onLeftVerticalEnd,
    @required this.currentVolume,
    this.onRightVerticalStart,
    this.onRightVerticalChange,
    this.onRightVerticalEnd,
    @required this.builderChild,
  });

  @override
  State<StatefulWidget> createState() {
    return _FijkPanelCenterController();
  }
}

class _FijkPanelCenterController extends State<FijkPanelCenterController> {
  /// 上下滑动时在开始的时候记录 0-左边 1-右边
  int verticalType = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onTapUp: widget.onTapUp,
      onTapDown: widget.onTapDown,
      onHorizontalDragStart: (details) {
        widget.onHorizontalStart?.call(widget.currentTime);
      },
      onHorizontalDragUpdate: (details) {
        // 来自上次更新以来，指针在事件接收器的坐标空间中沿主轴移动的量。
        double deltaDx = details.delta.dx;
        if (deltaDx == 0) {
          return; // 避免某些手机会返回0.0
        }
        var dragValue = (deltaDx * 4000) + widget.currentTime;
        widget.onHorizontalChange?.call(dragValue);
      },
      onHorizontalDragEnd: (details) {
        widget.onHorizontalEnd?.call(widget.currentTime);
      },
      onVerticalDragStart: (details) {
        double dx = details.localPosition.dx;
        var winWidth = context.size?.width ?? 0;
        if (dx < winWidth / 2) {
          verticalType = 0;
          widget.onLeftVerticalStart?.call(widget.currentBrightness);
        } else {
          verticalType = 1;
          widget.onRightVerticalStart?.call(widget.currentVolume);
        }
      },
      onVerticalDragUpdate: (details) {
        double deltaDy = details.delta.dy;
        if (deltaDy == 0) {
          return; // 避免某些手机会返回0.0
        }
        double moveTo = 0;
        if (deltaDy > 0) {
          moveTo = -0.01;
        } else {
          moveTo = 0.01;
        }
        double dragValue = 0;
        switch (verticalType) {
          case 0:
            dragValue = moveTo + widget.currentBrightness;
            if (dragValue > 1) {
              dragValue = 1;
            } else if (dragValue < 0) {
              dragValue = 0;
            }
            print("设置亮度$dragValue");
            widget.onLeftVerticalChange?.call(dragValue);
            break;
          case 1:
            dragValue = moveTo + widget.currentVolume;
            if (dragValue > 1) {
              dragValue = 1;
            } else if (dragValue < 0) {
              dragValue = 0;
            }
            print("设置声音$dragValue");
            widget.onRightVerticalChange?.call(dragValue);
            break;
          default:
        }
      },
      onVerticalDragEnd: (details) {
        switch (verticalType) {
          case 0:
            widget.onLeftVerticalEnd?.call(widget.currentBrightness);
            break;
          case 1:
            widget.onRightVerticalEnd?.call(widget.currentVolume);
            break;
          default:
        }
      },
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        color: Colors.transparent,
        child: widget.builderChild(context),
      ),
    );
  }
}