import 'package:http/http.dart' as http;

import '../network/api/network_api.dart';

class HttpUtil {
  static void get(String url, Function callback,
      {Map<String, String> params, Function errorCallback}) async {
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }
    try {
      Uri uri = Uri(scheme: Api.SCHEMA, host: Api.HOST,port: Api.PORT, path: url);
      http.Response res = await http.get(uri);
      if (callback != null) {
        callback(res.body);
      }
    } catch (exception) {
      if (errorCallback != null) {
        errorCallback(exception);
      }
    }
  }

  static void post(String url, Function callback,
      {Map<String, String> params, Function errorCallback}) async {
    try {
      Uri uri = Uri(scheme: Api.SCHEMA, host: Api.HOST,port: Api.PORT, path: url);
      http.Response res = await http.post(uri, body: params);

      if (callback != null) {
        callback(res.body);
      }
    } catch (e) {
      if (errorCallback != null) {
        errorCallback(e);
      }
    }
  }
}