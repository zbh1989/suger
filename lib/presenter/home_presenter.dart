import 'dart:io';
import 'package:caihong_app/base/presenter/base_presenter.dart';
import 'package:caihong_app/pages/homePage.dart';
import 'package:caihong_app/utils/PreferenceUtils.dart';
import 'package:caihong_app/utils/db_utils.dart';
import 'package:caihong_app/utils/time_format_util.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

import '../network/api/network_api.dart';
import '../network/network_util.dart';


/**
 * 首页
 */
class HomePresenter extends BasePresenter<HomePageState> {
  String fileName, picName;
  bool isUpload;


  Future addMessage(String toUser, String msg, int messageType) async {
    DBManager.instance.initDB();
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) async {
      Map<String, dynamic> map = {};
      map["from_user"] = value;
      map["to_user"] = toUser;
      map["im_msg"] = msg;
      map["message_type"] = messageType;
      map["update_time"] = TimeFormatUtil.getCurrentDate();
      DBManager.instance.imMessageTable.insert(map);
    });
  }

}
