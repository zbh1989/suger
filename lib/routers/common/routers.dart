
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:caihong_app/pages/homePage.dart';
import 'package:caihong_app/routers/common/router_init.dart';
import 'package:caihong_app/webview/webview_page.dart';
class Routes {

  static String home = "/home";
  static String webViewPage = "/webview";

  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(FluroRouter router) {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        debugPrint("未找到目标页");
        return Container();
      });

    router.define(home, handler: Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) => HomePage()));
    
    router.define(webViewPage, handler: Handler(handlerFunc: (_, params){
      String title = params['title']?.first;
      String url = params['url']?.first;
      return WebViewPage(title:title,url:url);
    }));
    
    _listRouter.clear();
    /// 各自路由由各自模块管理，统一在此添加初始化
    // _listRouter.add(HomeRouter());
    // _listRouter.add(AboutRouter());
  
    /// 初始化路由
    _listRouter.forEach((routerProvider){
      routerProvider.initRouter(router);
    });
  }
}
