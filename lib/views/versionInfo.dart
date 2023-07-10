import 'package:caihong_app/pages/buyVipPage.dart';
import 'package:flutter/material.dart';

import '../pages/openVipPage.dart';

/**
 *  版本信息
 */
class VersionInfo extends StatelessWidget {

  VersionInfo({this.channel,this.version,});

  final String channel;

  final String version;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          height: 30,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0x001A0258),
                Color(0xFF3D0363),
              ],
            ),
          ),
        ),
        preferredSize:  Size(MediaQuery.of(context).size.width, 45),
      ),
      body: Center(
        child: Text('版本信息 $channel-$version'),
      ),
    );

  }

}
