

import 'package:dio/dio.dart';

import 'network_util.dart';

main() async {
/*  var response = await DioUtils.instance.request('POST','http://206.238.76.51:10001/api/ads/homeBalance?limit=10&page=1',
      queryParameters: {},
      options: _setOptions(method, options),
      cancelToken: cancelToken);*/


}

Options _setOptions(String method, Options options) {
  if (options == null) {
    options = new Options();
  }
  options.method = method;
  return options;
}