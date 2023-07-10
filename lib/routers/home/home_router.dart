import 'package:fluro/fluro.dart';
import 'package:caihong_app/routers/common/router_init.dart';
import 'package:caihong_app/pages/homePage.dart';

class HomeRouter implements IRouterProvider {
  static String homePage = "/home/index";

  @override
  void initRouter(FluroRouter router) {
    router.define(homePage,
        handler: Handler(handlerFunc: (_, params) => HomePage()));
  }
}
