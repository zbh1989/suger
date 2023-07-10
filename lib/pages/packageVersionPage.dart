import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import '../network/api/network_api.dart';
import '../utils/PreferenceUtils.dart';
import '../utils/toast.dart';
import 'checkUpdate.dart';

/**
 * 打包升级版本
 */
class CheckUpdateVersion {

  int newVersion;

  int oldVersion;

  bool needUpdate = false;

  int forceUpdate;

  String appDownloadUrl;

  CheckUpdate checkUpdate = CheckUpdate();

  void check() async {

    Future.wait([
      PreferenceUtils.instance.getString("appVersion").then((val){
        if(val == null){
          newVersion = int.parse('99999');
        }else{
          newVersion = int.parse(val);
        }
      }),

      PreferenceUtils.instance.getInteger("updateStatus").then((val){
        forceUpdate = val;
      }),

      PreferenceUtils.instance.getString("appDownloadUrl").then((val){
        appDownloadUrl = val;
      }),

      PackageInfo.fromPlatform().then((val) {
        oldVersion = int.parse(val.version.split('.')[2]);//获取当前的版本号
      })
    ]).then((res) async {
      if(newVersion > oldVersion){
        // Toast.show('更新版本 新版号：$newVersion 旧版本号：$oldVersion 开始...');
        /// 更新升级
        needUpdate = true;
        Map param = Map();
        param['isForce'] = forceUpdate;
        param['versionName'] = newVersion.toString();
        param['apkUrl'] = appDownloadUrl + '/Android/V$newVersion/APP_' + Api.cno + '.apk';
        param['apkSize'] = 30.21*1024;
        param['versionCode'] = newVersion.toString();
        param['updateLog'] = '';

        if (Platform.isAndroid) { // 安卓弹窗提示本地下载， 交由flutter_xupdate 处理，不用我们干嘛。
          await checkUpdate.initXUpdate();
          checkUpdate.checkUpdateByUpdateEntity(param); // flutter_xupdate 自定义JSON 方式，
        } else if (Platform.isIOS) { // IOS 跳转 AppStore
          // showIOSDialog(); // 弹出ios提示更新框
        }
        // Toast.show('更新版本 新版号：$newVersion 旧版本号：$oldVersion 结束...');
      }else{
        // Toast.show('新版号：$newVersion 旧版本号：$oldVersion 版本号一致，无需更新...');
      }
    }).catchError((err){
      print('查询版本信息异常.' + err.toString());
    });

  }

}