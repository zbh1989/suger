import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:caihong_app/network/exception/error_status.dart';
import 'package:caihong_app/network/network_util.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../network/api/network_api.dart';
import '../../utils/PreferenceUtils.dart';
import '../view/i_base_view.dart';

class BasePresenter<V extends IBaseView> {

  V view;

  CancelToken _cancelToken;

  BasePresenter() {
    _cancelToken = CancelToken();
  }

  @override
  void deactivate() {}

  @override
  void didChangeDependencies() {}

  @override
  void didUpdateWidget<W>(W oldWidget) {}

  @override
  void dispose() {
    if (_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }

  @override
  void initState() {}

  Future requestFutureData<T>(Method method,
      {String url,
      bool isShow: false,
      bool isClose: false,
      Function(T t) onSuccess,
      Function(List<T> list) onSuccessList,
      Function(int code, String msg) onError,
      dynamic params,
      Map<String, dynamic> queryParams,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) async {
    if (isShow) {
      view.showProgress();
    }
    await DioUtils.instance.requestDataFuture<T>(method, url,
        params: params,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onSuccess: (data) {
          if (isClose) view.closeProgress();
          if (onSuccess != null) {
            onSuccess(data);
          }
        },
        onSuccessList: (data) {
          if (isClose) view.closeProgress();
          if (onSuccessList != null) onSuccessList(data);
        }, onError: (code, msg) {
          if (isClose) view.closeProgress();
          _onError(code, msg, onError);
        });
  }

  void requestDataFromNetwork<T>(Method method,
      {String url,
      bool isShow: true,
      bool isClose: true,
      Function(T t) onSuccess,
      Function(List<T> list) onSuccessList,
      Function(int code, String msg) onError,
      dynamic params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) {
    ///展示加载圈
      if (isShow) view.showProgress();
      DioUtils.instance.requestData<T>(method, url,
        params: params,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
        isList: isList, onSuccess: (data) {
          ///请求数据成功
          if (isClose) view.closeProgress();
          if (onSuccess != null) {
            onSuccess(data);
          }

          ///请求列表成功
        }, onSuccessList: (data) {
          if (isClose) view.closeProgress();
          if (onSuccessList != null) {
            onSuccessList(data);
          }

          ///请求错误
        }, onError: (code, msg) {
          _onError(code, msg, onError);
        }
      );
  }

  _onError(int code, String msg, Function(int code, String msg) onError) {
    view.closeProgress();
    if (code != ErrorStatus.CANCEL_ERROR) {
      view.showToast(msg);
    }

    if (onError != null && view.getContext() != null) {
      onError(code, msg);
    }
  }



  /// 查询设备号
  Future<String> _deviceDetails() async{
    String deviceId;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceId = build.androidId;
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor; //
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return deviceId;
  }

  /// 自动注册登录
  Future autoLogin({Function callback}) {
    Future<String> result = _deviceDetails();

    result.then((value) async {
      if(value == null){
        print('获取设备ID失败');
      }else{
        String imei = value;
        Map<String, dynamic> queryParams = Map();
        queryParams["imei"] = imei;
        queryParams["cno"] = Api.cno;
        await requestFutureData<String>(Method.post,
          url: Api.HOST_URL + Api.LOGIN,
          queryParams: queryParams,
          onSuccess: (data) {
            Map<String, dynamic> map = parseData(data);
            // Map userInfo = map['data']['data'];
            Map userInfo = map['data'];
            if (userInfo != null) {
              PreferenceUtils.instance.saveString("userId", userInfo['id']);
              PreferenceUtils.instance.saveString("imei", imei);
              PreferenceUtils.instance.saveString("login_status", "1"); // 登录状态 1：登录成功， 0： 失败
              PreferenceUtils.instance.saveInteger("cronNum", userInfo['cronNum']); // 砖石 或者 金币数量
              PreferenceUtils.instance.saveInteger("vipStatus", userInfo['vipStatus']); // 是否是vip; 1: 是; 0 不是
              PreferenceUtils.instance.saveString("spreadCode", userInfo['spreadCode']); // 推广码
              PreferenceUtils.instance.saveInteger("spreadNum", userInfo['spreadNum'] == null ? 0 : userInfo['spreadNum']); // 推广码
              PreferenceUtils.instance.saveInteger("tmpViewNum", userInfo['tmpViewNum']); // 观影券
              PreferenceUtils.instance.saveInteger("checkNum", userInfo['checkNum']); // 连续签到天数
              PreferenceUtils.instance.saveString("endVipDate", userInfo['endVipDate']); // VIP 过期时间; yyyy-MM-dd
              PreferenceUtils.instance.saveInteger("endVipDateNum", userInfo['endVipDateNum']); // 剩余VIP天数
              PreferenceUtils.instance.saveString("username", userInfo['username']); // 用户名

              if(callback != null) {
                callback();
              }
            } else {
              print('用户登录失败.');
            }
          }, onError: (code, msg) {
            print('用户登录异常：$msg');
            view.closeProgress();
          });
      }
    });
  }

}
