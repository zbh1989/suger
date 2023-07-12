import 'dart:math';

import 'package:caihong_app/style/style.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class TikTokButtonColumn extends StatelessWidget {
  final double bottomPadding;
  final bool isFavorite;
  final Function onFavorite;
  final Function onComment;
  final Function onShare;
  final Function onAvatar;
  final Map<String,dynamic> shortVideoInfo;
  const TikTokButtonColumn({
    Key key,
    this.bottomPadding,
    this.onFavorite,
    this.onComment,
    this.onShare,
    this.isFavorite: false,
    this.onAvatar,
    this.shortVideoInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SysSize.avatar,
      margin: EdgeInsets.only(
        bottom: bottomPadding ?? 50,
        right: 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Tapped(
            child: TikTokAvatar(),
            onTap: onAvatar,
          ),
          FavoriteIcon(
            onFavorite: onFavorite,
            isFavorite: isFavorite,
            likeNum: shortVideoInfo['likeNum'] ?? Random().nextInt(5000),
          ),
          _IconButton(
            icon: Image.asset('lib/assets/images/comment.png',width: 30,height: 30,),
            text: shortVideoInfo['commentNum']??Random().nextInt(5000).toString(),
            onTap: onComment,
          ),
          _IconButton(
            icon: Image.asset('lib/assets/images/share.png',width: 30,height: 30,),
            text: '赚钱',
            onTap: onShare,
          ),
          Container(
            width: SysSize.avatar,
            height: 22,
            margin: EdgeInsets.only(top: 10),
            /*decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SysSize.avatar / 2.0),
              // color: Colors.black.withOpacity(0.8),
            ),*/
          )
        ],
      ),
    );
  }
}

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    Key key,
    @required this.onFavorite,
    this.likeNum,
    this.isFavorite,
  }) : super(key: key);
  final bool isFavorite;
  final Function onFavorite;
  final int likeNum;

  @override
  Widget build(BuildContext context) {
    return _IconButton(
      icon: IconToText(
        Icons.favorite,
        size: 30,
        color: isFavorite ? ColorPlate.red : null,
      ),
      text: likeNum.toString(),
      onTap: onFavorite,
    );
  }
}

class TikTokAvatar extends StatelessWidget {

  // 主播头像图片
  final String anchorAvatarImg;

  const TikTokAvatar({
    Key key,
    this.anchorAvatarImg: "lib/assets/images/avator/001.webp",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      width: SysSize.avatar,
      height: SysSize.avatar,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(SysSize.avatar / 2.0),
        color: Colors.orange,
      ),
      child: ClipOval(
        child: Image.asset(anchorAvatarImg,fit: BoxFit.cover,),
      ),
    );
    Widget addButton = Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.purpleAccent,
      ),
      child: Icon(
        Icons.add,
        size: 16,
      ),
    );
    return Container(
      width: SysSize.avatar,
      height: 80,
      margin: EdgeInsets.only(bottom: 9),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[avatar, addButton],
      ),
    );
  }
}

/// 把IconData转换为文字，使其可以使用文字样式
class IconToText extends StatelessWidget {
  final IconData icon;
  final TextStyle style;
  final double size;
  final Color color;

  const IconToText(
    this.icon, {
    Key key,
    this.style,
    this.size,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      String.fromCharCode(icon.codePoint),
      style: style ??
          TextStyle(
            fontFamily: 'MaterialIcons',
            fontSize: size ?? 30,
            inherit: true,
            color: color,
          ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final Function onTap;
  const _IconButton({
    Key key,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shadowStyle = TextStyle(
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.15),
          offset: Offset(0, 1),
          blurRadius: 1,
        ),
      ],
    );
    Widget body = Column(
      children: <Widget>[
        Tapped(
          child: icon ?? Container(),
          onTap: onTap,
        ),
        Container(height: 2),
        Text(
          text ?? '??',
          style: StandardTextStyle.small,
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: DefaultTextStyle(
        child: body,
        style: shadowStyle,
      ),
    );
  }
}
