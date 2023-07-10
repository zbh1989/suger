import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/watchVideoPage.dart';
import '../utils/PreferenceUtils.dart';

class WatchVideoPagePresenter extends BasePresenter<WatchVideoPageState>{

  /**
   * 短视频
   */
  Future getGuessLikeVideoPages(int page,int limit) async {
    Future resp;
    Map<String, dynamic> queryParams = Map();
    queryParams["page"] = page;
    queryParams["limit"] = limit;
    await requestFutureData<String>(Method.post,
        url: Api.HOST_URL + Api.GUESS_LIKE_VIDEO_QUERY,
        queryParams: queryParams,
        onSuccess: (data) {
          if (data != null) {
            Map<String, dynamic> map = parseData(data);
            if(map['code'] == 200){
            // if(map['data']['code'] == 200){
              // result = Future.value(map['data']['data']);
              resp = Future.value(map['data']);
            }else{
              // view.showToast('猜你喜欢短视频接口:'+ map['data']['msg']);
              view.showToast('猜你喜欢短视频接口:'+ map['msg']);
            }
          }else{
            view.showToast('系统异常，请程序员查看...');
          }
        },
        onError: (code, msg) {
          view.showToast(msg);
        });
    return resp;
  }

  /**
   * 购买视频接口
   */
  void buyVideo(String videoId) {

    PreferenceUtils.instance.getString("userId").then((userId){

      Map<String, dynamic> queryParams = Map();
      queryParams["videoId"] = videoId;
      queryParams["userId"] = userId;

      requestFutureData<String>(Method.post,
        url: Api.HOST_URL + Api.BUY_VIDEO_GOLD,
        queryParams: queryParams,
        onSuccess: (data) {
          if (data != null) {
            Map<String, dynamic> map = parseData(data);
            if(map['code'] == 200){
            // if(map['data']['code'] == 200){
              /// 扣除金币成功
              view.refreshPage(true,2);
            }else if(map['code'] == 202){/// 已经购买过
              view.refreshPage(true,1);
            }else{
              // view.showToast('购买视频接口:'+ map['data']['msg']);
              /// TODO: 这里要弹窗提示充值
              view.refreshPage(false,2);
            }
          }else{
            view.showToast('系统异常，请程序员查看...');
          }
          return Future.value(data);
        },
        onError: (code, msg) {
          view.showToast(msg);
        });

    });

    print('xxxx');

  }

}