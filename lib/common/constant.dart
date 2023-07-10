class Constant{
  ///debug的开关，由于控制上限的需要关闭的业务
  ///App运行Release时候,inProduction为true; 为Debug的时候为false
  static const bool inProduction = const bool.fromEnvironment("dart.vm.product");


  static const String data = "data";
  static const String message = "message";
  static const String code = "code";

  // 第一页
  static const int first_page_num = 1;

  // 轮播图开关开启
  static const int swiper_open = 1;
  // 轮播图开关关闭
  static const int swiper_close= 2;

  // 视频板块
  static const int topic_type_video = 1;

  // 广告板块
  static const int topic_type_ad = 2;
}