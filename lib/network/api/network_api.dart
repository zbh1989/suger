/**
 * 请求接口
 */

class Api {

  /// 渠道号，每次打包更新 按渠道号
  static final String cno = 'C003';

  /// 打包版本号.
  static const int appVersion = 1;

  /// 接口文档地址  http://206.238.76.51:10001/doc.html

  static const String SCHEMA = "http";

  static const String HOST = "206.238.76.51";

  static const int PORT = 10001;

  /// 服务器域名
  static const String HOST_URL = "http://api.yssps.vip/"; /// http://206.238.76.51:10001/

  /// 服务器域名
  static const String WS_HOST_URL = "ws://api.yssps.vip/"; // ws://206.238.76.51:10001/

  /// 本地测试
  static const String LOCAL_WEBSOCKET_URL = "ws://192.168.43.112:81/api/websocket/";

  /// WebSocket URL
  static const String WEBSOCKET_URL = "api/websocket/";

  /// 专题列表查询接口
  static const String TOPIC_LIST = "api/type/topic/list";

  /// 顶部菜单接口查询
  static const String TOP_MENU_LIST = "api/type/nav/list";

  /// 首页显示
  static const String FIRST_PAGE_QUERERY = 'api/type/home/list';

  /// 首页轮播图广告
  static const String FIRST_PAGE_SWIP_INFO = 'api/ads/homeBalance';

  /// 查询视频图片
  static const String FIRST_PAGE_VIDEO_PIC = 'api/video/list';

  /// 查询短视频
  static const String SHORT_VIDEO_QUERY = 'api/video/short';

  /// 查询猜你喜欢
  static const String GUESS_LIKE_VIDEO_QUERY = 'api/video/recommend';

  /// 注册登录
  static const String LOGIN = "api/user/login";

  /// 推荐视频
  static const String RECOMMAND_VIDEO = "api/video/recommend";

  /// 收藏视频
  static const String COLLECTION_VIDEO = "api/user/favorite/list";

  /// 购买视频
  static const String MY_BUY_VIDEO = "api/user/buy/list";

  /// 点赞收藏,更新观看次数
  static const String UPDATE_USER_ACTION = "api/user/action/insert";

  /// 点赞 收藏 查询
  static const String USER_ACTION_QUERY = "api/user/action/list";

  /// 删除收藏
  static const String USER_ACTION_DELETE = "api/user/action/remove";

  /// APP 配置信息
  static const String APP_CONFIG_INFO = "api/app/config";

  /// APP 启动页广告
  static const String APP_START_PAGE_ADS = "api/ads/startPage";

  /// 充值金币
  static const String CHARGE_GOLDEN = "api/order/create";

  /// 查询订单
  static const String QUERY_ORDER_INFO = "api/order/query";

  /// 视频购买扣除金币接口
  static const String BUY_VIDEO_GOLD = "api/video/buy/status";

  /// 视频检索
  static const String SEARCH_VIDEO_BY_NAME = "api/video/search";

  /// 用户签到
  static const String USER_SIGN = "api/user/checkIn";

  /// 用户签到记录
  static const String USER_SIGN_HIS = "api/user/checkList";

  /// 公告记录
  static const String ADVOCE_MSG_QUERY = "api/notify/list";

  /// 金币等级
  static const String GOLD_LIST_QUERY = "api/level/goldList";

  /// 绑定邀请码
  static const String BIND_INVITE_CODE = "api/user/bindPromCode";

  /// VIP(售卖)等级
  static const String VIP_LEVEL_QUERY = "api/level/list";

  /// 查询历史聊天记录
  static const String CHAT_HIS_QUERY = "api/user/msg/list";

  /// 清理历史聊天记录
  static const String CHAT_HIS_CLEAR = "api/user/msg/flush";

  /// 绑定手机号码
  static const String BIND_PHONE = "api/user/bind/phone";

  /// 查询推广用户
  static const String SUBORDINATE_USER = "api/user/subordinateUser";

  static const String API_URL = "";

}
