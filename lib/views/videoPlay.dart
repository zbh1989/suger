import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

/**
 * 视频播放 (抽取出来做一个单独组件，做一些自定义皮肤，未完成)
 */
class VideoPlay extends StatefulWidget {

  final String videoUrl;

  final FijkPlayer player;

  VideoPlay({
    Key key,
    @required this.videoUrl,
    @required this.player,

  }) : super(key: key);

  @override
  VideoPlayState createState() => VideoPlayState();


}

class VideoPlayState extends State<VideoPlay>{

  @override
  void initState() {
    super.initState();
    widget.player.stop();
    widget.player.reset();
    widget.player.setDataSource(widget.videoUrl,autoPlay: true,showCover: true);
  }


  @override
  void dispose() {
    super.dispose();
    widget.player.release();
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    return FijkView(
      height: 220,
      width: width,
      fit: FijkFit.fitWidth,
      player: widget.player,
      color: Colors.black,
    );
  }

}

