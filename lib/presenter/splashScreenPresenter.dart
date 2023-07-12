import 'package:caihong_app/base/presenter/base_presenter.dart';
import 'package:caihong_app/network/api/network_api.dart';
import 'package:caihong_app/network/network_util.dart';
import 'package:caihong_app/utils/PreferenceUtils.dart';
import '../main.dart';



/**
 * 启动页查询数据
 */

class SplashScreenPresenter extends BasePresenter<SplashScreenState> {


  /// 查询启动页广告
  Future<void> getAppStartPageInfo() async {

    Map<String, dynamic> queryParams = Map();
    await requestFutureData<String>(
        Method.post,
        url: Api.HOST_URL + Api.APP_START_PAGE_ADS,
        queryParams: queryParams,
        onSuccess: (data) {
          Map<String, dynamic> map = parseData(data);
          // List configInfoList = map['data']['data'];
          List configInfoList = map['data'];
          if (configInfoList != null && configInfoList.length > 0) {
            List adList = [];
            configInfoList.forEach((ele) {adList.add({'img':ele['img']});});
            view.refreshPage(adList,null);
          } else {
            print('获取APP启动页配置信息失败.');
          }
        }, onError: (code, msg) {
          view.closeProgress();
        });
  }


  /// APP 配置信息
  Future<void> getAppConfig() async {

    Map<String, dynamic> queryParams = Map();
    await requestFutureData<String>(
        Method.post,
        url: Api.HOST_URL + Api.APP_CONFIG_INFO,
        queryParams: queryParams,
        onSuccess: (data) {
          Map<String, dynamic> map = parseData(data);
          // Map configInfo = map['data']['data'];
          Map configInfo = map['data'];
          if (configInfo != null) {
            /// 打包和更新版本用到，很重要
            /// *****************************************************************
            PreferenceUtils.instance.saveString("cno", Api.cno); // 渠道号
            
            ///  版本和 包大小
            String versionAndSize = configInfo['appVersion'];
            if(versionAndSize != null && versionAndSize.split('#').length > 1){
              var versionSizeArr = versionAndSize.split('#');
              PreferenceUtils.instance.saveString("appVersion", versionSizeArr[0]); // 版本号
              PreferenceUtils.instance.saveString("appSize", versionSizeArr[1]); // 包大小
            }else{
              PreferenceUtils.instance.saveString("appVersion", configInfo['appVersion']); // 版本号
              PreferenceUtils.instance.saveString("appSize", '30'); // 包大小
            }

            /// *****************************************************************

            PreferenceUtils.instance.saveString("landingPage", configInfo['landingPage'] + Api.cno); // APP下載落地頁
            PreferenceUtils.instance.saveString("payUrl", configInfo['payUrl']); // 支付接口
            PreferenceUtils.instance.saveString("callUrl", configInfo['callUrl']); // 支付回掉地址
            PreferenceUtils.instance.saveString("token", configInfo['token']); // 支付密鈅
            PreferenceUtils.instance.saveString("appId", configInfo['appId']); // APP ID
            PreferenceUtils.instance.saveInteger("videoStartTime", configInfo['videoStartTime']); // 视频预览开始时间
            PreferenceUtils.instance.saveInteger("videoEndTime", configInfo['videoEndTime']); // 视频预览结束时间

            PreferenceUtils.instance.saveInteger("updateStatus", configInfo['updateStatus']); // 是否强制更新，1 表示强制更新
            PreferenceUtils.instance.saveString("appDownloadUrl", configInfo['appDownloadUrl']); // 是否强制更新，1 表示强制更新
          } else {
            print('获取APP配置信息失败.');
          }
        }, onError: (code, msg) {
          view.closeProgress();
        });
  }


  /**
   * 查询公告信息
   */
  void getAdvoceMsg() async {
    Map<String, dynamic> queryParams = Map();
    try{
      await requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.ADVOCE_MSG_QUERY,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
                String advoce = map['data'][0]['content'];
                view.refreshPage(null,advoce);
              }else{
                // view.showToast(map['data']['msg']);
                view.showToast(map['msg']);
              }
            }else{
              view.showToast('系统异常，请程序员查看...');
            }
          },
          onError: (code, msg) {
            view.showToast(msg);
          });
    }catch(e){
      print('请求查询菜单按钮接口异常：$e');
    }
  }

}