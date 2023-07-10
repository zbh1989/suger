import 'dart:async';
import 'dart:io';

import 'package:caihong_app/pages/homePage.dart';
import 'package:caihong_app/pages/openVipPage.dart';
import 'package:caihong_app/pages/shortVideoPage.dart';
import 'package:caihong_app/pages/swiperPage.dart';
import 'package:caihong_app/presenter/splashScreenPresenter.dart';
import 'package:caihong_app/style/style.dart';
import 'package:caihong_app/views/openVipDialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../network/exception/error_status.dart';
import '../network/net_response.dart';
import '../network/network_util.dart';


void main() async {
  Map<String, dynamic> queryParameters = Map();
  queryParameters['page'] = 1;
  queryParameters['limit'] = 10;
  queryParameters['title'] = '91';

  /* var resp = await DioUtils.instance.getDio().request(
      'http://206.238.76.51:10001/api/video/search',
       options: _setOptions('POST', null),
      data:null,
      cancelToken: CancelToken(),
      queryParameters: queryParameters);*/

  var response = await DioUtils.instance.getDio().request(
      'http://206.238.76.51:10001/api/video/search',
      options: _setOptions('POST', null),
      // data:null,
      // cancelToken: CancelToken(),
      queryParameters: queryParameters);

  BaseResponse(ErrorStatus.REQUEST_DATA_OK, "success", response.data);
  print(response);
}


///用于配置Options
Options _setOptions(String method, Options options) {
  if (options == null) {
    options = new Options();
  }
  options.method = method;
  return options;
}

class DioDemo{

}
